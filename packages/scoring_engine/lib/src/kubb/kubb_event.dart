import 'package:meta/meta.dart' show immutable;

/// One recorded action in a kubb game. Like number kubb's throw log, the
/// event log is the single source of truth: state is derived by replay,
/// so undo and exact resume come for free.
@immutable
sealed class KubbEvent {
  const KubbEvent();

  Map<String, Object?> toJson();

  factory KubbEvent.fromJson(Map<String, Object?> json) =>
      switch (json['type']) {
        'baton' => KubbBaton(
            felledField: (json['felledField'] as num?)?.toInt() ?? 0,
            felledBaseline: (json['felledBaseline'] as num?)?.toInt() ?? 0,
            hitKing: json['hitKing'] as bool? ?? false,
          ),
        'throwIn' => KubbThrowIn(
            penalties: (json['penalties'] as num?)?.toInt() ?? 0,
          ),
        _ => throw ArgumentError('Unknown kubb event: ${json['type']}'),
      };
}

/// One baton thrown by the attacking side: which kubbs it felled, or the
/// king. A baton that fells nothing is a miss (all zeros).
@immutable
class KubbBaton extends KubbEvent {
  const KubbBaton({
    this.felledField = 0,
    this.felledBaseline = 0,
    this.hitKing = false,
  })  : assert(felledField >= 0),
        assert(felledBaseline >= 0),
        assert(!hitKing || (felledField == 0 && felledBaseline == 0),
            'A king hit is a standalone throw');

  final int felledField;
  final int felledBaseline;
  final bool hitKing;

  bool get isMiss => felledField == 0 && felledBaseline == 0 && !hitKing;

  @override
  Map<String, Object?> toJson() => {
        'type': 'baton',
        'felledField': felledField,
        'felledBaseline': felledBaseline,
        'hitKing': hitKing,
      };

  @override
  bool operator ==(Object other) =>
      other is KubbBaton &&
      other.felledField == felledField &&
      other.felledBaseline == felledBaseline &&
      other.hitKing == hitKing;

  @override
  int get hashCode => Object.hash(felledField, felledBaseline, hitKing);
}

/// The defenders throw the kubbs felled this turn into the attacker's
/// half. [penalties] counts kubbs that went out of bounds twice: the
/// attacker places those anywhere (they still stand as field kubbs, but
/// the blunder is worth tracking).
@immutable
class KubbThrowIn extends KubbEvent {
  const KubbThrowIn({this.penalties = 0}) : assert(penalties >= 0);

  final int penalties;

  @override
  Map<String, Object?> toJson() => {'type': 'throwIn', 'penalties': penalties};

  @override
  bool operator ==(Object other) =>
      other is KubbThrowIn && other.penalties == penalties;

  @override
  int get hashCode => penalties.hashCode;
}
