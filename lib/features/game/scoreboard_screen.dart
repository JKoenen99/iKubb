import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/dot_row.dart';
import '../../widgets/keep_awake.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/viking_mascot.dart';
import '../kubb/kubb_controller.dart';
import '../setup/player.dart' show playerColors;
import 'game_controller.dart';
import 'game_mode.dart';

/// Big, glanceable field-side scoreboard (SPEC.md §3.4): prop the iPad up
/// and read the game from across the pitch. It mirrors whichever mode is
/// running — scores for number kubb, kubbs remaining for classic — live
/// from the same state as the play screen. Tap anywhere to return.
class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(lastModeProvider) == GameMode.classicKubb) {
      return const _KubbScoreboard();
    }
    return const _NumberScoreboard();
  }
}

class _NumberScoreboard extends ConsumerWidget {
  const _NumberScoreboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final sideColors = ref.watch(sideColorsProvider);
    final l10n = AppLocalizations.of(context)!;
    return _ScoreboardShell(
      winnerName: game.winner?.name,
      columns: [
        for (var i = 0; i < game.sideStates.length; i++)
          _ScoreboardColumn(
            name: game.sideStates[i].side.name,
            value: game.sideStates[i].score,
            isActive: i == game.currentSideIndex && game.winner == null,
            struck: game.sideStates[i].isEliminated,
            color:
                playerColors[(sideColors[game.sides[i].id] ?? i) %
                    playerColors.length],
            dots:
                game.rules.eliminationEnabled &&
                    game.sideStates[i].missStreak > 0
                ? (
                    count: game.rules.missLimit,
                    filled: game.sideStates[i].missStreak,
                    color: IKubbPalette.berryLight,
                  )
                : null,
            dotsSemanticLabel: l10n.statMisses,
          ),
      ],
    );
  }
}

/// The classic-kubb variant: baseline kubbs remaining per team, match
/// dots for best-of, the attacker highlighted.
class _KubbScoreboard extends ConsumerWidget {
  const _KubbScoreboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final match = ref.watch(kubbControllerProvider);
    final game = match.currentGame;
    final sideColors = ref.watch(sideColorsProvider);
    final l10n = AppLocalizations.of(context)!;
    return _ScoreboardShell(
      winnerName: match.matchWinner?.name,
      columns: [
        for (var i = 0; i < 2; i++)
          _ScoreboardColumn(
            name: match.sides[i].name,
            value: game.baseline[i],
            isActive: i == game.attackerIndex && !game.isFinished,
            color:
                playerColors[(sideColors[match.sides[i].id] ?? i) %
                    playerColors.length],
            dots: match.rules.bestOf > 1
                ? (
                    count: match.rules.gamesToWin,
                    filled: match.wins[i],
                    color: IKubbPalette.amber,
                  )
                : null,
            dotsSemanticLabel: l10n.matchLabel,
          ),
      ],
    );
  }
}

/// Shared chrome: forest field, winner splash, tap-anywhere to return.
class _ScoreboardShell extends StatelessWidget {
  const _ScoreboardShell({required this.winnerName, required this.columns});

  final String? winnerName;
  final List<Widget> columns;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return KeepAwake(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.pop(),
        child: Scaffold(
          backgroundColor: IKubbPalette.forestDeep,
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(IKubbSpacing.sm),
                    child: IconButton(
                      tooltip: l10n.closeLabel,
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.close,
                        color: IKubbPalette.birchLight,
                      ),
                    ),
                  ),
                ),
                if (winnerName != null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const VikingMascot(pose: MascotPose.cheer, size: 140),
                        Text(
                          l10n.winnerBanner(winnerName!),
                          textAlign: TextAlign.center,
                          style: IKubbType.heading(
                            size: IKubbType.stepDisplay,
                            color: IKubbPalette.birchLight,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      for (final column in columns) Expanded(child: column),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreboardColumn extends StatelessWidget {
  const _ScoreboardColumn({
    required this.name,
    required this.value,
    required this.isActive,
    required this.color,
    this.struck = false,
    this.dots,
    this.dotsSemanticLabel,
  });

  final String name;
  final int value;
  final bool isActive;
  final Color color;

  /// Eliminated (number kubb).
  final bool struck;

  /// Optional dot strip under the number (miss streak / match wins).
  final ({int count, int filled, Color color})? dots;
  final String? dotsSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final textColor = struck
        ? IKubbPalette.berryLight
        : IKubbPalette.birchLight;
    return AnimatedContainer(
      duration: IKubbMotion.resolve(context, IKubbMotion.base),
      margin: const EdgeInsets.all(IKubbSpacing.md),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: IKubbAlpha.activeTint)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(IKubbRadius.xl),
        border: Border.all(
          color: isActive ? color : IKubbPalette.pine,
          width: isActive ? IKubbBorder.frame : IKubbBorder.line,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: IKubbType.heading(
              size: IKubbType.stepScoreLg,
              color: textColor,
            ).copyWith(decoration: struck ? TextDecoration.lineThrough : null),
          ),
          RollingNumber(
            value: value,
            style: IKubbType.score(
              size: IKubbType.stepScoreboard,
              color: textColor,
            ),
          ),
          SizedBox(
            height: IKubbSpacing.xxl,
            child: dots == null
                ? null
                : DotRow(
                    count: dots!.count,
                    filled: dots!.filled,
                    activeColor: dots!.color,
                    idleColor: IKubbPalette.birchLight.withValues(
                      alpha: IKubbAlpha.dotIdle,
                    ),
                    size: IKubbIconSize.field,
                    padding: const EdgeInsets.all(IKubbSpacing.xs),
                    semanticLabel: dotsSemanticLabel == null
                        ? null
                        : '$dotsSemanticLabel: ${dots!.filled}/${dots!.count}',
                  ),
          ),
        ],
      ),
    );
  }
}
