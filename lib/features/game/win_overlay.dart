import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../../theme/tokens.dart';
import '../../widgets/celebration.dart';
import '../../widgets/share_card.dart';
import '../setup/player.dart' show playerColors;
import 'game_controller.dart';

/// Full-screen, personalized win celebration (SPEC.md §3.3): the winner's
/// name and color star in it, the mascot cheers, confetti falls.
class WinOverlay extends ConsumerWidget {
  const WinOverlay({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final winner = game.winner!;
    final sideColors = ref.watch(sideColorsProvider);
    final winnerIndex = game.sides.indexOf(winner);
    final winnerColor =
        playerColors[(sideColors[winner.id] ?? winnerIndex) %
            playerColors.length];

    return CelebrationScaffold(
      winnerColor: winnerColor,
      banner: CelebrationBanner(
        l10n.winnerBanner(winner.name),
        size: IKubbType.stepHero,
      ),
      details: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final state in game.sideStates)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: IKubbSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.side.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: IKubbType.statValue.copyWith(
                        color: IKubbPalette.birchLight,
                        fontWeight: state.side == winner
                            ? FontWeight.w800
                            : FontWeight.w500,
                        decoration: state.isEliminated
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Text(
                    '${state.score}',
                    style: IKubbType.statValue.copyWith(
                      color: IKubbPalette.birchLight,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        OverlayFilledButton(
          onPressed: () => ref.read(gameControllerProvider.notifier).newGame(),
          child: Text(l10n.rematch),
        ),
        OverlayOutlinedButton(
          onPressed: () => showShareCardDialog(
            context,
            banner: l10n.winnerBanner(winner.name),
            rows: [
              for (final state in game.sideStates)
                ShareRow(
                  state.side.name,
                  '${state.score}',
                  emphasized: state.side == winner,
                  struck: state.isEliminated,
                ),
            ],
            winnerColor: winnerColor,
          ),
          icon: Icon(Icons.adaptive.share),
          child: Text(l10n.share),
        ),
        OverlayOutlinedButton(
          onPressed: () => context.go('/setup'),
          child: Text(l10n.newGame),
        ),
      ],
    );
  }
}
