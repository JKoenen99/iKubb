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

  // Oak & walnut (accents, pin illustrations)
  static const oak = Color(0xFFB98A4E);
  static const walnut = Color(0xFF6B4A2F);

  // Text
  static const ink = Color(0xFF22201B);

  // Signals
  static const amber = Color(0xFFD9A441); // overshoot warning
  static const berry = Color(0xFFA84A3F); // elimination / danger

  // Dark theme (night-forest greens on charcoal-wood)
  static const charcoalWood = Color(0xFF181C18);
  static const nightSurface = Color(0xFF232A24);
}
