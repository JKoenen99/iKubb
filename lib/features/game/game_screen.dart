import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../widgets/rolling_number.dart';
import '../rules/rules_content.dart';
import '../rules/rules_view.dart';
import '../setup/player.dart' show playerColors;
import 'game_controller.dart';
import 'input_mode.dart';
import 'number_pad.dart';
import 'pin_diagram.dart';
import 'win_overlay.dart';

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
    _hapticAfterThrow();
  }

  void _padScore(int score) {
    ref.read(gameControllerProvider.notifier).confirmScore(score);
    _hapticAfterThrow();
  }

  void _hapticAfterThrow() {
    final won = ref.read(gameControllerProvider).winner != null;
    won ? HapticFeedback.heavyImpact() : HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameControllerProvider);
    final inputMode = ref.watch(inputModeProvider);
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Three visible actions only (audit #4): rules and undo stay, the
      // rest lives in an overflow menu with labeled rows.
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
            onPressed: game.throws.isEmpty
                ? null
                : ref.read(gameControllerProvider.notifier).undo,
            icon: const Icon(Icons.undo),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => switch (value) {
              'scoreboard' => context.push('/scoreboard'),
              _ => ref.read(gameControllerProvider.notifier).newGame(),
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
          if (game.winner != null) WinOverlay(game: game),
        ],
      ),
      backgroundColor: scheme.surface,
    );
  }

  /// The labeled mode switch lives with the input it changes (audit #4).
  Widget _modeSwitch(InputMode inputMode) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SegmentedButton<InputMode>(
          showSelectedIcon: false,
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          segments: [
            ButtonSegment(
              value: InputMode.pins,
              icon: const Icon(Icons.touch_app_outlined, size: 18),
              label: Text(l10n.tapPins),
            ),
            ButtonSegment(
              value: InputMode.pad,
              icon: const Icon(Icons.grid_view_rounded, size: 18),
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
                padding: const EdgeInsets.all(16),
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
                    : (pin) => setState(() {
                        _selected.contains(pin)
                            ? _selected.remove(pin)
                            : _selected.add(pin);
                      }),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              const SizedBox(width: 12),
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
    final scheme = Theme.of(context).colorScheme;
    final sideColors = ref.watch(sideColorsProvider);
    final cards = <Widget>[
      for (var i = 0; i < game.sideStates.length; i++)
        _wrap(
          vertical,
          AnimatedContainer(
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
              color:
                  playerColors[(sideColors[game.sides[i].id] ?? i) %
                      playerColors.length],
            ),
          ),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final card in cards)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: IKubbPalette.birchLight, width: 1.5),
              ),
            ),
            Expanded(
              child: Text(
                state.side.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, color: onColor),
              ),
            ),
          ],
        ),
        RollingNumber(
          value: state.score,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: state.isEliminated ? IKubbPalette.berry : onColor,
            decoration: state.isEliminated ? TextDecoration.lineThrough : null,
          ),
        ),
        if (isActive)
          Text(needsLine, style: TextStyle(fontSize: 12, color: onColor)),
        // Miss dots fade in on the first miss (audit #6) and deep-link to
        // their exact rule card (SPEC.md §3.6). Fixed height: no jump.
        SizedBox(
          height: 16,
          child: IgnorePointer(
            ignoring: state.missStreak == 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: state.missStreak > 0 ? 1 : 0,
              child: InkWell(
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
            ),
          ),
        ),
      ],
    );
  }
}
