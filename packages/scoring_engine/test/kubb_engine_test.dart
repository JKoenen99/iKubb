import 'package:scoring_engine/scoring_engine.dart';
import 'package:test/test.dart';

void main() {
  const ravens = Side(id: 'a', name: 'Ravens');
  const bears = Side(id: 'b', name: 'Bears');

  KubbGame start([KubbRules rules = KubbRules.classic]) =>
      KubbGame.start(sides: const [ravens, bears], rules: rules);

  /// Attacker fells [n] baseline kubbs spread over the 6 batons, then the
  /// defender throws them in (no penalties).
  KubbGame turn(KubbGame g, {int baseline = 0, int field = 0}) {
    var game = g;
    var fieldLeft = field;
    var baselineLeft = baseline;
    for (var baton = 0; baton < game.rules.batonsPerTurn; baton++) {
      final fellField = fieldLeft > 0 ? 1 : 0;
      fieldLeft -= fellField;
      final fellBaseline = fellField == 0 && baselineLeft > 0 ? 1 : 0;
      baselineLeft -= fellBaseline;
      game = game.applyEvent(
          KubbBaton(felledField: fellField, felledBaseline: fellBaseline));
      if (game.phase != KubbPhase.throwing) break;
    }
    if (game.phase == KubbPhase.throwIn) {
      game = game.applyEvent(const KubbThrowIn());
    }
    return game;
  }

  group('turn flow', () {
    test('felled kubbs become field kubbs in the attacker half', () {
      var g = start();
      g = turn(g, baseline: 2); // Ravens fell 2 of Bears' baseline kubbs
      expect(g.baseline, [5, 3]);
      expect(g.field, [2, 0], reason: 'thrown into the Ravens half');
      expect(g.attackerIndex, 1, reason: 'Bears attack next');
      expect(g.targetFieldStanding, 2,
          reason: 'Bears must clear the field kubbs in the Ravens half');
    });

    test('a turn with no fells skips the throw-in', () {
      var g = start();
      g = turn(g); // six misses
      expect(g.attackerIndex, 1);
      expect(g.phase, KubbPhase.throwing);
    });

    test('baseline kubbs are illegal while field kubbs stand', () {
      var g = start();
      g = turn(g, baseline: 2);
      expect(
        () => g.applyEvent(const KubbBaton(felledBaseline: 1)),
        throwsArgumentError,
      );
      // Clearing the field first is legal; same baton may then take
      // baseline only when the field count reaches zero in that throw.
      g = g.applyEvent(const KubbBaton(felledField: 2, felledBaseline: 1));
      expect(g.field, [0, 0]);
      expect(g.baseline, [4, 3]);
    });
  });

  group('advantage line', () {
    test('activates when the attacker left field kubbs standing', () {
      var g = start();
      g = turn(g, baseline: 3); // field[0] = 3, Bears to attack
      g = turn(g, field: 2); // Bears clear only 2 of 3 — one remains
      // Ravens attack again with one field kubb still in their own half.
      expect(g.attackerIndex, 0);
      expect(g.field[0], 1);
      expect(g.advantageActive, isTrue);
    });

    test('no advantage when the field was cleared', () {
      var g = start();
      g = turn(g, baseline: 2);
      g = turn(g, field: 2, baseline: 1); // Bears clear both, take 1 baseline
      expect(g.attackerIndex, 0);
      expect(g.advantageActive, isFalse);
    });
  });

  group('the king', () {
    test('toppling the king too early loses instantly', () {
      var g = start();
      g = g.applyEvent(const KubbBaton(hitKing: true));
      expect(g.isFinished, isTrue);
      expect(g.winner, bears);
      expect(g.earlyKing, isTrue);
    });

    test('king after clearing everything wins the game', () {
      var g = start();
      // Ravens fell all 5 baseline kubbs in one turn.
      g = turn(g, baseline: 5);
      // Bears fail to clear their five field kubbs: six misses.
      g = turn(g);
      // Ravens clear nothing is needed: Bears still have field kubbs? No —
      // the field kubbs stand in the Ravens' half; Bears must clear them.
      // Ravens' targets: Bears' half is empty of field kubbs and baseline
      // is empty, so the king is legal.
      expect(g.attackerIndex, 0);
      expect(g.canHitKing, isTrue);
      g = g.applyEvent(const KubbBaton(hitKing: true));
      expect(g.winner, ravens);
      expect(g.earlyKing, isFalse);
    });
  });

  group('penalties', () {
    test('out-twice kubbs count against the throwing side', () {
      var g = start();
      for (var i = 0; i < 6; i++) {
        g = g.applyEvent(KubbBaton(felledBaseline: i < 3 ? 1 : 0));
      }
      expect(g.phase, KubbPhase.throwIn);
      g = g.applyEvent(const KubbThrowIn(penalties: 1));
      expect(g.penaltiesBy, [0, 1], reason: 'Bears threw one out twice');
      expect(g.field[0], 3, reason: 'penalty kubbs still stand as field kubbs');
    });
  });

  group('match', () {
    KubbMatch playGameTo(KubbMatch m, {required int winnerSide}) {
      // Winner fells all 5, loser misses, winner takes the king.
      var match = m;
      KubbMatch doTurn(KubbMatch mm, {int baseline = 0}) {
        var left = baseline;
        for (var b = 0; b < mm.rules.batonsPerTurn; b++) {
          final fell = left > 0 ? 1 : 0;
          left -= fell;
          match = mm = mm.applyEvent(KubbBaton(felledBaseline: fell));
          if (mm.currentGame.phase != KubbPhase.throwing) break;
        }
        if (mm.currentGame.phase == KubbPhase.throwIn) {
          match = mm = mm.applyEvent(const KubbThrowIn());
        }
        return mm;
      }

      // Bring the intended winner into the attacker seat if needed.
      if (match.currentGame.attackerIndex != winnerSide) {
        match = doTurn(match); // all-miss turn passes the attack
      }
      match = doTurn(match, baseline: 5);
      match = doTurn(match); // loser misses their six batons
      match = match.applyEvent(const KubbBaton(hitKing: true));
      return match;
    }

    test('best-of-three plays to two game wins with alternating starts',
        () {
      var m = KubbMatch.start(
        sides: const [ravens, bears],
        rules: KubbRules.tournament,
      );
      m = playGameTo(m, winnerSide: 0);
      expect(m.wins, [1, 0]);
      expect(m.needsNextGame, isTrue);
      m = m.nextGame();
      expect(m.currentGame.attackerIndex, 1,
          reason: 'game two starts with the other side');
      m = playGameTo(m, winnerSide: 1);
      expect(m.wins, [1, 1]);
      m = m.nextGame();
      m = playGameTo(m, winnerSide: 0);
      expect(m.matchWinner, ravens);
      expect(() => m.applyEvent(const KubbBaton()), throwsStateError);
    });

    test('undo crosses game boundaries seamlessly', () {
      var m = KubbMatch.start(
          sides: const [ravens, bears], rules: KubbRules.tournament);
      m = playGameTo(m, winnerSide: 0);
      m = m.nextGame();
      expect(m.games.length, 2);
      m = m.undo(); // removes the empty game 2 and the king throw
      expect(m.games.length, 1);
      expect(m.currentGame.isFinished, isFalse);
      expect(m.wins, [0, 0]);
    });

    test('a match round-trips through JSON exactly', () {
      var m = KubbMatch.start(
          sides: const [ravens, bears], rules: KubbRules.tournament);
      m = m.applyEvent(const KubbBaton(felledBaseline: 1));
      m = m.applyEvent(const KubbBaton());
      final restored = KubbMatch.fromJson(m.toJson());
      expect(restored.currentGame.baseline, m.currentGame.baseline);
      expect(restored.currentGame.batonsThrown, 2);
      expect(restored.rules, m.rules);
      expect(restored.undo().undo().currentGame.baseline, [5, 5]);
    });
  });
}
