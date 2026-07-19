import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/viking_mascot.dart';
import '../setup/player.dart' show playerColors;
import 'game_controller.dart';

/// Big, glanceable field-side scoreboard (SPEC.md §3.4): prop the iPad up
/// and read scores from across the pitch. Scores update live from the
/// same game state as the scoring screen. Tap anywhere to return.
class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final sideColors = ref.watch(sideColorsProvider);
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pop(),
      child: Scaffold(
        backgroundColor: IKubbPalette.forestDeep,
        body: SafeArea(
          child: game.winner != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const VikingMascot(pose: MascotPose.cheer, size: 140),
                      Text(
                        l10n.winnerBanner(game.winner!.name),
                        textAlign: TextAlign.center,
                        style: IKubbType.heading(
                          size: 64,
                          color: IKubbPalette.birchLight,
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    for (var i = 0; i < game.sideStates.length; i++)
                      Expanded(
                        child: _ScoreboardColumn(
                          state: game.sideStates[i],
                          isActive: i == game.currentSideIndex,
                          missLimit: game.rules.missLimit,
                          showMissDots: game.rules.eliminationEnabled,
                          color:
                              playerColors[(sideColors[game.sides[i].id] ?? i) %
                                  playerColors.length],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ScoreboardColumn extends StatelessWidget {
  const _ScoreboardColumn({
    required this.state,
    required this.isActive,
    required this.missLimit,
    required this.showMissDots,
    required this.color,
  });

  final SideState state;
  final bool isActive;
  final int missLimit;
  final bool showMissDots;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.45) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? color : IKubbPalette.pine,
          width: isActive ? 4 : 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.side.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                IKubbType.heading(
                  size: 36,
                  color: state.isEliminated
                      ? IKubbPalette.berryLight
                      : IKubbPalette.birchLight,
                ).copyWith(
                  decoration: state.isEliminated
                      ? TextDecoration.lineThrough
                      : null,
                ),
          ),
          RollingNumber(
            value: state.score,
            style: IKubbType.score(
              size: 120,
              color: state.isEliminated
                  ? IKubbPalette.berryLight
                  : IKubbPalette.birchLight,
            ),
          ),
          if (showMissDots)
            // Bigger dots for across-the-field reading; only shown once a
            // miss streak exists (audit #6).
            SizedBox(
              height: 40,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: state.missStreak > 0 ? 1 : 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var m = 0; m < missLimit; m++)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.circle,
                          size: 26,
                          color: m < state.missStreak
                              ? IKubbPalette.berryLight
                              : IKubbPalette.birchLight.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
