import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

import 'palette.dart';
import 'tokens.dart';
import 'typography.dart';

/// Light and dark themes built from the [KaatoPalette] tokens.
abstract final class KaatoTheme {
  static ThemeData get light => _base(
    const ColorScheme.light(
      primary: KaatoPalette.forest,
      onPrimary: KaatoPalette.birchLight,
      primaryContainer: KaatoPalette.forest,
      onPrimaryContainer: KaatoPalette.birchLight,
      secondary: KaatoPalette.oak,
      onSecondary: KaatoPalette.ink,
      secondaryContainer: KaatoPalette.oak,
      onSecondaryContainer: KaatoPalette.ink,
      surface: KaatoPalette.birchLight,
      onSurface: KaatoPalette.ink,
      surfaceContainerHighest: KaatoPalette.birch,
      outline: KaatoPalette.lineLight,
      outlineVariant: KaatoPalette.lineSoftLight,
      error: KaatoPalette.berry,
      onError: KaatoPalette.birchLight,
    ),
  );

  // Dark: sanded oak is the accent for text, strokes and focus (8.7:1 on
  // charcoal); filled controls use the night greens so their labels stay
  // light (primaryContainer / secondaryContainer, which every filled,
  // tonal and selected control is themed to use). Honey oak is reserved
  // for pins and player 1, so the accent never collides with an
  // identity color.
  static ThemeData get dark => _base(
    const ColorScheme.dark(
      primary: KaatoPalette.oakLight,
      onPrimary: KaatoPalette.ink,
      primaryContainer: KaatoPalette.pineNight,
      onPrimaryContainer: KaatoPalette.birchLight,
      secondary: KaatoPalette.oakLight,
      onSecondary: KaatoPalette.ink,
      secondaryContainer: KaatoPalette.mossNight,
      onSecondaryContainer: KaatoPalette.birchLight,
      surface: KaatoPalette.charcoalWood,
      onSurface: KaatoPalette.birchLight,
      surfaceContainerHighest: KaatoPalette.nightSurface,
      outline: KaatoPalette.lineDark,
      outlineVariant: KaatoPalette.lineSoftDark,
      error: KaatoPalette.berryLight,
      onError: KaatoPalette.ink,
    ),
  );

  /// iOS/macOS get the Liquid Glass idiom: capsule-shaped controls that
  /// are concentric with the glass bars holding them, bars with no
  /// background of their own (the glass widgets provide it), translucent
  /// menus. Android keeps the Material shapes.
  static bool get _cupertino =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static OutlinedBorder _controlShape(double materialRadius) => _cupertino
      ? const StadiumBorder()
      : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(materialRadius),
        );

  /// Inputs follow one recipe (the Airbnb / Polaris / HIG consensus): a
  /// quiet fill one step lighter than the card, a visible neutral border at
  /// rest, the primary color at twice the weight on focus, the danger color
  /// on error, and a soft border when disabled. Text fields, the select
  /// field and the segmented control all read as the same family.
  static InputDecorationTheme _inputTheme(ColorScheme scheme) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(KaatoRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: KaatoSpacing.lg,
        vertical: KaatoSpacing.md,
      ),
      hintStyle: TextStyle(
        color: scheme.onSurface.withValues(alpha: KaatoAlpha.faded),
      ),
      suffixIconColor: scheme.onSurface,
      prefixIconColor: scheme.onSurface,
      border: border(scheme.outline, KaatoBorder.hairline),
      enabledBorder: border(scheme.outline, KaatoBorder.hairline),
      focusedBorder: border(scheme.primary, KaatoBorder.line),
      errorBorder: border(scheme.error, KaatoBorder.hairline),
      focusedErrorBorder: border(scheme.error, KaatoBorder.line),
      disabledBorder: border(scheme.outlineVariant, KaatoBorder.hairline),
    );
  }

  static ThemeData _base(ColorScheme scheme) => ThemeData(
    colorScheme: scheme,
    inputDecorationTheme: _inputTheme(scheme),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: _inputTheme(scheme),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: scheme.primary),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
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
    // Filled controls draw on primaryContainer so the dark theme can keep
    // light labels (see the dark scheme above); in the light theme the
    // container pair equals primary/onPrimary.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        minimumSize: const Size(64, 56),
        textStyle: const TextStyle(
          fontSize: KaatoType.stepBody,
          fontWeight: FontWeight.w600,
        ),
        shape: _controlShape(KaatoRadius.lg),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(
          fontSize: KaatoType.stepLabel,
          fontWeight: FontWeight.w600,
        ),
        shape: _controlShape(KaatoRadius.lg),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 44),
        shape: _cupertino ? const StadiumBorder() : null,
      ),
    ),
    // Segmented controls are custom (widgets/segmented_control.dart):
    // a track and a raised tile, not Material's outlined SegmentedButton.
    // Chips share the recipe: neutral line at rest, primary when selected.
    chipTheme: ChipThemeData(
      shape: _cupertino ? const StadiumBorder() : null,
      backgroundColor: scheme.surface,
      selectedColor: scheme.primaryContainer,
      checkmarkColor: scheme.onPrimaryContainer,
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.selected)
              ? scheme.primaryContainer
              : scheme.outline,
          width: KaatoBorder.hairline,
        ),
      ),
      // Chips merge the theme style into their defaults, which keeps a
      // state-aware *color* but not a state-aware style: resolve the
      // color itself.
      labelStyle: TextStyle(
        color: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : scheme.onSurface,
        ),
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: TextStyle(
        color: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : scheme.onSurface,
        ),
        fontWeight: FontWeight.w600,
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? scheme.primaryContainer
            : null,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? scheme.onPrimaryContainer
            : null,
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KaatoRadius.xl),
      ),
    ),
    // Menus: translucent, rounder, with icons (HIG: menus adopt glass).
    popupMenuTheme: PopupMenuThemeData(
      color: _cupertino
          ? scheme.surface.withValues(alpha: KaatoAlpha.glassTint + 0.16)
          : null,
      elevation: _cupertino ? 2 : null,
      shape: _cupertino
          ? RoundedSuperellipseBorder(
              borderRadius: BorderRadius.circular(KaatoRadius.glass),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KaatoRadius.md),
            ),
    ),
    // Sheets draw their own glass body; the Material behind is invisible.
    bottomSheetTheme: _cupertino
        ? const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(),
          )
        : null,
    cardTheme: const CardThemeData(elevation: 0),
    // The wordmark and every screen title carry the brand font. On iOS
    // the bar itself is transparent: its buttons float in glass and a
    // scroll-edge fade keeps the title legible (see KaatoAppBar).
    appBarTheme: AppBarTheme(
      titleTextStyle: KaatoType.heading(
        size: KaatoType.stepTitle,
        color: scheme.onSurface,
      ),
      backgroundColor: _cupertino ? Colors.transparent : null,
      surfaceTintColor: _cupertino ? Colors.transparent : null,
      scrolledUnderElevation: _cupertino ? 0 : null,
      centerTitle: _cupertino ? true : null,
    ),
    textTheme: Typography.blackMountainView
        .copyWith(
          // Wordmark / hero numbers: brand font, tabular-lining numerals.
          displayLarge: KaatoType.score(size: KaatoType.stepWordmark),
          headlineMedium: KaatoType.heading(size: KaatoType.stepHeadline),
          titleMedium: const TextStyle(
            fontFamily: KaatoType.family,
            fontVariations: KaatoType.wBold,
            fontSize: 17,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
  );
}
