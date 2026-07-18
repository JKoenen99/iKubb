import 'package:flutter/material.dart';

/// Brand typography: Baloo 2 (OFL, bundled — no runtime CDN fetch) carries
/// the wordmark, headings, and scores; body text stays on the platform
/// font. The rounded, chunky cuts echo the mascot's linework (SPEC.md §4,
/// UX audit finding #2).
abstract final class IKubbType {
  static const family = 'Baloo2';

  /// Variable-font weight axes (the bundled file is a variable TTF).
  static const wBold = [FontVariation('wght', 700)];
  static const wXBold = [FontVariation('wght', 800)];

  /// Display style for scores and numbers: rounded + tabular figures.
  static TextStyle score({required double size, Color? color}) => TextStyle(
        fontFamily: family,
        fontVariations: wXBold,
        fontSize: size,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
        height: 1.1,
      );

  static TextStyle heading({required double size, Color? color}) => TextStyle(
        fontFamily: family,
        fontVariations: wXBold,
        fontSize: size,
        color: color,
      );
}
