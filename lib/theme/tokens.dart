import 'package:flutter/widgets.dart';

/// Layout and motion design tokens. Everything visual that is not a color
/// (palette.dart) or a text style (typography.dart) lives here — no screen
/// should carry raw spacing, radius, duration, alpha, or size literals.
///
/// Exemption: code-drawn artwork (the mascot painter, wood grain, rule
/// illustrations, the geometry of pins and kubb blocks) is vector art;
/// its internal coordinates stay literal, only its colors are tokens.
abstract final class IKubbSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Hero gaps (Home wordmark to actions).
  static const double huge = 48;
}

abstract final class IKubbRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double chip = 10;
  static const double md = 12;

  /// Cards, buttons, inputs.
  static const double lg = 16;

  /// Large surfaces: overlays, scoreboard columns, share card.
  static const double xl = 24;
}

abstract final class IKubbBorder {
  static const double hairline = 1.5;
  static const double line = 2;
  static const double focus = 3;
  static const double frame = 4;
}

/// One motion vocabulary for the whole app: state changes first, animation
/// as decoration (SPEC.md §3.7). Route every duration through [resolve] so
/// Reduce Motion collapses them to zero in a single place.
abstract final class IKubbMotion {
  /// Micro feedback: selection, toggles, small movements.
  static const quick = Duration(milliseconds: 200);

  /// The default: standings, cards, opacity shifts.
  static const base = Duration(milliseconds: 250);

  /// Screen-level entrances (page swipes, overlays).
  static const entrance = Duration(milliseconds: 300);

  /// Expressive accents (mascot, celebrations).
  static const gentle = Duration(milliseconds: 350);

  static const standard = Curves.easeOut;
  static const emphasized = Curves.easeOutBack;
  static const enter = Curves.easeOutCubic;

  /// [duration], or zero when the platform asks for reduced motion.
  static Duration resolve(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}

/// Opacity steps with fixed meanings — never invent a new alpha inline.
abstract final class IKubbAlpha {
  /// Idle dot / inactive indicator.
  static const double dotIdle = 0.3;

  /// Identity-color tint behind the active column.
  static const double activeTint = 0.45;

  /// De-emphasized text (dates, footnotes).
  static const double faded = 0.7;

  /// Full-screen scrim behind overlays.
  static const double scrim = 0.92;

  /// Wood-grain texture on brand surfaces.
  static const double grain = 0.06;
}

abstract final class IKubbIconSize {
  /// Miss/win dots.
  static const double dot = 10;
  static const double sm = 18;
  static const double md = 20;
  static const double lg = 24;

  /// Dots readable from across the field (scoreboard).
  static const double field = 26;
  static const double xl = 28;
  static const double display = 32;
}

/// Content max-widths: phone-first columns that stay readable on iPad.
abstract final class IKubbLayout {
  static const double maxColumn = 420;
  static const double maxOverlay = 480;
  static const double maxContent = 560;
  static const double maxPanel = 640;
}
