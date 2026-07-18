import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../rules/rules_content.dart';
import '../rules/rules_view.dart';
import 'game_controller.dart';
import 'pin_diagram.dart';

/// The scoring tool: pin-tap input, "needs exactly X" helper, overshoot
/// warning, miss-streak dots, undo, and a personalized win banner.
///
/// This is the walking skeleton of SPEC.md §3.3 — number-pad mode, throw
/// editing, and the Rive win celebration hang off this screen later.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final Set<int> _selected = {};

  void _confirm() {
    ref.read(gameControllerProvider.notifier).confirmPins(_selected);
    setState(_selected.clear);
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final throwScore = Throw.pins(_selected).score;
    final current = game.currentSideIndex;
    final wouldBust = current != null &&
        throwScore > game.pointsNeeded(current) &&
        game.rules.overshootPolicy != OvershootPolicy.none;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.rules,
            onPressed: () => showRulesPanel(context),
            icon: const Icon(Icons.help_outline),
          ),
          IconButton(
            tooltip: l10n.undo,
            onPressed:
                game.throws.isEmpty ? null : ref.read(gameControllerProvider.notifier).undo,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            tooltip: l10n.newGame,
            onPressed: () => ref.read(gameControllerProvider.notifier).newGame(),
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Standings(game: game),
            const Spacer(),
            if (game.winner != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.winnerBanner(game.winner!.name),
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
              )
            else
              PinDiagram(
                selected: _selected,
                onToggle: (pin) => setState(() {
                  _selected.contains(pin) ? _selected.remove(pin) : _selected.add(pin);
                }),
              ),
            const Spacer(),
            if (game.winner == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: _selected.isEmpty ? _confirm : null,
                        child: Text(l10n.miss),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: _selected.isEmpty ? null : _confirm,
                        style: wouldBust
                            ? FilledButton.styleFrom(
                                backgroundColor: IKubbPalette.amber,
                                foregroundColor: IKubbPalette.ink,
                              )
                            : null,
                        child: Text(
                          wouldBust
                              ? l10n.overshootWarning(game.rules.overshootResult()!)
                              : '${l10n.confirmThrow} (+$throwScore)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      backgroundColor: scheme.surface,
    );
  }
}

class _Standings extends StatelessWidget {
  const _Standings({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (var i = 0; i < game.sideStates.length; i++)
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: i == game.currentSideIndex
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _SideCard(
                  state: game.sideStates[i],
                  isActive: i == game.currentSideIndex,
                  needsLine: l10n.needsExactly(game.pointsNeeded(i)),
                  missLimit: game.rules.missLimit,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SideCard extends StatelessWidget {
  const _SideCard({
    required this.state,
    required this.isActive,
    required this.needsLine,
    required this.missLimit,
  });

  final SideState state;
  final bool isActive;
  final String needsLine;
  final int missLimit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onColor = isActive ? scheme.onPrimary : scheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.side.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, color: onColor),
        ),
        Text(
          '${state.score}',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: state.isEliminated ? IKubbPalette.berry : onColor,
            decoration: state.isEliminated ? TextDecoration.lineThrough : null,
          ),
        ),
        if (isActive)
          Text(needsLine, style: TextStyle(fontSize: 12, color: onColor)),
        // Miss dots deep-link to their exact rule card (SPEC.md §3.6).
        InkWell(
          onTap: () =>
              showRulesPanel(context, categoryId: RuleCategoryIds.misses),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var m = 0; m < missLimit; m++)
                Icon(
                  Icons.circle,
                  size: 10,
                  color: m < state.missStreak
                      ? IKubbPalette.berry
                      : onColor.withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
