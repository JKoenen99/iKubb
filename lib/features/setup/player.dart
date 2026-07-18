import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import '../../theme/palette.dart';

/// Avatar colors players can pick from — drawn from the brand palette.
const playerColors = <Color>[
  IKubbPalette.forest,
  IKubbPalette.oak,
  IKubbPalette.pine,
  IKubbPalette.walnut,
  IKubbPalette.berry,
  IKubbPalette.amber,
  Colors.blueGrey,
  Colors.indigo,
];

/// An app-level player. The scoring engine only sees a [Side]; avatar and
/// color are presentation concerns kept here.
class Player {
  const Player({
    required this.id,
    required this.name,
    this.colorIndex = 0,
  });

  final String id;
  final String name;
  final int colorIndex;

  Color get color => playerColors[colorIndex % playerColors.length];

  Player copyWith({String? name, int? colorIndex}) => Player(
        id: id,
        name: name ?? this.name,
        colorIndex: colorIndex ?? this.colorIndex,
      );

  Map<String, Object?> toJson() =>
      {'id': id, 'name': name, 'colorIndex': colorIndex};

  factory Player.fromJson(Map<String, Object?> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
      );
}
