import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../stats/game_records_repository.dart';

/// Side id → palette color index for the active game, set at game start
/// (from player profiles in setup). Sides without an entry fall back to
/// palette order.
class SideColors extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() =>
      ref.read(restoredGameProvider)?.sideColors ?? const {};

  void set(Map<String, int> colors) => state = colors;
}

final sideColorsProvider =
    NotifierProvider<SideColors, Map<String, int>>(SideColors.new);

/// Holds the active [Game]. All mutations go through the engine, so the UI
/// can never drift from the rules. Every change is persisted so an
/// interrupted game resumes exactly (SPEC.md §3.5); finishing a game
/// records it into the history.
class GameController extends Notifier<Game> {
  late String _gameId;

  @override
  Game build() {
    final restored = ref.read(restoredGameProvider);
    if (restored != null) {
      _gameId = restored.id;
      return restored.game;
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

  void _apply(Throw thrown) {
    state = state.applyThrow(thrown);
    _persist();
  }

  /// Fire and forget: persistence must never delay the next throw.
  void _persist() {
    final repo = ref.read(gameRecordsRepositoryProvider);
    repo.saveActive((
      id: _gameId,
      game: state,
      sideColors: ref.read(sideColorsProvider),
    ));
    if (state.winner != null) {
      repo.recordFinished(FinishedGame(
        id: _gameId,
        finishedAt: DateTime.now(),
        game: state,
      ));
    }
  }
}

final gameControllerProvider =
    NotifierProvider<GameController, Game>(GameController.new);
