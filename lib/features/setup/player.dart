import 'dart:ui';

import '../../theme/palette.dart';

/// Player-identity colors. Deliberately excludes the brand surface hues
/// (forest, pine) so a player's color never disappears against the active
/// card or the scoreboard field (UX audit finding #1). Every hue reads on
/// both birch and dark-green surfaces.
const playerColors = <Color>[
  IKubbPalette.oak,
  Color(0xFF4A6B8A), // fjord blue
  IKubbPalette.berry,
  IKubbPalette.amber,
  Color(0xFF7B4A6E), // plum
  Color(0xFFB05C2A), // copper
  Color(0xFF546E7A), // slate
  Color(0xFF4E5A9E), // indigo
];

/// An app-level player. The scoring engine only sees a [Side]; avatar and
/// color are presentation concerns kept here.
class Player {
  const Player({required this.id, required this.name, this.colorIndex = 0});

  final String id;
  final String name;
  final int colorIndex;

  Color get color => playerColors[colorIndex % playerColors.length];

  Player copyWith({String? name, int? colorIndex}) => Player(
    id: id,
    name: name ?? this.name,
    colorIndex: colorIndex ?? this.colorIndex,
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
