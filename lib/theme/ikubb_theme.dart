import 'package:flutter/material.dart';

import 'palette.dart';

/// Light and dark themes built from the [IKubbPalette] tokens.
abstract final class IKubbTheme {
  static ThemeData get light => _base(const ColorScheme.light(
        primary: IKubbPalette.forest,
        onPrimary: IKubbPalette.birchLight,
        secondary: IKubbPalette.oak,
        onSecondary: IKubbPalette.ink,
        surface: IKubbPalette.birchLight,
        onSurface: IKubbPalette.ink,
        surfaceContainerHighest: IKubbPalette.birch,
        error: IKubbPalette.berry,
        onError: IKubbPalette.birchLight,
      ));

  static ThemeData get dark => _base(const ColorScheme.dark(
        primary: IKubbPalette.pine,
        onPrimary: IKubbPalette.birchLight,
        secondary: IKubbPalette.oak,
        onSecondary: IKubbPalette.ink,
        surface: IKubbPalette.charcoalWood,
        onSurface: IKubbPalette.birchLight,
        surfaceContainerHighest: IKubbPalette.nightSurface,
        error: IKubbPalette.berry,
        onError: IKubbPalette.birchLight,
      ));

  static ThemeData _base(ColorScheme scheme) => ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
        // Outdoor-first ergonomics: oversized touch targets everywhere.
        materialTapTargetSize: MaterialTapTargetSize.padded,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(64, 56),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        textTheme: Typography.blackMountainView.copyWith(
          // Scores use large tabular-lining numerals.
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w800,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ).apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        ),
      );
}
