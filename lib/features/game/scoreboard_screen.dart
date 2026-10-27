import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/glass.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/dot_row.dart';
import '../../widgets/keep_awake.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/viking_mascot.dart';
import '../setup/player.dart' show playerColors;
import 'game_controller.dart';

/// Big, glanceable field-side scoreboard (SPEC.md §3.4): prop the iPad up
/// and read the game from across the pitch, live from the same state as
/// the play screen. Tap anywhere to return.
class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      const _NumberScoreboard();
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
                    color: KaatoPalette.berryLight,
                  )
                : null,
            dotsSemanticLabel: l10n.statMisses,
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
          backgroundColor: KaatoPalette.forestDeep,
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(KaatoSpacing.sm),
                    child: glassIconButton(
                      context,
                      IconButton(
                        tooltip: l10n.closeLabel,
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.close,
                          color: KaatoPalette.birchLight,
                        ),
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
                          style: KaatoType.heading(
                            size: KaatoType.stepDisplay,
                            color: KaatoPalette.birchLight,
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
        ? KaatoPalette.berryLight
        : KaatoPalette.birchLight;
    return AnimatedContainer(
      duration: KaatoMotion.resolve(context, KaatoMotion.base),
      margin: const EdgeInsets.all(KaatoSpacing.md),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: KaatoAlpha.activeTint)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(KaatoRadius.xl),
        border: Border.all(
          color: isActive ? color : KaatoPalette.pine,
          width: isActive ? KaatoBorder.frame : KaatoBorder.line,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KaatoType.heading(
              size: KaatoType.stepScoreLg,
              color: textColor,
            ).copyWith(decoration: struck ? TextDecoration.lineThrough : null),
          ),
          // Scales down on narrow columns (phone portrait) instead of
          // painting past the card.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RollingNumber(
              value: value,
              style: KaatoType.score(
                size: KaatoType.stepScoreboard,
                color: textColor,
              ),
            ),
          ),
          SizedBox(
            height: KaatoIconSize.field + 2 * KaatoSpacing.xs,
            child: dots == null
                ? null
                : DotRow(
                    count: dots!.count,
                    filled: dots!.filled,
                    activeColor: dots!.color,
                    idleColor: KaatoPalette.birchLight.withValues(
                      alpha: KaatoAlpha.dotIdle,
                    ),
                    size: KaatoIconSize.field,
                    padding: const EdgeInsets.all(KaatoSpacing.xs),
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
