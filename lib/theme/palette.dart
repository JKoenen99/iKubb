import 'dart:ui';


/// Design tokens: "Scandinavian modern, Viking soul".
///
/// Light birchwood neutrals for surfaces, deep forest greens for primary
/// actions and brand, warm oak/walnut for accents, off-black ink for text.
/// See SPEC.md §4.
abstract final class IKubbPalette {
  // Birchwood neutrals (light surfaces)
  static const birchLight = Color(0xFFF5EFE6);
  static const birch = Color(0xFFE8DCC8);

  // Forest greens (brand / primary)
  static const forest = Color(0xFF2F4A3C);
  static const forestDeep = Color(0xFF1E332A);
  static const pine = Color(0xFF4A6B58);
  static const sage = Color(0xFF86AA93); // dark-theme primary (AA as text)

  // Oak & walnut (accents, pin illustrations)
  static const oak = Color(0xFFB98A4E);
  static const walnut = Color(0xFF6B4A2F);

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
}
