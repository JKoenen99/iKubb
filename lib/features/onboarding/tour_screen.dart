import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/viking_mascot.dart';
import '../feedback/feedback_event.dart';
import '../feedback/feedback_prompt.dart';
import '../game/pin_diagram.dart';
import '../rules/rule_illustrations.dart';
import 'onboarding_state.dart';
import '../../theme/glass.dart';
import '../../theme/tokens.dart';
import '../../widgets/kaato_app_bar.dart';
import '../../theme/typography.dart';

/// "Teach me the game": swipeable illustrated rule cards, skippable at
/// every card, interactive where that teaches best (SPEC.md §3.1). The
/// first card forks by game mode; each branch reuses the localized rules
/// content and illustrations so the matching play screen feels familiar
/// afterwards. Replayable from the rules screen at any time.
class TourScreen extends ConsumerStatefulWidget {
  const TourScreen({super.key});

  @override
  ConsumerState<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends ConsumerState<TourScreen> {
  final _pageController = PageController();
  var _page = 0;

  /// Five rule cards.
  static const _pageCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish(BuildContext context) {
    markOnboardingSeen();
    context.go('/setup');
  }

  void _next() {
    if (_page >= _pageCount - 1) {
      _finish(context);
      return;
    }
    final duration = KaatoMotion.resolve(context, KaatoMotion.entrance);
    if (duration == Duration.zero) {
      _pageController.jumpToPage(_page + 1); // Reduce Motion: no slide
      return;
    }
    _pageController.animateToPage(
      _page + 1,
      duration: duration,
      curve: KaatoMotion.enter,
    );
  }

  List<Widget> _numberCards(AppLocalizations l10n) => [
    _TourCard(
      title: l10n.ruleFormationTitle,
      body: l10n.ruleFormationBody,
      child: const PinDiagram(selected: {}, onToggle: null, pinSize: 48),
    ),
    const _ScoringDemoCard(),
    _TourCard(
      title: l10n.ruleOvershootTitle,
      body: l10n.ruleOvershootBody,
      child: const OvershootIllustration(),
    ),
    _TourCard(
      title: l10n.ruleMissesTitle,
      body: l10n.ruleMissesBody,
      child: const MissDotsIllustration(),
    ),
    _TourCard(
      title: l10n.ruleExactTitle,
      body: l10n.ruleExactBody,
      footer: _tourFeedback(l10n, 'number_kubb'),
      child: const VikingMascot(pose: MascotPose.cheer, size: 150),
    ),
  ];

  /// Asked once, on the first completed tour: did the explanation land?
  Widget _tourFeedback(AppLocalizations l10n, String mode) =>
      FeedbackPromptCard(
        trigger: FeedbackTrigger.tourEnd,
        title: l10n.feedbackPromptTourTitle,
        eventContext: {'mode': mode},
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = _page == _pageCount - 1;
    return Scaffold(
      extendBodyBehindAppBar: LiquidGlass.isCupertino(context),
      appBar: KaatoAppBar(
        actions: [
          // Skip stays visible on every card (SPEC.md §3.1).
          TextButton(onPressed: () => _finish(context), child: Text(l10n.skip)),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: KaatoLayout.maxContent),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (p) => setState(() => _page = p),
                    children: _numberCards(l10n),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _pageCount; i++)
                      AnimatedContainer(
                        duration: KaatoMotion.resolve(
                          context,
                          KaatoMotion.quick,
                        ),
                        width: i == _page ? 22 : 8,
                        height: 8,
                        margin: const EdgeInsets.all(KaatoSpacing.xs),
                        decoration: BoxDecoration(
                          color: i == _page
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary
                                    .withValues(alpha: KaatoAlpha.dotIdle),
                          borderRadius: BorderRadius.circular(KaatoRadius.xs),
                        ),
                      ),
                  ],
                ),
                BottomActionBar(
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(isLast ? l10n.startScoring : l10n.next),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TourCard extends StatelessWidget {
  const _TourCard({
    required this.title,
    required this.body,
    this.child,
    this.footer,
  });

  final String title;
  final String body;
  final Widget? child;

  /// Below the body: the last card's feedback ask.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    // Center the card content vertically (UX audit #5) — scrolls only
    // when it genuinely doesn't fit.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(KaatoSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (child != null) ...[
              child!,
              const SizedBox(height: KaatoSpacing.xl),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: KaatoSpacing.md),
            Text(body, textAlign: TextAlign.center, style: KaatoType.reading),
            if (footer != null) ...[
              const SizedBox(height: KaatoSpacing.xl),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

/// The interactive card: tap pins, watch the score — the rule explains
/// itself as you play with it.
class _ScoringDemoCard extends StatefulWidget {
  const _ScoringDemoCard();

  @override
  State<_ScoringDemoCard> createState() => _ScoringDemoCardState();
}

class _ScoringDemoCardState extends State<_ScoringDemoCard> {
  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final score = Throw.pins(_selected).score;
    final explanation = switch (_selected.length) {
      0 => l10n.tourTryIt,
      1 => l10n.ruleOnePinBody,
      _ => l10n.ruleManyPinsBody,
    };
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(KaatoSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PinDiagram(
              selected: _selected,
              pinSize: 48,
              onToggle: (pin) => setState(() {
                _selected.contains(pin)
                    ? _selected.remove(pin)
                    : _selected.add(pin);
              }),
            ),
            const SizedBox(height: KaatoSpacing.lg),
            RollingNumber(
              value: score,
              style: Theme.of(context).textTheme.displayLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: KaatoSpacing.sm),
            Text(
              l10n.catScoring,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: KaatoSpacing.md),
            AnimatedSwitcher(
              duration: KaatoMotion.resolve(context, KaatoMotion.quick),
              child: Text(
                explanation,
                key: ValueKey(explanation),
                textAlign: TextAlign.center,
                style: KaatoType.reading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
