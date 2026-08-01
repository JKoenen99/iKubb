import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/dot_row.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/keep_awake.dart';
import '../../widgets/side_card.dart';
import '../rules/rules_content.dart';
import 'game_mode.dart';
import '../rules/rules_view.dart';
import '../setup/player.dart' show playerColors;
import 'game_controller.dart';
import 'input_mode.dart';
import 'mascot_reaction.dart';
import 'number_pad.dart';
import 'pin_diagram.dart';
import 'win_overlay.dart';
import '../../theme/tokens.dart';
import '../../widgets/confirm_dialog.dart';
import '../settings/haptics.dart';

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

  // Mascot reactions (SPEC.md §3.7): occasional, varied, never blocking.
  ReactionKind? _reaction;
  int _reactionSeq = 0;
  int _lastCheerThrow = -100;

  /// Derives a reaction from the newest throw. Oops moments (overshoot,
  /// elimination) always show — they're rare. Cheers are frequency-capped
  /// so they stay delightful.
  void _maybeReact(Game? previous, Game next) {
    if (previous == null ||
        next.throws.length != previous.throws.length + 1 ||
        next.records.isEmpty) {
      return; // undo, edit, or new game — never react to those.
    }
    final record = next.records.last;
    ReactionKind? kind;
    switch (record.outcome) {
      case ThrowOutcome.overshoot || ThrowOutcome.eliminated:
        kind = ReactionKind.oops;
      case ThrowOutcome.scored:
        final escapedElimination =
            next.rules.eliminationEnabled &&
            previous.sideStates[record.sideIndex].missStreak ==
                next.rules.missLimit - 1;
        final bigThrow =
            record.thrown.score >= 10 &&
            next.throws.length - _lastCheerThrow >= 5;
        if (escapedElimination || bigThrow) kind = ReactionKind.cheer;
      case ThrowOutcome.win || ThrowOutcome.miss:
        break; // the win has its own celebration; misses stay quiet.
    }
    if (kind == null) return;
    if (kind == ReactionKind.cheer) _lastCheerThrow = next.throws.length;
    setState(() {
      _reaction = kind;
      _reactionSeq++;
    });
  }

  void _confirm() {
    ref.read(gameControllerProvider.notifier).confirmPins(_selected);
    setState(_selected.clear);
    _hapticAfterThrow();
  }

  void _padScore(int score) {
    ref.read(gameControllerProvider.notifier).confirmScore(score);
    _hapticAfterThrow();
  }

  /// New game discards a running game — confirm first (HIG/Material:
  /// destructive actions need consent). Finished or empty games reset
  /// silently.
  Future<void> _confirmNewGame() async {
    final game = ref.read(gameControllerProvider);
    if (game.throws.isNotEmpty && game.winner == null) {
      final l10n = AppLocalizations.of(context)!;
      final confirmed = await confirmAdaptive(
        context,
        title: l10n.newGameConfirmTitle,
        body: l10n.newGameConfirmBody,
        confirmLabel: l10n.newGame,
        isDestructive: true,
      );
      if (!confirmed) return;
    }
    ref.read(gameControllerProvider.notifier).newGame();
  }

  void _hapticAfterThrow() {
    final game = ref.read(gameControllerProvider);
    if (game.winner != null) {
      Haptics.heavy(ref);
    } else if (game.records.isNotEmpty &&
        (game.records.last.outcome == ThrowOutcome.overshoot ||
            game.records.last.outcome == ThrowOutcome.eliminated)) {
      // A bad outcome should feel different from a routine score.
      Haptics.medium(ref);
    } else {
      Haptics.light(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gameControllerProvider, _maybeReact);
    final game = ref.watch(gameControllerProvider);
    final inputMode = ref.watch(inputModeProvider);
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return KeepAwake(
      child: Scaffold(
        // Three visible actions only (audit #4): rules and undo stay, the
        // rest lives in an overflow menu with labeled rows.
        appBar: AppBar(
          title: Text(l10n.appTitle),
          leading: homeLeading(context),
          actions: [
            IconButton(
              tooltip: l10n.rules,
              onPressed: () =>
                  showRulesPanel(context, mode: GameMode.numberKubb),
              icon: const Icon(Icons.help_outline),
            ),
            IconButton(
              tooltip: l10n.undo,
              onPressed: game.throws.isEmpty
                  ? null
                  : () {
                      Haptics.light(ref);
                      ref.read(gameControllerProvider.notifier).undo();
                    },
              icon: const Icon(Icons.undo),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.adaptive.more),
              onSelected: (value) => switch (value) {
                'scoreboard' => context.push('/scoreboard'),
                'stats' => context.push('/stats'),
                _ => _confirmNewGame(),
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
              // iPad/wide: standings beside the input area (SPEC.md §3.4);
              // tall/narrow: standings above it.
              child: LayoutBuilder(
                builder: (context, constraints) => constraints.maxWidth >= 840
                    ? Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: _Standings(game: game, vertical: true),
                            ),
                          ),
                          Expanded(flex: 3, child: _inputArea(game, inputMode)),
                        ],
                      )
                    : Column(
                        children: [
                          _Standings(game: game),
                          Expanded(child: _inputArea(game, inputMode)),
                        ],
                      ),
              ),
            ),
            if (_reaction != null && game.winner == null)
              Positioned(
                right: 16,
                bottom: 96,
                child: MascotReaction(
                  key: ValueKey(_reactionSeq),
                  kind: _reaction!,
                  onDone: () => setState(() => _reaction = null),
                ),
              ),
            if (game.winner != null) WinOverlay(game: game),
          ],
        ),
        backgroundColor: scheme.surface,
      ),
    );
  }

  /// The labeled mode switch lives with the input it changes (audit #4).
  Widget _modeSwitch(InputMode inputMode) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: IKubbSpacing.xs),
        child: SegmentedButton<InputMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: InputMode.pins,
              icon: const Icon(
                Icons.touch_app_outlined,
                size: IKubbIconSize.sm,
              ),
              label: Text(l10n.tapPins),
            ),
            ButtonSegment(
              value: InputMode.pad,
              icon: const Icon(Icons.grid_view_rounded, size: IKubbIconSize.sm),
              label: Text(l10n.numberPad),
            ),
          ],
          selected: {inputMode},
          onSelectionChanged: (s) {
            if (s.first != inputMode) {
              ref.read(inputModeProvider.notifier).toggle();
            }
          },
        ),
      ),
    );
  }

  Widget _inputArea(Game game, InputMode inputMode) {
    final l10n = AppLocalizations.of(context)!;
    final current = game.currentSideIndex;

    if (inputMode == InputMode.pad) {
      return Column(
        children: [
          _modeSwitch(inputMode),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(IKubbSpacing.lg),
                child: NumberPad(
                  pointsNeeded: current == null
                      ? 0
                      : game.pointsNeeded(current),
                  overshootPenalty:
                      game.rules.overshootPolicy != OvershootPolicy.none,
                  onScore: game.winner != null ? (_) {} : _padScore,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final throwScore = Throw.pins(_selected).score;
    final wouldBust =
        current != null &&
        throwScore > game.pointsNeeded(current) &&
        game.rules.overshootPolicy != OvershootPolicy.none;

    return Column(
      children: [
        _modeSwitch(inputMode),
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: PinDiagram(
                selected: _selected,
                onToggle: game.winner != null
                    ? null
                    : (pin) {
                        Haptics.selection(ref);
                        setState(() {
                          _selected.contains(pin)
                              ? _selected.remove(pin)
                              : _selected.add(pin);
                        });
                      },
              ),
            ),
          ),
        ),
        Padding(
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
                  onPressed: game.winner != null || _selected.isNotEmpty
                      ? null
                      : _confirm,
                  child: Text(l10n.miss),
                ),
              ),
              const SizedBox(width: IKubbSpacing.md),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: game.winner != null || _selected.isEmpty
                      ? null
                      : _confirm,
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
    );
  }
}

class _Standings extends ConsumerWidget {
  const _Standings({required this.game, this.vertical = false});

  final Game game;

  /// Vertical stacking for the wide (iPad) side-by-side layout.
  final bool vertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sideColors = ref.watch(sideColorsProvider);
    final cards = <Widget>[
      for (var i = 0; i < game.sideStates.length; i++)
        _wrap(
          vertical,
          ActiveSideCard(
            isActive: i == game.currentSideIndex,
            child: _SideCard(
              state: game.sideStates[i],
              isActive: i == game.currentSideIndex,
              needsLine: l10n.needsExactly(game.pointsNeeded(i)),
              missLimit: game.rules.missLimit,
              color:
                  playerColors[(sideColors[game.sides[i].id] ?? i) %
                      playerColors.length],
            ),
          ),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.all(IKubbSpacing.lg),
      child: vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final card in cards)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: IKubbSpacing.xs,
                    ),
                    child: card,
                  ),
              ],
            )
          : Row(children: cards),
    );
  }

  /// In the horizontal strip every card shares the width equally; stacked
  /// vertically the cards size themselves.
  Widget _wrap(bool vertical, Widget child) =>
      vertical ? child : Expanded(child: child);
}

class _SideCard extends StatelessWidget {
  const _SideCard({
    required this.state,
    required this.isActive,
    required this.needsLine,
    required this.missLimit,
    required this.color,
  });

  final SideState state;
  final bool isActive;
  final String needsLine;
  final int missLimit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onColor = isActive ? scheme.onPrimary : scheme.onSurface;
    final danger = IKubbPalette.danger(Theme.of(context).brightness);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorDotName(color: color, name: state.side.name, textColor: onColor),
        RollingNumber(
          value: state.score,
          style:
              IKubbType.score(
                size: IKubbType.stepScoreLg,
                color: state.isEliminated ? danger : onColor,
              ).copyWith(
                decoration: state.isEliminated
                    ? TextDecoration.lineThrough
                    : null,
              ),
        ),
        if (isActive)
          Text(needsLine, style: IKubbType.caption.copyWith(color: onColor)),
        // Miss dots fade in on the first miss (audit #6) and deep-link to
        // their exact rule card (SPEC.md §3.6). The slot is reserved (no
        // layout jump) and tall enough to be a legal tap target.
        SizedBox(
          height: IKubbTap.min,
          child: IgnorePointer(
            ignoring: state.missStreak == 0,
            child: AnimatedOpacity(
              duration: IKubbMotion.resolve(context, IKubbMotion.base),
              opacity: state.missStreak > 0 ? 1 : 0,
              child: InkWell(
                onTap: () => showRulesPanel(
                  context,
                  mode: GameMode.numberKubb,
                  categoryId: RuleCategoryIds.misses,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DotRow(
                    count: missLimit,
                    filled: state.missStreak,
                    activeColor: IKubbPalette.berry,
                    idleColor: onColor.withValues(alpha: IKubbAlpha.dotIdle),
                    padding: EdgeInsets.zero,
                    semanticLabel: AppLocalizations.of(
                      context,
                    )!.missesSemantics(state.missStreak, missLimit),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
