import 'package:meta/meta.dart' show immutable;

/// A competing side: a single player or a team.
///
/// The engine does not care which — team membership, avatars, and colors are
/// app-level concerns. The engine only needs a stable [id] and a [name] for
/// error messages and debugging.
@immutable
class Side {
  const Side({required this.id, required this.name});

  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is Side && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);

  Map<String, Object?> toJson() => {'id': id, 'name': name};

  factory Side.fromJson(Map<String, Object?> json) =>
      Side(id: json['id'] as String, name: json['name'] as String);

  @override
  String toString() => 'Side($id, $name)';
}
