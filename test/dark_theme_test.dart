import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaato/app.dart';
import 'package:kaato/features/onboarding/onboarding_state.dart';
import 'package:kaato/features/settings/settings_controller.dart';
import 'package:kaato/theme/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

class _Dark extends ThemeModeController {
  @override
  ThemeMode build() => ThemeMode.dark;
}

/// The painted color of a text, after the theme and every default style.
Color paintedColor(WidgetTester tester, Finder text) {
  final paragraph = tester.renderObject<RenderParagraph>(
    find.descendant(of: text, matching: find.byType(RichText)).first,
  );
  return paragraph.text.style!.color!;
}

/// Dark theme: filled, tonal and selected controls keep light labels
/// (night-green fills); sanded oak is only the text accent.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpDark(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingSeenProvider.overrideWithValue(true),
          themeModeProvider.overrideWith(_Dark.new),
        ],
        child: const KaatoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('filled buttons and the active side carry birch labels', (
    tester,
  ) async {
    await pumpDark(tester);
    expect(
      paintedColor(tester, find.widgetWithText(FilledButton, 'New game')),
      KaatoPalette.birchLight,
    );
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await addPlayers(tester, ['Jasper', 'Freya']);
    expect(
      paintedColor(tester, find.widgetWithText(FilledButton, 'Start game')),
      KaatoPalette.birchLight,
    );
    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();
    // Active side card (primaryContainer) and the tonal Miss button.
    expect(
      paintedColor(tester, find.text('Needs exactly 50').first),
      KaatoPalette.birchLight,
    );
    expect(
      paintedColor(tester, find.widgetWithText(FilledButton, 'Miss')),
      KaatoPalette.birchLight,
    );
  });

  testWidgets('the selected segment and text buttons stay readable', (
    tester,
  ) async {
    await pumpDark(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    // Segmented control: the active label is full birch on the raised
    // tile, the others birch at 70% on the track; never ink.
    expect(paintedColor(tester, find.text('Dark')), KaatoPalette.birchLight);
    expect(
      paintedColor(tester, find.text('Light')),
      KaatoPalette.birchLight.withValues(alpha: 0.7),
    );
    // Text accent: sanded oak (8.7:1 on charcoal).
    final scheme = Theme.of(tester.element(find.text('Dark'))).colorScheme;
    expect(scheme.primary, KaatoPalette.oakLight);
    expect(scheme.primaryContainer, KaatoPalette.pineNight);
    expect(scheme.onPrimaryContainer, KaatoPalette.birchLight);
  });
}
