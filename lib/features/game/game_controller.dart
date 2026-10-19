import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../feedback/feedback_controller.dart';
import '../stats/game_records_repository.dart';
import 'game_mode.dart';
import 'live_score/live_score.dart';

/// Side id → palette color index for the active game, set at game start
/// (from player profiles in setup). Sides without an entry fall back to
/// palette order.
class SideColors extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() =>
      ref.read(restoredGameProvider)?.sideColors ?? const {};

  void set(Map<String, int> colors) => state = colors;
}

final sideColorsProvider = NotifierProvider<SideColors, Map<String, int>>(
  SideColors.new,
);

/// Holds the active [Game]. All mutations go through the engine, so the UI
/// can never drift from the rules. Every change is persisted so an
/// interrupted game resumes exactly (SPEC.md §3.5); finishing a game
/// records it into the history.
class GameController extends Notifier<Game> {
  late String _gameId;

  /// Side ids of the built-in quick-start game (before any setup).
  static const defaultSideIds = ['p1', 'p2'];

  @override
  Game build() {
    final restored = ref.read(restoredGameProvider);
    if (restored?.molkky != null) {
      _gameId = restored!.id;
      return restored.molkky!;
    }
    _gameId = _newId();
    return Game.start(
      sides: const [
        Side(id: 'p1', name: 'Player 1'),
        Side(id: 'p2', name: 'Player 2'),
      ],
    );
  }

  static String _newId() => 'g${DateTime.now().microsecondsSinceEpoch}';

  void confirmPins(Set<int> pins) => _apply(Throw.pins(pins));

  void confirmScore(int score) => _apply(Throw.score(score));

  void miss() => confirmPins(const {});

  void undo() {
    state = state.undo();
    _persist();
  }

  void newGame({List<Side>? sides, GameRules? rules}) {
    _gameId = _newId();
    state = Game.start(
      sides: sides ?? state.sides,
      rules: rules ?? state.rules,
    );
    _persist();
  }

  /// Quick start from Home: a finished game restarts with the same sides
  /// (a rematch), an untouched default game takes the localized default
  /// names. A game in progress, or one set up by hand, is left alone.
  void quickStart({required String Function(int n) defaultName}) {
    if (state.isFinished) {
      newGame();
      return;
    }
    final untouchedDefaults =
        state.throws.isEmpty &&
        state.sides.length == defaultSideIds.length &&
        state.sides.indexed.every((e) => e.$2.id == defaultSideIds[e.$1]);
    if (untouchedDefaults) {
      final renamed = [
        for (final (i, side) in state.sides.indexed)
          Side(id: side.id, name: defaultName(i + 1)),
      ];
      if (renamed.any((s) => s.name != state.sides[renamed.indexOf(s)].name)) {
        newGame(sides: renamed);
      }
    }
  }

  void _apply(Throw thrown) {
    state = state.applyThrow(thrown);
    _persist();
  }

  /// Fire and forget: persistence must never delay the next throw.
  void _persist() {
    ref.read(lastModeProvider.notifier).set(GameMode.numberKubb);
    liveScore.sync(state);
    final repo = ref.read(gameRecordsRepositoryProvider);
    repo
        .saveActive(
          ActiveRecord(
            id: _gameId,
            molkky: state,
            sideColors: ref.read(sideColorsProvider),
          ),
        )
        .ignore();
    if (state.winner != null) {
      ref.read(finishedGameCountProvider.notifier).markFinished(_gameId);
      repo
          .recordFinished(
            FinishedGame(id: _gameId, finishedAt: DateTime.now(), game: state),
          )
          .ignore();
    }
  }
}

final gameControllerProvider = NotifierProvider<GameController, Game>(
  GameController.new,
);
