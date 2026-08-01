import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../../widgets/home_leading.dart';
import '../game/game_controller.dart' show sideColorsProvider;
import '../game/game_mode.dart';
import '../../widgets/celebration.dart';
import '../../widgets/dot_row.dart';
import '../../widgets/keep_awake.dart';
import '../../widgets/share_card.dart';
import '../../widgets/side_card.dart';
import '../../widgets/confirm_dialog.dart';
import '../rules/rules_content.dart';
import '../rules/rules_view.dart';
import '../settings/haptics.dart';
import '../setup/player.dart' show playerColors;
import 'kubb_controller.dart';
import 'kubb_field.dart';
import '../../theme/tokens.dart';

/// Classic kubb (SPEC: teams + king): the attacker always plays from the
/// bottom of the field; tap the blocks a baton felled, confirm per baton.
/// Same screen grammar as the number-kubb game: home leading, rules, undo,
/// overflow, win overlay — different game vocabulary.
class KubbScreen extends ConsumerStatefulWidget {
  const KubbScreen({super.key});

  @override
  ConsumerState<KubbScreen> createState() => _KubbScreenState();
}

class _KubbScreenState extends ConsumerState<KubbScreen> {
  final Set<int> _selectedField = {};
  final Set<int> _selectedBaseline = {};
  Timer? _clock;
  int _secondsLeft = 0;

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void _resetSelection() {
    _selectedField.clear();
    _selectedBaseline.clear();
  }

  void _syncClock(KubbMatch match) {
    final seconds = match.rules.turnClockSeconds;
    if (seconds == null || match.currentGame.isFinished) {
      _clock?.cancel();
      _clock = null;
      return;
    }
    if (match.currentGame.batonsThrown == 0 || _clock == null) {
      _secondsLeft = seconds;
    }
    _clock ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) setState(() => _secondsLeft--);
    });
  }

  void _confirmBaton() {
    final controller = ref.read(kubbControllerProvider.notifier);
    controller.applyEvent(
      KubbBaton(
        felledField: _selectedField.length,
        felledBaseline: _selectedBaseline.length,
      ),
    );
    setState(_resetSelection);
    Haptics.light(ref);
  }

  Future<void> _tapKing(KubbGame game) async {
    final l10n = AppLocalizations.of(context)!;
    if (!game.canHitKing) {
      // Early king = instant loss: warn by feel, confirm destructively.
      Haptics.medium(ref);
      final confirmed = await confirmAdaptive(
        context,
        title: l10n.kingWarningTitle,
        body: l10n.kingWarningBody,
        confirmLabel: l10n.kingLabel,
        isDestructive: true,
      );
      if (!confirmed) return;
    }
    setState(_resetSelection);
    ref
        .read(kubbControllerProvider.notifier)
        .applyEvent(const KubbBaton(hitKing: true));
    Haptics.heavy(ref);
  }

  Future<void> _confirmNewMatch() async {
    final l10n = AppLocalizations.of(context)!;
    final match = ref.read(kubbControllerProvider);
    if (match.hasEvents && !match.isFinished) {
      final confirmed = await confirmAdaptive(
        context,
        title: l10n.newMatchConfirmTitle,
        body: l10n.newMatchConfirmBody,
        confirmLabel: l10n.newGame,
        isDestructive: true,
      );
      if (!confirmed) return;
    }
    setState(_resetSelection);
    ref.read(kubbControllerProvider.notifier).newMatch();
  }

  @override
  Widget build(BuildContext context) {
    final match = ref.watch(kubbControllerProvider);
    final game = match.currentGame;
    final l10n = AppLocalizations.of(context)!;
    _syncClock(match);

    return KeepAwake(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.modeKubb),
          leading: homeLeading(context),
          actions: [
            IconButton(
              tooltip: l10n.rules,
              onPressed: () =>
                  showRulesPanel(context, mode: GameMode.classicKubb),
              icon: const Icon(Icons.help_outline),
            ),
            IconButton(
              tooltip: l10n.undo,
              onPressed: match.hasEvents
                  ? () {
                      Haptics.light(ref);
                      setState(_resetSelection);
                      ref.read(kubbControllerProvider.notifier).undo();
                    }
                  : null,
              icon: const Icon(Icons.undo),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.adaptive.more),
              onSelected: (value) => switch (value) {
                'scoreboard' => context.push('/scoreboard'),
                'stats' => context.push('/stats'),
                _ => _confirmNewMatch(),
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'scoreboard',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.scoreboard_outlined),
                    title: Text(l10n.scoreboardMode),
                  ),
                ),
                PopupMenuItem(
                  value: 'stats',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.bar_chart),
                    title: Text(l10n.stats),
                  ),
                ),
                PopupMenuItem(
                  value: 'newGame',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.restart_alt),
                    title: Text(l10n.newGame),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: IKubbLayout.maxContent,
                  ),
                  child: Column(
                    children: [
                      _KubbStandings(
                        match: match,
                        clockSeconds:
                            match.rules.turnClockSeconds == null ||
                                game.isFinished
                            ? null
                            : _secondsLeft,
                      ),
                      Expanded(child: _field(game, l10n)),
                      if (!game.isFinished) _controls(game, l10n),
                    ],
                  ),
                ),
              ),
            ),
            if (game.isFinished)
              match.isFinished
                  ? _KubbMatchOverlay(
                      match: match,
                      onRematch: () {
                        setState(_resetSelection);
                        ref.read(kubbControllerProvider.notifier).newMatch();
                      },
                    )
                  : _KubbGameOverlay(
                      match: match,
                      onNextGame: () {
                        setState(_resetSelection);
                        ref.read(kubbControllerProvider.notifier).nextGame();
                      },
                    ),
          ],
        ),
      ),
    );
  }

  /// The field, attacker always at the bottom.
  Widget _field(KubbGame game, AppLocalizations l10n) {
    final defender = game.sides[game.defenderIndex];
    final attacker = game.sides[game.attackerIndex];
    final baselineUnlocked = _selectedField.length == game.targetFieldStanding;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: IKubbSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: IKubbSpacing.xs),
          Text(defender.name, style: Theme.of(context).textTheme.titleMedium),
          // Defender baseline: locked behind the field kubbs.
          KubbBlockRow(
            key: const Key('baselineRow'),
            standing: game.baseline[game.defenderIndex],
            felled:
                game.rules.baselineKubbs - game.baseline[game.defenderIndex],
            selectedIndices: _selectedBaseline,
            onToggle: (i) {
              Haptics.selection(ref);
              setState(() {
                if (_selectedBaseline.contains(i)) {
                  _selectedBaseline.remove(i);
                } else if (baselineUnlocked) {
                  _selectedBaseline.add(i);
                }
              });
            },
            labelBuilder: (i, {required down}) => down
                ? l10n.kubbSelectedSemantics(i + 1)
                : l10n.kubbStandingSemantics(i + 1),
          ),
          if (game.targetFieldStanding > 0) ...[
            const SizedBox(height: IKubbSpacing.sm),
            KubbBlockRow(
              key: const Key('fieldRow'),
              blockWidth: 22,
              blockHeight: 30,
              standing: game.targetFieldStanding,
              felled: 0,
              selectedIndices: _selectedField,
              onToggle: (i) {
                Haptics.selection(ref);
                setState(() {
                  if (_selectedField.contains(i)) {
                    _selectedField.remove(i);
                    _selectedBaseline.clear();
                  } else {
                    _selectedField.add(i);
                  }
                });
              },
              labelBuilder: (i, {required down}) => down
                  ? l10n.kubbSelectedSemantics(i + 1)
                  : l10n.kubbStandingSemantics(i + 1),
            ),
          ],
          const SizedBox(height: IKubbSpacing.lg),
          KubbKing(
            onTap: () => _tapKing(game),
            semanticLabel: game.canHitKing
                ? l10n.kingSafeSemantics
                : l10n.kingRiskySemantics,
          ),
          const SizedBox(height: IKubbSpacing.lg),
          if (game.advantageActive) ...[
            // The chip doubles as a deep link into the advantage rule.
            Semantics(
              button: true,
              label: l10n.advantageLine,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showRulesPanel(
                  context,
                  mode: GameMode.classicKubb,
                  categoryId: KubbRuleCategoryIds.advantage,
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: IKubbTap.min),
                  alignment: Alignment.center,
                  child: AdvantageLine(label: l10n.advantageLine),
                ),
              ),
            ),
            const SizedBox(height: IKubbSpacing.sm),
          ],
          if (game.field[game.attackerIndex] > 0)
            KubbBlockRow(
              blockWidth: 18,
              blockHeight: 24,
              standing: game.field[game.attackerIndex],
              felled: 0,
            ),
          Text(
            attacker.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          // Batons left this turn: filled = still in hand.
          DotRow(
            count: game.rules.batonsPerTurn,
            filled: game.batonsRemaining,
            activeColor: IKubbPalette.walnut,
            idleColor: IKubbPalette.walnut.withValues(
              alpha: IKubbAlpha.dotIdle,
            ),
            size: IKubbIconSize.md,
            padding: const EdgeInsets.all(IKubbSpacing.xs),
            semanticLabel: l10n.batonsLeftSemantics(
              game.batonsRemaining,
              game.rules.batonsPerTurn,
            ),
          ),
          const SizedBox(height: IKubbSpacing.sm),
        ],
      ),
    );
  }

  Widget _controls(KubbGame game, AppLocalizations l10n) {
    if (game.phase == KubbPhase.throwIn) {
      return _ThrowInPanel(
        felled: game.felledThisTurn,
        onDone: (penalties) {
          ref
              .read(kubbControllerProvider.notifier)
              .applyEvent(KubbThrowIn(penalties: penalties));
        },
      );
    }
    final selection = _selectedField.length + _selectedBaseline.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        IKubbSpacing.lg,
        0,
        IKubbSpacing.lg,
        IKubbSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonal(
              onPressed: selection == 0 ? _confirmBaton : null,
              child: Text(l10n.miss),
            ),
          ),
          const SizedBox(width: IKubbSpacing.md),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: selection == 0 ? null : _confirmBaton,
              child: Text(l10n.confirmThrowCount(selection)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Standings header: both teams, baseline kubbs remaining, match dots.
class _KubbStandings extends ConsumerWidget {
  const _KubbStandings({required this.match, this.clockSeconds});

  final KubbMatch match;
  final int? clockSeconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final sideColors = ref.watch(sideColorsProvider);
    final game = match.currentGame;
    return Padding(
      padding: const EdgeInsets.all(IKubbSpacing.lg),
      child: Row(
        children: [
          for (var i = 0; i < 2; i++)
            Expanded(
              child: ActiveSideCard(
                isActive: i == game.attackerIndex && !game.isFinished,
                child: _sideSummary(context, i, sideColors),
              ),
            ),
          if (clockSeconds != null)
            Padding(
              padding: const EdgeInsets.only(left: IKubbSpacing.sm),
              child: Text(
                '$clockSeconds',
                style: IKubbType.score(
                  size: IKubbType.stepTitle,
                  color: clockSeconds! <= 10
                      ? IKubbPalette.danger(Theme.of(context).brightness)
                      : scheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sideSummary(
    BuildContext context,
    int i,
    Map<String, int> sideColors,
  ) {
    final game = match.currentGame;
    final isActive = i == game.attackerIndex && !game.isFinished;
    final scheme = Theme.of(context).colorScheme;
    final onColor = isActive ? scheme.onPrimary : scheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorDotName(
          color:
              playerColors[(sideColors[match.sides[i].id] ?? i) %
                  playerColors.length],
          name: match.sides[i].name,
          textColor: onColor,
        ),
        Text(
          '${game.baseline[i]}',
          style: IKubbType.score(size: IKubbType.stepScoreCard, color: onColor),
        ),
        if (match.rules.bestOf > 1)
          DotRow(
            count: match.rules.gamesToWin,
            filled: match.wins[i],
            activeColor: IKubbPalette.amber,
            idleColor: onColor.withValues(alpha: IKubbAlpha.dotIdle),
            padding: EdgeInsets.zero,
            semanticLabel:
                '${AppLocalizations.of(context)!.matchLabel}: '
                '${match.wins[i]}/${match.rules.gamesToWin}',
          ),
      ],
    );
  }
}

/// Between games of a best-of match: game result + next game.
class _KubbGameOverlay extends StatelessWidget {
  const _KubbGameOverlay({required this.match, required this.onNextGame});

  final KubbMatch match;
  final VoidCallback onNextGame;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final game = match.currentGame;
    final winner = game.winner!;
    return CelebrationScaffold(
      celebrate: false,
      banner: Text(
        game.earlyKing
            ? l10n.earlyKingBanner(
                match.sides[1 - match.sides.indexOf(winner)].name,
              )
            : l10n.winnerBanner(winner.name),
        textAlign: TextAlign.center,
        style: IKubbType.heading(
          size: IKubbType.stepScoreCard,
          color: IKubbPalette.birchLight,
        ),
      ),
      scoreLine: Text(
        l10n.matchScore(match.wins[0], match.wins[1]),
        textAlign: TextAlign.center,
        style: IKubbType.score(
          size: IKubbType.stepHero,
          color: IKubbPalette.birchLight,
        ),
      ),
      actions: [
        OverlayFilledButton(
          onPressed: onNextGame,
          child: Text(l10n.nextGameLabel),
        ),
      ],
    );
  }
}

/// Match over: full celebration in the shared win-overlay style.
class _KubbMatchOverlay extends ConsumerWidget {
  const _KubbMatchOverlay({required this.match, required this.onRematch});

  final KubbMatch match;
  final VoidCallback onRematch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final winner = match.matchWinner!;
    final sideColors = ref.watch(sideColorsProvider);
    final winnerColor =
        playerColors[(sideColors[winner.id] ?? match.sides.indexOf(winner)) %
            playerColors.length];
    final game = match.currentGame;
    return CelebrationScaffold(
      winnerColor: winnerColor,
      banner: CelebrationBanner(l10n.winnerBanner(winner.name)),
      scoreLine: Text(
        l10n.matchScore(match.wins[0], match.wins[1]),
        textAlign: TextAlign.center,
        style: IKubbType.score(
          size: IKubbType.stepScoreLg,
          color: IKubbPalette.birchLight,
        ),
      ),
      actions: [
        OverlayFilledButton(onPressed: onRematch, child: Text(l10n.rematch)),
        OverlayOutlinedButton(
          onPressed: () => showShareCardDialog(
            context,
            banner: l10n.winnerBanner(winner.name),
            rows: [
              for (final (i, side) in match.sides.indexed)
                ShareRow(
                  side.name,
                  match.rules.bestOf > 1
                      ? '${match.wins[i]}'
                      : '${game.baseline[i]}',
                  emphasized: side == winner,
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

/// After the batons: the defenders throw the felled kubbs in.
class _ThrowInPanel extends StatefulWidget {
  const _ThrowInPanel({required this.felled, required this.onDone});

  final int felled;
  final ValueChanged<int> onDone;

  @override
  State<_ThrowInPanel> createState() => _ThrowInPanelState();
}

class _ThrowInPanelState extends State<_ThrowInPanel> {
  int _penalties = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(IKubbSpacing.lg),
      padding: const EdgeInsets.all(IKubbSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(IKubbRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.throwInTitle, textAlign: TextAlign.center),
          const SizedBox(height: IKubbSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text(l10n.outTwice)),
              IconButton(
                tooltip: AppLocalizations.of(context)!.decreaseLabel,
                onPressed: _penalties > 0
                    ? () => setState(() => _penalties--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_penalties', style: IKubbType.statValue),
              IconButton(
                tooltip: AppLocalizations.of(context)!.increaseLabel,
                onPressed: _penalties < widget.felled
                    ? () => setState(() => _penalties++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: IKubbSpacing.xs),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => widget.onDone(_penalties),
              child: Text(l10n.done),
            ),
          ),
        ],
      ),
    );
  }
}
