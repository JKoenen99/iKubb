import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/glass.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import 'feedback_controller.dart';
import 'feedback_event.dart';
import 'feedback_tags.dart';
import 'star_rating.dart';

/// What the sheet produced. Null means it was closed without a verdict.
class FeedbackResult {
  const FeedbackResult({required this.rating, required this.storeReview});

  final int rating;

  /// The controller decided the native store prompt should follow.
  final bool storeReview;
}

/// The one feedback form: stars, Airbnb-style pills that follow the
/// rating (what worked / what to fix), an optional comment, one send
/// button. Opens as a bottom sheet so the game stays visible behind it.
///
/// Every outcome is recorded: a submission as `submitted`, a close after
/// picking stars as `dismissed` with the rating kept (abandonment is
/// data too). The caller handles the thank-you and the store prompt.
Future<FeedbackResult?> showFeedbackSheet(
  BuildContext context, {
  required FeedbackTrigger trigger,
  int initialRating = 0,
  Map<String, Object?> eventContext = const {},
}) async {
  final result = await showModalBottomSheet<FeedbackResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: !LiquidGlass.isCupertino(context),
    constraints: const BoxConstraints(maxWidth: KaatoLayout.maxPanel),
    builder: (context) => glassSheet(
      context,
      _FeedbackForm(
        trigger: trigger,
        initialRating: initialRating,
        eventContext: eventContext,
      ),
    ),
  );
  if (!context.mounted) return result;
  if (result != null) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.feedbackThanks)),
    );
  }
  return result;
}

class _FeedbackForm extends ConsumerStatefulWidget {
  const _FeedbackForm({
    required this.trigger,
    required this.initialRating,
    required this.eventContext,
  });

  final FeedbackTrigger trigger;
  final int initialRating;
  final Map<String, Object?> eventContext;

  @override
  ConsumerState<_FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends ConsumerState<_FeedbackForm> {
  late int _rating = widget.initialRating;
  final Set<String> _tags = {};
  final _comment = TextEditingController();
  bool _busy = false;
  bool _done = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  /// Closed without sending (swipe, barrier, Not now): whatever was picked
  /// is kept as a dismissal — abandonment is data too. Runs from the pop
  /// callback, while `ref` is still usable.
  void _recordDismissal() {
    if (_done) return;
    _done = true;
    ref
        .read(feedbackControllerProvider.notifier)
        .record(
          trigger: widget.trigger,
          response: FeedbackResponse.dismissed,
          locale: _locale,
          rating: _rating == 0 ? null : _rating,
          tags: _tags.toList(),
          context: widget.eventContext,
        )
        .ignore();
  }

  late final Locale _locale = Localizations.localeOf(context);

  Future<void> _submit() async {
    if (_rating == 0 || _busy) return;
    setState(() => _busy = true);
    final storeReview = await ref
        .read(feedbackControllerProvider.notifier)
        .record(
          trigger: widget.trigger,
          response: FeedbackResponse.submitted,
          locale: _locale,
          rating: _rating,
          tags: _tags.toList(),
          comment: _comment.text,
          context: widget.eventContext,
        );
    _done = true;
    if (!mounted) return;
    Navigator.of(context)
        .pop(FeedbackResult(rating: _rating, storeReview: storeReview));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tagIds = FeedbackTags.forRating(_rating == 0 ? null : _rating);
    final positive = _rating >= 4;
    // Switching between the two tag sets drops picks from the other set.
    _tags.retainAll(tagIds);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && result == null) _recordDismissal();
      },
      child: Padding(
        // Keyboard-aware: the sheet rises with the comment field.
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            KaatoSpacing.lg,
            0,
            KaatoSpacing.lg,
            KaatoSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.feedbackSheetTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: KaatoSpacing.sm),
              StarRating(
                value: _rating,
                onChanged: (v) => setState(() => _rating = v),
              ),
              if (_rating > 0) ...[
                const SizedBox(height: KaatoSpacing.lg),
                Text(
                  positive ? l10n.feedbackWhatLiked : l10n.feedbackWhatImprove,
                  style: KaatoType.strong,
                ),
                const SizedBox(height: KaatoSpacing.sm),
                Wrap(
                  spacing: KaatoSpacing.sm,
                  runSpacing: KaatoSpacing.xs,
                  children: [
                    for (final id in tagIds)
                      FilterChip(
                        label: Text(FeedbackTags.label(l10n, id)),
                        selected: _tags.contains(id),
                        onSelected: (on) => setState(() {
                          on ? _tags.add(id) : _tags.remove(id);
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: KaatoSpacing.lg),
                TextField(
                  controller: _comment,
                  maxLength: FeedbackEvent.maxCommentLength,
                  maxLines: 3,
                  minLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: l10n.feedbackCommentHint,
                  ),
                ),
              ],
              const SizedBox(height: KaatoSpacing.md),
              FilledButton(
                onPressed: _rating == 0 || _busy ? null : _submit,
                child: Text(l10n.feedbackSubmit),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.feedbackNotNow),
              ),
              const SizedBox(height: KaatoSpacing.xs),
              Text(
                l10n.feedbackPrivacyNote,
                textAlign: TextAlign.center,
                style: KaatoType.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
                      .withValues(alpha: KaatoAlpha.faded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
