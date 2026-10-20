import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:ikubb/features/settings/settings_controller.dart';
import 'package:ikubb/theme/palette.dart';
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
        child: const IKubbApp(),
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
      IKubbPalette.birchLight,
    );
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await addPlayers(tester, ['Jasper', 'Freya']);
    expect(
      paintedColor(tester, find.widgetWithText(FilledButton, 'Start game')),
      IKubbPalette.birchLight,
    );
    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();
    // Active side card (primaryContainer) and the tonal Miss button.
    expect(
      paintedColor(tester, find.text('Needs exactly 50').first),
      IKubbPalette.birchLight,
    );
    expect(
      paintedColor(tester, find.widgetWithText(FilledButton, 'Miss')),
      IKubbPalette.birchLight,
    );
  });

  testWidgets('the selected segment and text buttons stay readable', (
    tester,
  ) async {
    await pumpDark(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    // Selected segment: birch on night pine; unselected: onSurface.
    expect(paintedColor(tester, find.text('Dark')), IKubbPalette.birchLight);
    expect(paintedColor(tester, find.text('Light')), IKubbPalette.birchLight);
    // Text accent: sanded oak (8.7:1 on charcoal).
    final scheme = Theme.of(tester.element(find.text('Dark'))).colorScheme;
    expect(scheme.primary, IKubbPalette.oakLight);
    expect(scheme.primaryContainer, IKubbPalette.pineNight);
    expect(scheme.onPrimaryContainer, IKubbPalette.birchLight);
  });
}
