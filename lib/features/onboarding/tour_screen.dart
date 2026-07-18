import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/viking_mascot.dart';
import '../game/pin_diagram.dart';
import 'onboarding_state.dart';

/// "Teach me the game": swipeable illustrated rule cards, skippable at
/// every card, interactive where that teaches best (SPEC.md §3.1). Reuses
/// the localized rules content and the live game's PinDiagram so the
/// scoring screen feels familiar afterwards. Replayable from the rules
/// screen at any time.
class TourScreen extends StatefulWidget {
  const TourScreen({super.key});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  final _pageController = PageController();
  var _page = 0;
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
    _pageController.animateToPage(
      _page + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = _page == _pageCount - 1;
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Skip stays visible on every card (SPEC.md §3.1).
          TextButton(
            onPressed: () => _finish(context),
            child: Text(l10n.skip),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (p) => setState(() => _page = p),
                    children: [
                      _TourCard(
                        title: l10n.ruleFormationTitle,
                        body: l10n.ruleFormationBody,
                        child: const PinDiagram(
                            selected: {}, onToggle: null, pinSize: 48),
                      ),
                      const _ScoringDemoCard(),
                      _TourCard(
                        title: l10n.ruleOvershootTitle,
                        body: l10n.ruleOvershootBody,
                        child: const _OvershootIllustration(),
                      ),
                      _TourCard(
                        title: l10n.ruleMissesTitle,
                        body: l10n.ruleMissesBody,
                        child: const _MissDotsIllustration(),
                      ),
                      _TourCard(
                        title: l10n.ruleExactTitle,
                        body: l10n.ruleExactBody,
                        child:
                            const VikingMascot(pose: MascotPose.cheer, size: 150),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _pageCount; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: i == _page ? 22 : 8,
                        height: 8,
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: i == _page
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
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
  const _TourCard({required this.title, required this.body, this.child});

  final String title;
  final String body;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (child != null) ...[child!, const SizedBox(height: 24)],
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4)),
        ],
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
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
          const SizedBox(height: 16),
          RollingNumber(
            value: score,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.catScoring,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              explanation,
              key: ValueKey(explanation),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _OvershootIllustration extends StatelessWidget {
  const _OvershootIllustration();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 32, fontWeight: FontWeight.w800);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('47 + 8', style: style),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.arrow_forward, size: 32, color: IKubbPalette.amber),
        ),
        Text('25', style: style.copyWith(color: IKubbPalette.amber)),
      ],
    );
  }
}

class _MissDotsIllustration extends StatelessWidget {
  const _MissDotsIllustration();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.circle, size: 22, color: IKubbPalette.berry),
          ),
      ],
    );
  }
}
