import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
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
      outline: IKubbPalette.lineLight,
      outlineVariant: IKubbPalette.lineSoftLight,
      error: IKubbPalette.berry,
      onError: IKubbPalette.birchLight,
    ),
  );

  // Dark: sanded oak is the accent (selected cards, toggles, the Start
  // button): 8.7:1 on charcoal as text, ink on it for fills. Honey oak is
  // reserved for pins, kubbs and player 1 so the accent never collides
  // with an identity color.
  static ThemeData get dark => _base(
    const ColorScheme.dark(
      primary: IKubbPalette.oakLight,
      onPrimary: IKubbPalette.ink,
      secondary: IKubbPalette.oakLight,
      onSecondary: IKubbPalette.ink,
      surface: IKubbPalette.charcoalWood,
      onSurface: IKubbPalette.birchLight,
      surfaceContainerHighest: IKubbPalette.nightSurface,
      outline: IKubbPalette.lineDark,
      outlineVariant: IKubbPalette.lineSoftDark,
      error: IKubbPalette.berryLight,
      onError: IKubbPalette.ink,
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
      borderRadius: BorderRadius.circular(IKubbRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: IKubbSpacing.lg,
        vertical: IKubbSpacing.md,
      ),
      hintStyle: TextStyle(
        color: scheme.onSurface.withValues(alpha: IKubbAlpha.faded),
      ),
      suffixIconColor: scheme.onSurface,
      prefixIconColor: scheme.onSurface,
      border: border(scheme.outline, IKubbBorder.hairline),
      enabledBorder: border(scheme.outline, IKubbBorder.hairline),
      focusedBorder: border(scheme.primary, IKubbBorder.line),
      errorBorder: border(scheme.error, IKubbBorder.hairline),
      focusedErrorBorder: border(scheme.error, IKubbBorder.line),
      disabledBorder: border(scheme.outlineVariant, IKubbBorder.hairline),
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
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: const TextStyle(
          fontSize: IKubbType.stepBody,
          fontWeight: FontWeight.w600,
        ),
        shape: _controlShape(IKubbRadius.lg),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(
          fontSize: IKubbType.stepLabel,
          fontWeight: FontWeight.w600,
        ),
        shape: _controlShape(IKubbRadius.lg),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 44),
        shape: _cupertino ? const StadiumBorder() : null,
      ),
    ),
    // Segmented control: the input border at rest, the primary fill for
    // the chosen segment (a strong, unambiguous selected state), and the
    // 48pt tap minimum (outdoor thumbs, WCAG 2.5.8).
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: _controlShape(IKubbRadius.md),
        side: BorderSide(color: scheme.outline, width: IKubbBorder.hairline),
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        selectedBackgroundColor: scheme.primary,
        selectedForegroundColor: scheme.onPrimary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    // Chips share the recipe: neutral line at rest, primary when selected.
    chipTheme: ChipThemeData(
      shape: _cupertino ? const StadiumBorder() : null,
      backgroundColor: scheme.surface,
      selectedColor: scheme.primary,
      checkmarkColor: scheme.onPrimary,
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.outline,
          width: IKubbBorder.hairline,
        ),
      ),
      labelStyle: WidgetStateTextStyle.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? scheme.onPrimary
              : scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      secondaryLabelStyle: TextStyle(
        color: scheme.onPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(IKubbRadius.xl),
      ),
    ),
    // Menus: translucent, rounder, with icons (HIG: menus adopt glass).
    popupMenuTheme: PopupMenuThemeData(
      color: _cupertino
          ? scheme.surface.withValues(alpha: IKubbAlpha.glassTint + 0.16)
          : null,
      elevation: _cupertino ? 2 : null,
      shape: _cupertino
          ? RoundedSuperellipseBorder(
              borderRadius: BorderRadius.circular(IKubbRadius.glass),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(IKubbRadius.md),
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
    // scroll-edge fade keeps the title legible (see IKubbAppBar).
    appBarTheme: AppBarTheme(
      titleTextStyle: IKubbType.heading(
        size: IKubbType.stepTitle,
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
