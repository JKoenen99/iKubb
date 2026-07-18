import 'package:meta/meta.dart' show immutable;

/// One throw, recorded in whichever input mode the scorer used.
///
/// [Throw.pins] captures pin-tap mode: the engine derives the score by rule
/// (one pin down scores its number, several pins down score the count).
/// [Throw.score] captures number-pad mode, where only the resulting score is
/// known. Both normalize to [score]; [pins] is retained when available so
/// stats (e.g. most-hit pin) can use it.
@immutable
class Throw {
  /// Pin-tap mode: [pins] are the numbers (1–12) of the pins that fell.
  /// An empty set is a miss.
  Throw.pins(Set<int> pins)
      : assert(pins.every((p) => p >= 1 && p <= 12)),
        pins = Set.unmodifiable(pins),
        score = switch (pins.length) { 0 => 0, 1 => pins.first, final n => n };

  /// Number-pad mode: the score is entered directly (0 = miss).
  const Throw.score(this.score)
      : assert(score >= 0 && score <= 12),
        pins = null;

  /// The pins that fell, when known (pin-tap mode only).
  final Set<int>? pins;

  /// The points this throw is worth before target/overshoot rules apply.
  final int score;

  bool get isMiss => score == 0;

  Map<String, Object?> toJson() =>
      pins == null ? {'score': score} : {'pins': [...pins!]};

  factory Throw.fromJson(Map<String, Object?> json) => json['pins'] != null
      ? Throw.pins({for (final p in json['pins'] as List) (p as num).toInt()})
      : Throw.score((json['score'] as num).toInt());

  @override
  bool operator ==(Object other) =>
      other is Throw &&
      other.score == score &&
      switch ((pins, other.pins)) {
        (null, null) => true,
        (final a?, final b?) => a.length == b.length && a.containsAll(b),
        _ => false,
      };

  @override
  int get hashCode => Object.hash(score, pins?.length);

  @override
  String toString() =>
      pins == null ? 'Throw.score($score)' : 'Throw.pins($pins → $score)';
}
