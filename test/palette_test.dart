import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaato/features/setup/player.dart';
import 'package:kaato/theme/palette.dart';

/// WCAG 2.x contrast ratio.
double contrast(Color a, Color b) {
  final la = a.computeLuminance() + 0.05;
  final lb = b.computeLuminance() + 0.05;
  return la > lb ? la / lb : lb / la;
}

void main() {
  group('wood ramp keeps its contrast promises', () {
    test(
      'sanded oak is the dark-theme accent: AA as text on dark surfaces',
      () {
        expect(
          contrast(KaatoPalette.oakLight, KaatoPalette.charcoalWood),
          greaterThan(4.5),
        );
        expect(
          contrast(KaatoPalette.oakLight, KaatoPalette.nightSurface),
          greaterThan(4.5),
        );
        // Ink stays readable on a sanded-oak fill (dark-theme primary button).
        expect(
          contrast(KaatoPalette.ink, KaatoPalette.oakLight),
          greaterThan(4.5),
        );
      },
    );

    test('honey oak carries ink text on light-theme fills', () {
      expect(contrast(KaatoPalette.ink, KaatoPalette.oak), greaterThan(4.5));
      // Oak still reads as a shape against the dark scoreboard field.
      expect(
        contrast(KaatoPalette.oak, KaatoPalette.forestDeep),
        greaterThan(3),
      );
    });

    test('walnut is the light-theme accent: AA as text on birch', () {
      expect(
        contrast(KaatoPalette.walnut, KaatoPalette.birchLight),
        greaterThan(4.5),
      );
      expect(
        contrast(KaatoPalette.walnut, KaatoPalette.birch),
        greaterThan(4.5),
      );
      // Team A pill: birch label on walnut.
      expect(
        contrast(KaatoPalette.birchLight, KaatoPalette.walnut),
        greaterThan(4.5),
      );
    });

    test('bark edges standing oak pins with a visible outline', () {
      expect(contrast(KaatoPalette.bark, KaatoPalette.oak), greaterThan(3));
    });

    test('woodAccent passes AA on the surfaces of its theme', () {
      expect(
        contrast(
          KaatoPalette.woodAccent(Brightness.light),
          KaatoPalette.birchLight,
        ),
        greaterThan(4.5),
      );
      expect(
        contrast(
          KaatoPalette.woodAccent(Brightness.dark),
          KaatoPalette.charcoalWood,
        ),
        greaterThan(4.5),
      );
    });
  });

  test('night fills keep light labels in the dark theme', () {
    expect(
      contrast(KaatoPalette.birchLight, KaatoPalette.pineNight),
      greaterThan(4.5),
    );
    expect(
      contrast(KaatoPalette.pineNight, KaatoPalette.charcoalWood),
      greaterThan(3),
    );
    expect(
      contrast(KaatoPalette.birchLight, KaatoPalette.mossNight),
      greaterThan(4.5),
    );
    // Sanded oak stays the text accent on dark surfaces.
    expect(
      contrast(KaatoPalette.oakLight, KaatoPalette.charcoalWood),
      greaterThan(4.5),
    );
  });

  test('input lines reach 3:1 on the cards they sit on (WCAG 1.4.11)', () {
    expect(
      contrast(KaatoPalette.lineLight, KaatoPalette.birch),
      greaterThan(3),
    );
    expect(
      contrast(KaatoPalette.lineLight, KaatoPalette.birchLight),
      greaterThan(3),
    );
    expect(
      contrast(KaatoPalette.lineDark, KaatoPalette.nightSurface),
      greaterThan(3),
    );
    expect(
      contrast(KaatoPalette.lineDark, KaatoPalette.charcoalWood),
      greaterThan(3),
    );
    // The dark-theme error color is the one that reads on dark cards.
    expect(
      contrast(KaatoPalette.berryLight, KaatoPalette.nightSurface),
      greaterThan(4.5),
    );
  });

  test('on() picks an AA foreground for every player color', () {
    for (final color in playerColors) {
      expect(
        contrast(KaatoPalette.on(color), color),
        greaterThan(4.5),
        reason: 'player color $color',
      );
    }
    for (final color in [
      KaatoPalette.oakLight,
      KaatoPalette.walnut,
      KaatoPalette.bark,
    ]) {
      expect(contrast(KaatoPalette.on(color), color), greaterThan(4.5));
    }
  });
}
