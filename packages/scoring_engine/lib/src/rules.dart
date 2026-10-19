import 'package:meta/meta.dart' show immutable;

/// What happens when a side's score exceeds [GameRules.targetScore].
enum OvershootPolicy {
  /// Classic rule: score resets to a fixed value (25 in the official rules).
  resetToFixed,

  /// House rule: score resets to half of the target score.
  resetToHalfTarget,

  /// House rule: no penalty. The game is then won by reaching the target
  /// _or more_, since an exact finish can no longer be forced.
  none,
}

/// The rule set a game is played under.
///
/// [GameRules.classic] matches the official rules sheet: first to exactly 50,
/// overshoot drops you back to 25, three consecutive misses eliminate you.
@immutable
class GameRules {
  const GameRules({
    this.targetScore = 50,
    this.overshootPolicy = OvershootPolicy.resetToFixed,
    this.overshootResetValue = 25,
    this.eliminationEnabled = true,
    this.missLimit = 3,
  }) : assert(targetScore > 0),
       assert(
         overshootPolicy != OvershootPolicy.resetToFixed ||
             overshootResetValue < targetScore,
         'overshootResetValue must be below targetScore',
       ),
       assert(missLimit > 0);

  static const classic = GameRules();

  /// Points needed to win.
  final int targetScore;

  /// What happens on overshoot.
  final OvershootPolicy overshootPolicy;

  /// Reset value used by [OvershootPolicy.resetToFixed].
  final int overshootResetValue;

  /// Whether consecutive misses eliminate a side.
  final bool eliminationEnabled;

  /// Number of consecutive zero-score throws that eliminates a side.
  final int missLimit;

  /// The score a side falls back to when overshooting, or `null` when the
  /// policy is [OvershootPolicy.none].
  int? overshootResult() => switch (overshootPolicy) {
    OvershootPolicy.resetToFixed => overshootResetValue,
    OvershootPolicy.resetToHalfTarget => targetScore ~/ 2,
    OvershootPolicy.none => null,
  };

  /// Whether [score] wins under these rules.
  bool isWinningScore(int score) => overshootPolicy == OvershootPolicy.none
      ? score >= targetScore
      : score == targetScore;

  Map<String, Object?> toJson() => {
    'targetScore': targetScore,
    'overshootPolicy': overshootPolicy.name,
    'overshootResetValue': overshootResetValue,
    'eliminationEnabled': eliminationEnabled,
    'missLimit': missLimit,
  };

  /// Persisted data is untrusted: the constructor's asserts only run in
  /// debug builds, so the same invariants are enforced here explicitly.
  factory GameRules.fromJson(Map<String, Object?> json) {
    final target = (json['targetScore'] as num).toInt();
    final policy = OvershootPolicy.values.byName(
      json['overshootPolicy'] as String,
    );
    final reset = (json['overshootResetValue'] as num).toInt();
    final missLimit = (json['missLimit'] as num).toInt();
    if (target <= 0 || missLimit <= 0 || reset < 0) {
      throw FormatException('Rules out of range', json);
    }
    if (policy == OvershootPolicy.resetToFixed && reset >= target) {
      throw FormatException('overshootResetValue must be below target', json);
    }
    return GameRules(
      targetScore: target,
      overshootPolicy: policy,
      overshootResetValue: reset,
      eliminationEnabled: json['eliminationEnabled'] as bool,
      missLimit: missLimit,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GameRules &&
      other.targetScore == targetScore &&
      other.overshootPolicy == overshootPolicy &&
      other.overshootResetValue == overshootResetValue &&
      other.eliminationEnabled == eliminationEnabled &&
      other.missLimit == missLimit;

  @override
  int get hashCode => Object.hash(
    targetScore,
    overshootPolicy,
    overshootResetValue,
    eliminationEnabled,
    missLimit,
  );
}
