import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../widgets/confetti.dart';
import '../../widgets/wood_grain.dart';
import '../../widgets/viking_mascot.dart';
import '../setup/player.dart' show playerColors;
import 'game_controller.dart';
import 'share_card.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';

/// Full-screen, personalized win celebration (SPEC.md §3.3): the winner's
/// name and color star in it, the mascot cheers, confetti falls — and per
/// §3.7 nothing ever blocks input: every button is live from the first
/// frame, the entry motion is pure decoration on top of final state.
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

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Color.alphaBlend(
            winnerColor.withValues(alpha: IKubbAlpha.activeTint),
            IKubbPalette.forestDeep,
          ),
        ),
        const WoodGrainBackground(
          color: IKubbPalette.birchLight,
          opacity: IKubbAlpha.grain,
        ),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: IKubbLayout.maxOverlay,
              ),
              child: SingleChildScrollView(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.9, end: 1),
                  duration: IKubbMotion.gentle,
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Padding(
                    padding: const EdgeInsets.all(IKubbSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const VikingMascot(pose: MascotPose.cheer, size: 150),
                        const SizedBox(height: IKubbSpacing.md),
                        Text(
                          l10n.winnerBanner(winner.name),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: IKubbType.stepHero,
                                color: IKubbPalette.birchLight,
                              ),
                        ),
                        const SizedBox(height: IKubbSpacing.xl),
                        for (final state in game.sideStates)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: IKubbSpacing.xs,
                            ),
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
                        const SizedBox(height: IKubbSpacing.xxl),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: IKubbPalette.birchLight,
                            foregroundColor: IKubbPalette.forestDeep,
                          ),
                          onPressed: () => ref
                              .read(gameControllerProvider.notifier)
                              .newGame(),
                          child: Text(l10n.rematch),
                        ),
                        const SizedBox(height: IKubbSpacing.md),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: IKubbPalette.birchLight,
                            side: const BorderSide(
                              color: IKubbPalette.birchLight,
                            ),
                          ),
                          onPressed: () => showShareDialog(
                            context,
                            game: game,
                            winnerColor: winnerColor,
                          ),
                          icon: Icon(Icons.adaptive.share),
                          label: Text(l10n.share),
                        ),
                        const SizedBox(height: IKubbSpacing.md),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: IKubbPalette.birchLight,
                            side: const BorderSide(
                              color: IKubbPalette.birchLight,
                            ),
                          ),
                          onPressed: () => context.go('/setup'),
                          child: Text(l10n.newGame),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const ConfettiBurst(),
      ],
    );
  }
}
