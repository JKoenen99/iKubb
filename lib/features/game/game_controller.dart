import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

/// Holds the active [Game]. All mutations go through the engine, so the UI
/// can never drift from the rules.
class GameController extends Notifier<Game> {
  @override
  Game build() => Game.start(
        sides: const [
          Side(id: 'p1', name: 'Player 1'),
          Side(id: 'p2', name: 'Player 2'),
        ],
      );

  void confirmPins(Set<int> pins) => state = state.applyThrow(Throw.pins(pins));

  void confirmScore(int score) => state = state.applyThrow(Throw.score(score));

  void miss() => confirmPins(const {});

  void undo() => state = state.undo();

  void newGame({List<Side>? sides, GameRules? rules}) => state = Game.start(
        sides: sides ?? state.sides,
        rules: rules ?? state.rules,
      );
}

final gameControllerProvider =
    NotifierProvider<GameController, Game>(GameController.new);
