import 'package:meta/meta.dart' show immutable;

/// Rules for classic kubb (teams + king). Tournament-complete: penalty
/// kubbs and best-of-N are modeled; the turn clock is advisory metadata
/// for the UI (the engine never blocks on time).
@immutable
class KubbRules {
  const KubbRules({
    this.baselineKubbs = 5,
    this.batonsPerTurn = 6,
    this.bestOf = 1,
    this.turnClockSeconds,
  })  : assert(baselineKubbs > 0),
        assert(batonsPerTurn > 0),
        assert(bestOf > 0 && bestOf % 2 == 1, 'bestOf must be odd');

  static const classic = KubbRules();
  static const tournament = KubbRules(bestOf: 3, turnClockSeconds: 60);

  final int baselineKubbs;
  final int batonsPerTurn;

  /// Match length: first to win ceil(bestOf/2) games.
  final int bestOf;

  /// Advisory per-turn clock shown by the UI; null = off.
  final int? turnClockSeconds;

  int get gamesToWin => bestOf ~/ 2 + 1;

  Map<String, Object?> toJson() => {
        'baselineKubbs': baselineKubbs,
        'batonsPerTurn': batonsPerTurn,
        'bestOf': bestOf,
        'turnClockSeconds': turnClockSeconds,
      };

  factory KubbRules.fromJson(Map<String, Object?> json) => KubbRules(
        baselineKubbs: (json['baselineKubbs'] as num).toInt(),
        batonsPerTurn: (json['batonsPerTurn'] as num).toInt(),
        bestOf: (json['bestOf'] as num).toInt(),
        turnClockSeconds: (json['turnClockSeconds'] as num?)?.toInt(),
      );

  @override
  bool operator ==(Object other) =>
      other is KubbRules &&
      other.baselineKubbs == baselineKubbs &&
      other.batonsPerTurn == batonsPerTurn &&
      other.bestOf == bestOf &&
      other.turnClockSeconds == turnClockSeconds;

  @override
  int get hashCode =>
      Object.hash(baselineKubbs, batonsPerTurn, bestOf, turnClockSeconds);
}
