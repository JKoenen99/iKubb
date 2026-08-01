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

  // The type-size ramp. Every score()/heading() call site names a step —
  // never a raw number — so the whole hierarchy is visible in one place
  // (and on /designsystem).
  /// Chip and micro labels.
  static const double stepChip = 12;

  /// Inline numbers and small labels.
  static const double stepLabel = 16;

  /// Wordmark footnote, stat values.
  static const double stepBody = 18;

  /// App-bar titles.
  static const double stepTitle = 22;

  /// Section banners (share card, tour headlines).
  static const double stepHeadline = 28;

  /// Card-level scores and panel banners.
  static const double stepScoreCard = 32;

  /// Standings scores, big banners.
  static const double stepScoreLg = 40;

  /// Hero numbers (tour demo, win banner).
  static const double stepHero = 48;

  /// Field-readable banners (scoreboard winner).
  static const double stepDisplay = 64;

  /// The wordmark on Home.
  static const double stepWordmark = 72;

  /// Across-the-field scoreboard digits.
  static const double stepScoreboard = 120;

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

  // Platform-font companion styles — the only sanctioned inline styles.
  /// Emphasized body text: names, card titles.
  static const TextStyle emphasis = TextStyle(fontWeight: FontWeight.w600);

  /// Strong emphasis: player-card names, values.
  static const TextStyle strong = TextStyle(fontWeight: FontWeight.w700);

  /// Long-form reading text (tour cards, rule bodies in large context).
  static const TextStyle reading = TextStyle(fontSize: stepLabel, height: 1.4);

  /// Prominent stat/stepper values.
  static const TextStyle statValue = TextStyle(
    fontSize: stepBody,
    fontWeight: FontWeight.w700,
  );

  /// Card titles in lists (rule cards, player cards).
  static const TextStyle cardTitle = TextStyle(
    fontSize: stepBody,
    fontWeight: FontWeight.w800,
  );

  /// De-emphasized footnotes (dates, captions).
  static const TextStyle caption = TextStyle(fontSize: stepChip);
}
