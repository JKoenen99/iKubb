import 'package:flutter/material.dart';

import 'palette.dart';
import 'typography.dart';

/// Light and dark themes built from the [IKubbPalette] tokens.
abstract final class IKubbTheme {
  static ThemeData get light => _base(
    const ColorScheme.light(
      primary: IKubbPalette.forest,
      onPrimary: IKubbPalette.birchLight,
      secondary: IKubbPalette.oak,
      onSecondary: IKubbPalette.ink,
      surface: IKubbPalette.birchLight,
      onSurface: IKubbPalette.ink,
      surfaceContainerHighest: IKubbPalette.birch,
      error: IKubbPalette.berry,
      onError: IKubbPalette.birchLight,
    ),
  );

  static ThemeData get dark => _base(
    const ColorScheme.dark(
      primary: IKubbPalette.sage,
      onPrimary: IKubbPalette.ink,
      secondary: IKubbPalette.oak,
      onSecondary: IKubbPalette.ink,
      surface: IKubbPalette.charcoalWood,
      onSurface: IKubbPalette.birchLight,
      surfaceContainerHighest: IKubbPalette.nightSurface,
      error: IKubbPalette.berry,
      onError: IKubbPalette.birchLight,
    ),
  );

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
    // The wordmark and every screen title carry the brand font.
    appBarTheme: AppBarTheme(
      titleTextStyle: IKubbType.heading(size: 22, color: scheme.onSurface),
    ),
    textTheme: Typography.blackMountainView
        .copyWith(
          // Wordmark / hero numbers: brand font, tabular-lining numerals.
          displayLarge: IKubbType.score(size: 72),
          headlineMedium: IKubbType.heading(size: 28),
          titleMedium: TextStyle(
            fontFamily: IKubbType.family,
            fontVariations: IKubbType.wBold,
            fontSize: 17,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
  );
}
