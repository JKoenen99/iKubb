import 'dart:ui';

/// Design tokens: "Scandinavian modern, Viking soul".
///
/// Light birchwood neutrals for surfaces, deep forest greens for primary
/// actions and brand, a four-tone wood ramp (sanded oak → bark) for
/// accents, off-black ink for text. See SPEC.md §4 and
/// docs/WOOD_PALETTE.md.
abstract final class IKubbPalette {
  // Birchwood neutrals (light surfaces)
  static const birchLight = Color(0xFFF5EFE6);
  static const birch = Color(0xFFE8DCC8);

  // Forest greens (brand / primary)
  static const forest = Color(0xFF2F4A3C);
  static const forestDeep = Color(0xFF1E332A);
  static const pine = Color(0xFF4A6B58);
  static const sage = Color(0xFF86AA93); // dark-theme primary (AA as text)

  // Wood ramp: four tones with fixed roles, tuned as one material under one
  // light (hue 27–37°, saturation rising as the wood darkens, like real
  // oak and walnut). Each tone is placed where it passes WCAG AA for the
  // job it does (see test/palette_test.dart):
  //   oakLight  sanded oak   accent on dark surfaces (8.7:1 on charcoal as
  //                          text), the dark-theme primary, highlights.
  //   oak       honey oak    light-theme accent fills (ink on oak 5.7:1),
  //                          standing pins and kubbs, player color 1.
  //   walnut    walnut       accent on light surfaces (8.4:1 on birch), the
  //                          Team A identity, fallen pins, linework.
  //   bark      bark         deepest wood: outlines, knots, pin edges.
  static const oakLight = Color(0xFFDDB67A);
  static const oak = Color(0xFFC68F43);
  static const walnut = Color(0xFF5F3D25);
  static const bark = Color(0xFF3B2616);

  /// The wood accent that reads on the current theme's surfaces: walnut
  /// on birch, sanded oak on charcoal. Use for wooden icons, dots and
  /// strokes that sit directly on a surface.
  static Color woodAccent(Brightness brightness) =>
      brightness == Brightness.dark ? oakLight : walnut;

  /// Grain color for [WoodGrainBackground] on brand surfaces.
  static Color woodGrain(Brightness brightness) =>
      brightness == Brightness.dark ? oakLight : walnut;

  /// Text or glyph color on a colored fill (avatars, pills, chips): ink on
  /// light fills such as oak and amber, birch on dark ones. Threshold at
  /// the luminance where both candidates pass AA against the fill.
  static Color on(Color fill) =>
      fill.computeLuminance() > 0.26 ? ink : birchLight;

  // Text
  static const ink = Color(0xFF22201B);

  // Signals. berry passes AA as text on birch surfaces; berryLight is its
  // counterpart for dark surfaces (scoreboard, dark cards).
  static const amber = Color(0xFFD9A441); // overshoot warning
  static const berry = Color(0xFF9E4136); // elimination / danger (light)
  static const berryLight = Color(0xFFE39C8F); // danger on dark surfaces

  /// Danger color with AA contrast on the current theme's surfaces.
  static Color danger(Brightness brightness) =>
      brightness == Brightness.dark ? berryLight : berry;

  // Dark theme (night-forest greens on charcoal-wood)
  static const charcoalWood = Color(0xFF181C18);
  static const nightSurface = Color(0xFF232A24);

  // Player-identity hues (paired with oak/berry/amber above). Deliberately
  // exclude the brand surface greens so an identity color never disappears
  // against the active card or the scoreboard field.
  static const fjord = Color(0xFF4A6B8A);
  static const plum = Color(0xFF7B4A6E);
  static const copper = Color(0xFFA85420); // deep enough for a birch initial
  static const slate = Color(0xFF546E7A);
  static const indigo = Color(0xFF4E5A9E);

  // Mascot-only tones (skin + blush of the code-drawn Viking).
  static const mascotSkin = Color(0xFFF0C9A5);
  static const mascotBlush = Color(0x33A84A3F);
}
