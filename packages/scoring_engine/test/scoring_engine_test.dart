import 'package:scoring_engine/scoring_engine.dart';
import 'package:test/test.dart';

void main() {
  const anna = Side(id: 'a', name: 'Anna');
  const bjorn = Side(id: 'b', name: 'Björn');
  const cleo = Side(id: 'c', name: 'Cleo');

  Game twoPlayer([GameRules rules = GameRules.classic]) =>
      Game.start(sides: const [anna, bjorn], rules: rules);

  group('throw scoring', () {
    test('one pin down scores its number', () {
      final t = Throw.pins({12});
      expect(t.score, 12);
    });

    test('several pins down score the count, not the sum', () {
      final t = Throw.pins({7, 9, 8, 11});
      expect(t.score, 4);
    });

    test('no pins down is a miss', () {
      expect(Throw.pins({}).isMiss, isTrue);
      expect(const Throw.score(0).isMiss, isTrue);
    });
  });

  group('turns', () {
    test('sides alternate and scores accumulate', () {
      var g = twoPlayer();
      expect(g.currentSide, anna);
      g = g.applyThrow(Throw.pins({5}));
      expect(g.currentSide, bjorn);
      g = g.applyThrow(const Throw.score(11));
      expect(g.currentSide, anna);
      expect(g.sideStates[0].score, 5);
      expect(g.sideStates[1].score, 11);
    });

    test('eliminated sides are skipped in rotation', () {
      var g = Game.start(sides: const [anna, bjorn, cleo]);
      // Björn misses three times; Anna and Cleo score in between.
      for (var round = 0; round < 3; round++) {
        g = g.applyThrow(Throw.pins({1})); // Anna
        g = g.applyThrow(Throw.pins({})); // Björn misses
        g = g.applyThrow(Throw.pins({2})); // Cleo
      }
      expect(g.sideStates[1].isEliminated, isTrue);
      expect(g.currentSide, anna);
      g = g.applyThrow(Throw.pins({1}));
      expect(g.currentSide, cleo, reason: 'Björn is skipped');
    });
  });

  group('winning', () {
    test('reaching exactly the target wins', () {
      var g = twoPlayer(const GameRules(targetScore: 12, overshootResetValue: 6));
      g = g.applyThrow(Throw.pins({12}));
      expect(g.winner, anna);
      expect(g.isFinished, isTrue);
      expect(g.records.last.outcome, ThrowOutcome.win);
      expect(g.currentSide, isNull);
    });

    test('no throws allowed after the game is finished', () {
      var g = twoPlayer(const GameRules(targetScore: 12, overshootResetValue: 6));
      g = g.applyThrow(Throw.pins({12}));
      expect(() => g.applyThrow(Throw.pins({1})), throwsStateError);
    });
  });

  group('overshoot', () {
    test('classic: busting 50 resets to 25', () {
      var g = twoPlayer(const GameRules(targetScore: 12, overshootResetValue: 6));
      g = g.applyThrow(Throw.pins({10})); // Anna 10
      g = g.applyThrow(const Throw.score(1)); // Björn 1
      g = g.applyThrow(Throw.pins({8})); // Anna busts 18 > 12
      expect(g.sideStates[0].score, 6);
      expect(g.records.last.outcome, ThrowOutcome.overshoot);
    });

    test('half-target policy resets to half the target', () {
      var g = twoPlayer(const GameRules(
        targetScore: 12,
        overshootPolicy: OvershootPolicy.resetToHalfTarget,
      ));
      g = g.applyThrow(Throw.pins({10}));
      g = g.applyThrow(const Throw.score(1));
      g = g.applyThrow(Throw.pins({8}));
      expect(g.sideStates[0].score, 6);
    });

    test('no-penalty policy: reaching or passing the target wins', () {
      var g = twoPlayer(const GameRules(
        targetScore: 12,
        overshootPolicy: OvershootPolicy.none,
      ));
      g = g.applyThrow(Throw.pins({10}));
      g = g.applyThrow(const Throw.score(1));
      g = g.applyThrow(Throw.pins({8})); // 18 >= 12
      expect(g.winner, anna);
    });
  });

  group('elimination', () {
    test('three consecutive misses eliminate; a hit resets the streak', () {
      var g = twoPlayer();
      g = g.applyThrow(Throw.pins({})); // Anna miss 1
      g = g.applyThrow(Throw.pins({3})); // Björn
      g = g.applyThrow(Throw.pins({})); // Anna miss 2
      g = g.applyThrow(Throw.pins({3})); // Björn
      g = g.applyThrow(Throw.pins({5})); // Anna scores: streak resets
      g = g.applyThrow(Throw.pins({3})); // Björn
      expect(g.sideStates[0].missStreak, 0);
      g = g.applyThrow(Throw.pins({})); // Anna miss 1
      g = g.applyThrow(Throw.pins({3})); // Björn
      g = g.applyThrow(Throw.pins({})); // Anna miss 2
      g = g.applyThrow(Throw.pins({3})); // Björn
      g = g.applyThrow(Throw.pins({})); // Anna miss 3 → out
      expect(g.sideStates[0].isEliminated, isTrue);
      expect(g.records.last.outcome, ThrowOutcome.eliminated);
    });

    test('last side standing wins by elimination', () {
      var g = twoPlayer();
      g = g.applyThrow(Throw.pins({})); // Anna
      g = g.applyThrow(Throw.pins({3})); // Björn
      g = g.applyThrow(Throw.pins({}));
      g = g.applyThrow(Throw.pins({3}));
      g = g.applyThrow(Throw.pins({})); // Anna out
      expect(g.winner, bjorn);
      expect(g.isFinished, isTrue);
    });

    test('elimination off: misses never eliminate', () {
      var g = twoPlayer(const GameRules(eliminationEnabled: false));
      for (var i = 0; i < 5; i++) {
        g = g.applyThrow(Throw.pins({})); // Anna
        g = g.applyThrow(Throw.pins({1})); // Björn
      }
      expect(g.sideStates[0].isEliminated, isFalse);
      expect(g.sideStates[0].missStreak, 5);
    });
  });

  group('undo and edit', () {
    test('undo removes the last throw and restores the turn', () {
      var g = twoPlayer();
      g = g.applyThrow(Throw.pins({5}));
      g = g.applyThrow(Throw.pins({7}));
      g = g.undo();
      expect(g.throws.length, 1);
      expect(g.currentSide, bjorn);
      expect(g.sideStates[1].score, 0);
    });

    test('undo on an empty game is a no-op', () {
      final g = twoPlayer();
      expect(g.undo().throws, isEmpty);
    });

    test('editing a past throw recomputes everything downstream', () {
      var g = twoPlayer(const GameRules(targetScore: 20, overshootResetValue: 10));
      g = g.applyThrow(Throw.pins({5})); // Anna 5
      g = g.applyThrow(Throw.pins({4})); // Björn 4
      g = g.applyThrow(Throw.pins({11})); // Anna 16
      // Correct Anna's first throw: it was actually pin 9.
      g = g.editThrow(0, Throw.pins({9}));
      expect(g.sideStates[0].score, 20);
      expect(g.winner, anna, reason: '9 + 11 now hits the target exactly');
    });

    test('an edit that ends the game early discards stranded throws', () {
      var g = twoPlayer(const GameRules(targetScore: 12, overshootResetValue: 6));
      g = g.applyThrow(Throw.pins({5})); // Anna 5
      g = g.applyThrow(Throw.pins({4})); // Björn 4
      g = g.applyThrow(Throw.pins({3})); // Anna 8
      g = g.editThrow(0, Throw.pins({12})); // Anna's first throw now wins
      expect(g.winner, anna);
      expect(g.throws.length, 1);
    });

    test('an edit can turn a win into an overshoot', () {
      var g = twoPlayer(const GameRules(targetScore: 12, overshootResetValue: 6));
      g = g.applyThrow(Throw.pins({10})); // Anna 10
      g = g.applyThrow(const Throw.score(1)); // Björn 1
      g = g.applyThrow(Throw.pins({2})); // Anna 12: wins
      expect(g.winner, anna);
      g = g.editThrow(2, Throw.pins({2, 3, 4})); // actually 3 pins: 13 busts
      expect(g.winner, isNull);
      expect(g.sideStates[0].score, 6);
      expect(g.currentSide, bjorn, reason: 'the game continues');
    });
  });

  group('helper', () {
    test('pointsNeeded drives the "needs exactly X" line', () {
      var g = twoPlayer();
      g = g.applyThrow(Throw.pins({7, 9, 8})); // Anna 3
      expect(g.pointsNeeded(0), 47);
      expect(g.pointsNeeded(1), 50);
    });
  });

  group('serialization', () {
    test('a game round-trips through JSON exactly', () {
      var g = twoPlayer(const GameRules(targetScore: 20, overshootResetValue: 10));
      g = g.applyThrow(Throw.pins({5}));
      g = g.applyThrow(const Throw.score(4));
      g = g.applyThrow(Throw.pins({}));
      final restored = Game.fromJson(g.toJson());
      expect(restored.sides, g.sides);
      expect(restored.rules, g.rules);
      expect(restored.throws, g.throws);
      expect(restored.sideStates[0].score, g.sideStates[0].score);
      expect(restored.sideStates[1].missStreak, 0);
      expect(restored.currentSideIndex, g.currentSideIndex);
      // Undo still works on the restored game: the log is the history.
      expect(restored.undo().throws.length, 2);
    });

    test('pin data survives the round-trip for stats', () {
      var g = twoPlayer();
      g = g.applyThrow(Throw.pins({7, 9}));
      final restored = Game.fromJson(g.toJson());
      expect(restored.throws.first.pins, {7, 9});
      expect(restored.throws.first.score, 2);
    });
  });
}
