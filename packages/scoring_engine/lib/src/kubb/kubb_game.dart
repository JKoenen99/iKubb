import 'package:meta/meta.dart' show immutable;

import '../side.dart';
import 'kubb_event.dart';
import 'kubb_rules.dart';

/// Which input the game expects next.
enum KubbPhase {
  /// The attacker is throwing batons.
  throwing,

  /// The defenders throw the felled kubbs into the attacker's half.
  throwIn,

  /// King toppled (rightfully or too early) — game over.
  finished,
}

/// One game of classic kubb, replayed from its event log.
///
/// Field-kubb geometry, condensed to what a tracker needs:
/// - `field[h]` = field kubbs standing in half `h`.
/// - The attacker targets the *defender's* half: all standing field kubbs
///   there must fall before baseline kubbs may be hit (the engine rejects
///   illegal events).
/// - Everything the attacker fells is thrown into the *attacker's* half
///   at the end of the turn and stands there as new field kubbs.
/// - Advantage line: if field kubbs are standing in the attacker's own
///   half at the start of their turn (the previous attacker failed to
///   clear them), the attacker may throw from the closest one.
/// - The king only wins when the defender has nothing left; hitting it
///   early loses the game on the spot.
@immutable
class KubbGame {
  KubbGame._(this.sides, this.rules, this.startingSide, List<KubbEvent> events)
      : assert(sides.length == 2, 'Classic kubb is played by two sides'),
        events = List.unmodifiable(events) {
    _replay();
  }

  factory KubbGame.start({
    required List<Side> sides,
    KubbRules rules = KubbRules.classic,
    int startingSide = 0,
  }) =>
      KubbGame._(List.unmodifiable(sides), rules, startingSide, const []);

  final List<Side> sides;
  final KubbRules rules;
  final int startingSide;
  final List<KubbEvent> events;

  // Derived by replay.
  late final List<int> baseline;

  /// Standing field kubbs per half (index = half owner's side).
  late final List<int> field;
  late final int attackerIndex;
  late final KubbPhase phase;
  late final int batonsThrown;
  late final int felledThisTurn;

  /// Attacker may throw from the closest field kubb in their own half.
  late final bool advantageActive;
  late final Side? winner;

  /// True when the game ended because the king fell too early.
  late final bool earlyKing;

  /// Penalty kubbs committed per side (thrown out of bounds twice).
  late final List<int> penaltiesBy;

  int get defenderIndex => 1 - attackerIndex;
  bool get isFinished => phase == KubbPhase.finished;
  int get batonsRemaining => rules.batonsPerTurn - batonsThrown;

  /// Field kubbs the attacker still must fell before touching baseline.
  int get targetFieldStanding => field[defenderIndex];

  bool get canHitKing =>
      field[defenderIndex] == 0 && baseline[defenderIndex] == 0;

  KubbGame applyEvent(KubbEvent event) {
    _validate(event);
    return KubbGame._(sides, rules, startingSide, [...events, event]);
  }

  KubbGame undo() => events.isEmpty
      ? this
      : KubbGame._(
          sides, rules, startingSide, events.sublist(0, events.length - 1));

  void _validate(KubbEvent event) {
    if (isFinished) throw StateError('Game is finished');
    switch ((phase, event)) {
      case (KubbPhase.throwing, KubbBaton e):
        if (e.felledField > field[defenderIndex]) {
          throw ArgumentError('Only ${field[defenderIndex]} field kubbs stand');
        }
        if (e.felledBaseline > 0 &&
            field[defenderIndex] - e.felledField > 0) {
          throw ArgumentError('Field kubbs must fall before baseline kubbs');
        }
        if (e.felledBaseline > baseline[defenderIndex]) {
          throw ArgumentError(
              'Only ${baseline[defenderIndex]} baseline kubbs stand');
        }
      case (KubbPhase.throwIn, KubbThrowIn e):
        if (e.penalties > felledThisTurn) {
          throw ArgumentError('More penalties than felled kubbs');
        }
      case (KubbPhase.throwing, KubbThrowIn _):
        throw StateError('Expected a baton throw');
      case (KubbPhase.throwIn, KubbBaton _):
        throw StateError('Expected the kubb throw-in');
      case (KubbPhase.finished, _):
        throw StateError('Game is finished');
    }
  }

  void _replay() {
    final base = [rules.baselineKubbs, rules.baselineKubbs];
    final fld = [0, 0];
    final pens = [0, 0];
    var attacker = startingSide;
    var batons = 0;
    var felled = 0;
    var currentPhase = KubbPhase.throwing;
    var advantage = false;
    int? winnerIndex;
    var early = false;

    void startTurn(int side) {
      attacker = side;
      batons = 0;
      felled = 0;
      advantage = fld[side] > 0;
      currentPhase = KubbPhase.throwing;
    }

    startTurn(startingSide);

    for (final event in events) {
      final defender = 1 - attacker;
      switch (event) {
        case KubbBaton e:
          batons++;
          if (e.hitKing) {
            final rightful = fld[defender] == 0 && base[defender] == 0;
            winnerIndex = rightful ? attacker : defender;
            early = !rightful;
            currentPhase = KubbPhase.finished;
          } else {
            fld[defender] -= e.felledField;
            base[defender] -= e.felledBaseline;
            felled += e.felledField + e.felledBaseline;
            if (batons >= rules.batonsPerTurn) {
              if (felled > 0) {
                currentPhase = KubbPhase.throwIn;
              } else {
                startTurn(defender);
              }
            }
          }
        case KubbThrowIn e:
          // Everything felled this turn stands up in the attacker's half;
          // out-twice kubbs are placed by the attacker but still stand.
          fld[attacker] += felled;
          pens[defender] += e.penalties;
          startTurn(defender);
      }
      if (winnerIndex != null) break;
    }

    baseline = List.unmodifiable(base);
    field = List.unmodifiable(fld);
    penaltiesBy = List.unmodifiable(pens);
    attackerIndex = attacker;
    phase = currentPhase;
    batonsThrown = batons;
    felledThisTurn = felled;
    advantageActive = currentPhase == KubbPhase.throwing && advantage;
    winner = winnerIndex == null ? null : sides[winnerIndex];
    earlyKing = early;
  }

  Map<String, Object?> toJson() => {
        'sides': [for (final s in sides) s.toJson()],
        'rules': rules.toJson(),
        'startingSide': startingSide,
        'events': [for (final e in events) e.toJson()],
      };

  factory KubbGame.fromJson(Map<String, Object?> json) => KubbGame._(
        List.unmodifiable([
          for (final s in json['sides'] as List)
            Side.fromJson((s as Map).cast<String, Object?>()),
        ]),
        KubbRules.fromJson((json['rules'] as Map).cast<String, Object?>()),
        (json['startingSide'] as num?)?.toInt() ?? 0,
        [
          for (final e in json['events'] as List)
            KubbEvent.fromJson((e as Map).cast<String, Object?>()),
        ],
      );
}
