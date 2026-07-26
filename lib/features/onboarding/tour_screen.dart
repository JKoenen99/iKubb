import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/viking_mascot.dart';
import '../game/game_mode.dart';
import '../game/pin_diagram.dart';
import '../rules/rule_illustrations.dart';
import '../setup/setup_controller.dart';
import 'onboarding_state.dart';

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
  var _mode = GameMode.numberKubb;

  /// Mode card + five rule cards.
  static const _pageCount = 6;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish(BuildContext context) {
    markOnboardingSeen();
    // Land in setup with the toured mode preselected — the tour's choice
    // carries through instead of being asked twice.
    ref.read(setupControllerProvider.notifier).setMode(_mode);
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
      child: const VikingMascot(pose: MascotPose.cheer, size: 150),
    ),
  ];

  List<Widget> _kubbCards(AppLocalizations l10n) => [
    _TourCard(
      title: l10n.ruleKubbFieldTitle,
      body: l10n.ruleKubbFieldBody,
      child: const KubbFieldSchematic(scale: 1.4),
    ),
    _TourCard(
      title: l10n.ruleKubbBatonsTitle,
      body: l10n.ruleKubbBatonsBody,
      child: ruleIllustration('kubbBatons'),
    ),
    _TourCard(
      title: l10n.ruleKubbThrowInTitle,
      body: l10n.ruleKubbThrowInBody,
      child: ruleIllustration('kubbThrowIn'),
    ),
    _TourCard(
      title: l10n.ruleKubbFieldFirstTitle,
      body: l10n.ruleKubbFieldFirstBody,
      child: ruleIllustration('kubbFieldFirst'),
    ),
    _TourCard(
      title: l10n.ruleKubbKingTitle,
      body: l10n.ruleKubbKingBody,
      child: const VikingMascot(pose: MascotPose.cheer, size: 150),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = _page == _pageCount - 1;
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Skip stays visible on every card (SPEC.md §3.1).
          TextButton(onPressed: () => _finish(context), child: Text(l10n.skip)),
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
                      _ModePickCard(
                        selected: _mode,
                        onPick: (m) => setState(() => _mode = m),
                      ),
                      ...(_mode == GameMode.classicKubb
                          ? _kubbCards(l10n)
                          : _numberCards(l10n)),
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
                              : Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
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

/// The fork: which game is being learned? Both options stay one tap away
/// throughout — picking just swaps the five cards that follow.
class _ModePickCard extends StatelessWidget {
  const _ModePickCard({required this.selected, required this.onPick});

  final GameMode selected;
  final ValueChanged<GameMode> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.tourModePickTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.tourModePickBody,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 24),
            _ModeOption(
              icon: Icons.tag,
              title: l10n.modeNumber,
              description: l10n.tourModeNumberDesc,
              selected: selected == GameMode.numberKubb,
              onTap: () => onPick(GameMode.numberKubb),
            ),
            const SizedBox(height: 12),
            _ModeOption(
              icon: Icons.workspace_premium,
              title: l10n.modeKubb,
              description: l10n.tourModeKubbDesc,
              selected: selected == GameMode.classicKubb,
              onTap: () => onPick(GameMode.classicKubb),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: scheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_circle, color: scheme.primary),
            ],
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
    // Center the card content vertically (UX audit #5) — scrolls only
    // when it genuinely doesn't fit.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (child != null) ...[child!, const SizedBox(height: 24)],
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
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
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 16),
            RollingNumber(
              value: score,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.catScoring,
              style: Theme.of(context).textTheme.headlineMedium,
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
      ),
    );
  }
}
