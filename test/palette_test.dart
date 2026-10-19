import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/features/setup/player.dart';
import 'package:ikubb/theme/palette.dart';

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
          contrast(IKubbPalette.oakLight, IKubbPalette.charcoalWood),
          greaterThan(4.5),
        );
        expect(
          contrast(IKubbPalette.oakLight, IKubbPalette.nightSurface),
          greaterThan(4.5),
        );
        // Ink stays readable on a sanded-oak fill (dark-theme primary button).
        expect(
          contrast(IKubbPalette.ink, IKubbPalette.oakLight),
          greaterThan(4.5),
        );
      },
    );

    test('honey oak carries ink text on light-theme fills', () {
      expect(contrast(IKubbPalette.ink, IKubbPalette.oak), greaterThan(4.5));
      // Oak still reads as a shape against the dark scoreboard field.
      expect(
        contrast(IKubbPalette.oak, IKubbPalette.forestDeep),
        greaterThan(3),
      );
    });

    test('walnut is the light-theme accent: AA as text on birch', () {
      expect(
        contrast(IKubbPalette.walnut, IKubbPalette.birchLight),
        greaterThan(4.5),
      );
      expect(
        contrast(IKubbPalette.walnut, IKubbPalette.birch),
        greaterThan(4.5),
      );
      // Team A pill: birch label on walnut.
      expect(
        contrast(IKubbPalette.birchLight, IKubbPalette.walnut),
        greaterThan(4.5),
      );
    });

    test('bark edges standing oak pins with a visible outline', () {
      expect(contrast(IKubbPalette.bark, IKubbPalette.oak), greaterThan(3));
    });

    test('woodAccent passes AA on the surfaces of its theme', () {
      expect(
        contrast(
          IKubbPalette.woodAccent(Brightness.light),
          IKubbPalette.birchLight,
        ),
        greaterThan(4.5),
      );
      expect(
        contrast(
          IKubbPalette.woodAccent(Brightness.dark),
          IKubbPalette.charcoalWood,
        ),
        greaterThan(4.5),
      );
    });
  });

  test('on() picks an AA foreground for every player color', () {
    for (final color in playerColors) {
      expect(
        contrast(IKubbPalette.on(color), color),
        greaterThan(4.5),
        reason: 'player color $color',
      );
    }
    for (final color in [
      IKubbPalette.oakLight,
      IKubbPalette.walnut,
      IKubbPalette.bark,
    ]) {
      expect(contrast(IKubbPalette.on(color), color), greaterThan(4.5));
    }
  });
}
