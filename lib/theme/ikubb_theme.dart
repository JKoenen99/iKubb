import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'palette.dart';
import 'tokens.dart';
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
    // HIG: the iOS edge-swipe back gesture works on every pushed route.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: const TextStyle(
          fontSize: IKubbType.stepBody,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IKubbRadius.lg),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(
          fontSize: IKubbType.stepLabel,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IKubbRadius.lg),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 44)),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(IKubbRadius.xl),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(IKubbRadius.md),
      ),
    ),
    cardTheme: const CardThemeData(elevation: 0),
    // The wordmark and every screen title carry the brand font.
    appBarTheme: AppBarTheme(
      titleTextStyle: IKubbType.heading(
        size: IKubbType.stepTitle,
        color: scheme.onSurface,
      ),
    ),
    textTheme: Typography.blackMountainView
        .copyWith(
          // Wordmark / hero numbers: brand font, tabular-lining numerals.
          displayLarge: IKubbType.score(size: IKubbType.stepWordmark),
          headlineMedium: IKubbType.heading(size: IKubbType.stepHeadline),
          titleMedium: const TextStyle(
            fontFamily: IKubbType.family,
            fontVariations: IKubbType.wBold,
            fontSize: 17,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
  );
}
