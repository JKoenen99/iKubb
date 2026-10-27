import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import 'feedback_controller.dart';
import 'feedback_event.dart';
import 'feedback_sheet.dart';
import 'star_rating.dart';

/// The in-the-moment ask: one line and five stars, inline, never modal.
/// A tap on a star opens the full form prefilled with that rating; "Not
/// now" records a dismissal and folds the card away. It decides its own
/// eligibility, so callers simply place it where the moment is right
/// (the win overlay, the last tour card) and it renders nothing when the
/// rules say not now.
class FeedbackPromptCard extends ConsumerStatefulWidget {
  const FeedbackPromptCard({
    super.key,
    required this.trigger,
    required this.title,
    this.eventContext = const {},
    this.onDark = false,
  });

  final FeedbackTrigger trigger;
  final String title;

  /// Trigger-specific facts stored with the event (game mode, players...).
  final Map<String, Object?> eventContext;

  /// Styled for the celebration scrim instead of a light surface.
  final bool onDark;

  @override
  ConsumerState<FeedbackPromptCard> createState() => _FeedbackPromptCardState();
}

class _FeedbackPromptCardState extends ConsumerState<FeedbackPromptCard> {
  bool _decided = false;
  bool _show = false;
  bool _thanks = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _decide();
  }

  /// Decided once, when the state and game count are available, so the
  /// card never pops in or out while the player is looking at it.
  void _decide() {
    if (_decided) return;
    final games = ref.read(finishedGameCountProvider);
    final stateReady = ref.read(feedbackControllerProvider).hasValue;
    if (games == null || !stateReady) return;
    _decided = true;
    final controller = ref.read(feedbackControllerProvider.notifier);
    _show = controller.shouldPrompt(widget.trigger, finishedGames: games);
    if (_show) {
      controller.markPrompted(widget.trigger, finishedGames: games).ignore();
    }
  }

  Future<void> _rate(int stars) async {
    final result = await showFeedbackSheet(
      context,
      trigger: widget.trigger,
      initialRating: stars,
      eventContext: widget.eventContext,
    );
    if (!mounted) return;
    setState(() {
      _show = false;
      _thanks = result != null;
    });
    if (result?.storeReview ?? false) {
      await ref.read(feedbackControllerProvider.notifier).requestStoreReview();
    }
  }

  void _notNow() {
    ref
        .read(feedbackControllerProvider.notifier)
        .record(
          trigger: widget.trigger,
          response: FeedbackResponse.dismissed,
          locale: Localizations.localeOf(context),
          context: widget.eventContext,
        )
        .ignore();
    setState(() => _show = false);
  }

  @override
  Widget build(BuildContext context) {
    // Re-evaluate once the async inputs land (first frame after launch).
    ref.watch(finishedGameCountProvider);
    ref.watch(feedbackControllerProvider);
    _decide();
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final fg = widget.onDark ? KaatoPalette.birchLight : scheme.onSurface;
    final bg = widget.onDark
        ? KaatoPalette.birchLight.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest;

    if (_thanks) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: KaatoSpacing.sm),
        child: Text(
          l10n.feedbackThanks,
          textAlign: TextAlign.center,
          style: KaatoType.emphasis.copyWith(color: fg),
        ),
      );
    }
    if (!_show) return const SizedBox.shrink();

    return Semantics(
      container: true,
      child: AnimatedContainer(
        duration: KaatoMotion.resolve(context, KaatoMotion.base),
        padding: const EdgeInsets.fromLTRB(
          KaatoSpacing.lg,
          KaatoSpacing.md,
          KaatoSpacing.lg,
          KaatoSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(KaatoRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: KaatoType.strong.copyWith(color: fg),
            ),
            const SizedBox(height: KaatoSpacing.xs),
            StarRating(
              value: 0,
              onChanged: _rate,
              idleColor: fg.withValues(alpha: 0.6),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: fg),
              onPressed: _notNow,
              child: Text(l10n.feedbackNotNow),
            ),
          ],
        ),
      ),
    );
  }
}
