import 'package:meta/meta.dart' show immutable;

import 'rules.dart';
import 'side.dart';
import 'throw.dart';

/// What a single throw did, for history display and animation triggers.
enum ThrowOutcome {
  /// Points were added.
  scored,

  /// Zero-score throw.
  miss,

  /// The throw busted the target; the side's score was reset.
  overshoot,

  /// The throw reached the target: the thrower won.
  win,

  /// The throw was the side's final allowed miss: the side is out.
  eliminated,
}

/// One entry in the game's history: who threw what, and what it did.
@immutable
class ThrowRecord {
  const ThrowRecord({
    required this.sideIndex,
    required this.thrown,
    required this.outcome,
    required this.scoreAfter,
  });

  final int sideIndex;
  final Throw thrown;
  final ThrowOutcome outcome;

  /// The side's score immediately after this throw resolved.
  final int scoreAfter;
}

/// The live standing of one side.
@immutable
class SideState {
  const SideState({
    required this.side,
    required this.score,
    required this.missStreak,
    required this.isEliminated,
  });

  final Side side;
  final int score;

  /// Consecutive zero-score throws so far.
  final int missStreak;
  final bool isEliminated;
}

/// An immutable number-kubb game.
///
/// A game is fully defined by its [sides], [rules], and ordered [throws];
/// everything else is derived by replaying the throw list. [applyThrow],
/// [undo], and [editThrow] each return a new [Game]. Turn order is
/// round-robin over the sides, skipping eliminated ones, and is likewise
/// derived — so editing a past throw correctly reassigns every later throw.
@immutable
class Game {
  Game._(this.sides, this.rules, List<Throw> throws)
      : assert(sides.length >= 2, 'A game needs at least two sides'),
        throws = List.unmodifiable(throws) {
    _replay();
  }

  factory Game.start({
    required List<Side> sides,
    GameRules rules = GameRules.classic,
  }) =>
      Game._(List.unmodifiable(sides), rules, const []);

  final List<Side> sides;
  final GameRules rules;

  /// Every throw made so far, in order. Which side made each throw is
  /// derived — see [records].
  final List<Throw> throws;

  late final List<SideState> sideStates;
  late final List<ThrowRecord> records;

  /// Index into [sides] of the side that throws next; `null` once finished.
  late final int? currentSideIndex;

  /// The winning side, once the game is finished.
  late final Side? winner;

  bool get isFinished => winner != null;

  Side? get currentSide =>
      currentSideIndex == null ? null : sides[currentSideIndex!];

  /// Points the side at [sideIndex] still needs. Under the no-penalty
  /// overshoot policy this is a minimum; otherwise it must be hit exactly —
  /// this number drives the "needs exactly 7" helper in the UI.
  int pointsNeeded(int sideIndex) =>
      rules.targetScore - sideStates[sideIndex].score;

  /// Appends a throw for the current side.
  Game applyThrow(Throw thrown) {
    if (isFinished) {
      throw StateError('Game is finished; no further throws allowed');
    }
    return Game._(sides, rules, [...throws, thrown]);
  }

  /// Removes the most recent throw. Returns `this` if nothing to undo.
  Game undo() =>
      throws.isEmpty ? this : Game._(sides, rules, throws.sublist(0, throws.length - 1));

  /// Replaces the throw at [index] and recomputes everything after it.
  ///
  /// If the edit makes the game end earlier than it originally did, the
  /// throws after that new ending are discarded — they can no longer have
  /// happened.
  Game editThrow(int index, Throw thrown) {
    RangeError.checkValidIndex(index, throws, 'index');
    final edited = Game._(sides, rules, [...throws]..[index] = thrown);
    if (edited.records.length < edited.throws.length) {
      return Game._(
          sides, rules, edited.throws.sublist(0, edited.records.length));
    }
    return edited;
  }

  void _replay() {
    final scores = List.filled(sides.length, 0);
    final streaks = List.filled(sides.length, 0);
    final out = List.filled(sides.length, false);
    final recs = <ThrowRecord>[];
    int? winnerIndex;
    var turn = 0;

    int? nextActive(int from) {
      for (var step = 1; step <= sides.length; step++) {
        final i = (from + step) % sides.length;
        if (!out[i]) return i;
      }
      return null;
    }

    for (final thrown in throws) {
      if (winnerIndex != null) break; // edits can strand a tail; drop it

      final i = turn;
      ThrowOutcome outcome;

      if (thrown.isMiss) {
        streaks[i]++;
        if (rules.eliminationEnabled && streaks[i] >= rules.missLimit) {
          out[i] = true;
          outcome = ThrowOutcome.eliminated;
        } else {
          outcome = ThrowOutcome.miss;
        }
      } else {
        streaks[i] = 0;
        final raw = scores[i] + thrown.score;
        if (rules.isWinningScore(raw)) {
          scores[i] = raw;
          winnerIndex = i;
          outcome = ThrowOutcome.win;
        } else if (raw > rules.targetScore) {
          scores[i] = rules.overshootResult()!;
          outcome = ThrowOutcome.overshoot;
        } else {
          scores[i] = raw;
          outcome = ThrowOutcome.scored;
        }
      }

      recs.add(ThrowRecord(
        sideIndex: i,
        thrown: thrown,
        outcome: outcome,
        scoreAfter: scores[i],
      ));

      // Last side standing wins by elimination.
      if (winnerIndex == null && out.where((o) => !o).length == 1) {
        winnerIndex = out.indexOf(false);
      }
      if (winnerIndex == null) {
        turn = nextActive(i)!;
      }
    }

    sideStates = List.unmodifiable([
      for (var i = 0; i < sides.length; i++)
        SideState(
          side: sides[i],
          score: scores[i],
          missStreak: streaks[i],
          isEliminated: out[i],
        ),
    ]);
    records = List.unmodifiable(recs);
    winner = winnerIndex == null ? null : sides[winnerIndex];
    currentSideIndex = winnerIndex == null ? turn : null;
  }
}
