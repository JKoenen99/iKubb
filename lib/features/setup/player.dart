import 'package:flutter/widgets.dart';

import '../../theme/palette.dart';

/// Player-identity colors. Deliberately excludes the brand surface hues
/// (forest, pine) so a player's color never disappears against the active
/// card or the scoreboard field (UX audit finding #1). Every hue reads on
/// both birch and dark-green surfaces.
const playerColors = <Color>[
  KaatoPalette.oak,
  KaatoPalette.fjord,
  KaatoPalette.berry,
  KaatoPalette.amber,
  KaatoPalette.plum,
  KaatoPalette.copper,
  KaatoPalette.slate,
  KaatoPalette.indigo,
];

/// An app-level player. The scoring engine only sees a [Side]; avatar and
/// color are presentation concerns kept here.
class Player {
  const Player({
    required this.id,
    required this.name,
    this.colorIndex = 0,
    this.autoNumber,
  });

  final String id;
  final String name;
  final int colorIndex;

  /// Set while the player still carries the generated "Player N" name:
  /// the avatar shows this number instead of an initial, and the player
  /// is not remembered as a recent until renamed.
  final int? autoNumber;

  bool get isAutoNamed => autoNumber != null;

  Color get color => playerColors[colorIndex % playerColors.length];

  /// The avatar label: the number for unnamed players, else the initial.
  String get avatarLabel => autoNumber != null
      ? '$autoNumber'
      : (name.isEmpty ? '?' : name.characters.first.toUpperCase());

  Player copyWith({String? name, int? colorIndex, int? autoNumber}) => Player(
    id: id,
    name: name ?? this.name,
    colorIndex: colorIndex ?? this.colorIndex,
    autoNumber: autoNumber,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'colorIndex': colorIndex,
  };

  factory Player.fromJson(Map<String, Object?> json) => Player(
    id: json['id'] as String,
    name: json['name'] as String,
    colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
  );
}
