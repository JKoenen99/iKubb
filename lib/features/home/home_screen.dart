import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../widgets/viking_mascot.dart';
import '../../widgets/wood_grain.dart';
import '../game/game_controller.dart';
import '../game/game_mode.dart';
import '../kubb/kubb_controller.dart';
import '../../theme/glass.dart';
import '../../theme/tokens.dart';

/// Landing screen after onboarding: quick start front and center.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final game = ref.watch(gameControllerProvider);
    final match = ref.watch(kubbControllerProvider);
    final mode = ref.watch(lastModeProvider);
    // One active game across both modes: the last-played mode owns Home's
    // primary action.
    final kubbResumable =
        mode == GameMode.classicKubb && match.hasEvents && !match.isFinished;
    final resumable =
        kubbResumable ||
        (mode == GameMode.numberKubb &&
            game.throws.isNotEmpty &&
            game.winner == null);
    final resumeRoute = kubbResumable ? '/kubb' : '/game';
    final resumeSummary = kubbResumable
        ? match.sides.indexed
              .map((e) => '${e.$2.name} ${match.currentGame.baseline[e.$1]}')
              .join(' · ')
        : game.sideStates.map((s) => '${s.side.name} ${s.score}').join(' · ');

    // Quick start never lands on a stale win overlay: a finished game
    // restarts as a rematch, and untouched defaults get localized names.
    void quickStart() {
      if (mode == GameMode.classicKubb) {
        ref
            .read(kubbControllerProvider.notifier)
            .quickStart(defaultNames: (l10n.teamA, l10n.teamB));
        context.go('/kubb');
      } else {
        ref
            .read(gameControllerProvider.notifier)
            .quickStart(defaultName: l10n.playerN);
        context.go('/game');
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          WoodGrainBackground(
            color: IKubbPalette.woodGrain(Theme.of(context).brightness),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(IKubbSpacing.sm),
                child: glassIconButton(
                  context,
                  IconButton(
                    tooltip: l10n.settings,
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: IKubbLayout.maxColumn,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(IKubbSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const VikingMascot(size: 140),
                      const SizedBox(height: IKubbSpacing.sm),
                      Text(
                        l10n.appTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(l10n.tagline, textAlign: TextAlign.center),
                      const SizedBox(height: IKubbSpacing.huge),
                      // An interrupted game takes over as the primary
                      // action: resuming beats restarting (SPEC.md §3.5).
                      if (resumable)
                        FilledButton.icon(
                          onPressed: () => context.go(resumeRoute),
                          icon: const Icon(Icons.play_arrow),
                          label: Text(
                            l10n.resumeGameSummary(resumeSummary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        FilledButton(
                          onPressed: quickStart,
                          child: Text(l10n.quickStart),
                        ),
                      const SizedBox(height: IKubbSpacing.md),
                      FilledButton.tonal(
                        onPressed: () => context.push('/setup'),
                        child: Text(l10n.newGame),
                      ),
                      const SizedBox(height: IKubbSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.push('/rules'),
                              child: Text(l10n.rules),
                            ),
                          ),
                          const SizedBox(width: IKubbSpacing.md),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.push('/stats'),
                              child: Text(l10n.stats),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
