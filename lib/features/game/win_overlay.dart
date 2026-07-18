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
            winnerColor.withValues(alpha: 0.45),
            IKubbPalette.forestDeep,
          ),
        ),
        const WoodGrainBackground(
          color: IKubbPalette.birchLight,
          opacity: 0.06,
        ),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.9, end: 1),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const VikingMascot(pose: MascotPose.cheer, size: 150),
                        const SizedBox(height: 12),
                        Text(
                          l10n.winnerBanner(winner.name),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 44,
                                color: IKubbPalette.birchLight,
                              ),
                        ),
                        const SizedBox(height: 24),
                        for (final state in game.sideStates)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.side.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
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
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: IKubbPalette.birchLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 32),
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
                        const SizedBox(height: 12),
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
