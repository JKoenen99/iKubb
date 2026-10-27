import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaato/app.dart';
import 'package:kaato/features/designsystem/design_system_screen.dart';
import 'package:kaato/features/onboarding/onboarding_state.dart';
import 'package:kaato/features/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

/// The design-system catalog is a living document: every story must build
/// in both themes, the jump navigation must land on its section, and the
/// interactive samples must keep the tap-target and label guidelines.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpCatalog(WidgetTester tester, {ThemeMode? mode}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingSeenProvider.overrideWithValue(true),
          if (mode != null) themeModeProvider.overrideWith(() => _Fixed(mode)),
        ],
        child: const KaatoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Design system'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tapVisible(find.text('Design system'));
    await tester.pumpAndSettle();
    expect(find.byType(DesignSystemScreen), findsOneWidget);
  }

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('every story builds and scrolls in ${mode.name} theme', (
      tester,
    ) async {
      await pumpCatalog(tester, mode: mode);
      // Scroll through the whole catalog: a layout error anywhere fails.
      final scrollable = find
          .descendant(
            of: find.byType(DesignSystemScreen),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('KeepAwake'),
        400,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      expect(find.text('KeepAwake'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the jump chips land on their section', (tester) async {
    await pumpCatalog(tester);
    await tester.tapVisible(find.widgetWithText(ActionChip, 'Game pieces'));
    await tester.pumpAndSettle();
    expect(find.text('PinDiagram'), findsOneWidget);
  });

  testWidgets('interactive samples keep the a11y guidelines', (tester) async {
    await pumpCatalog(tester);
    final handle = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });
}

class _Fixed extends ThemeModeController {
  _Fixed(this.mode);

  final ThemeMode mode;

  @override
  ThemeMode build() => mode;
}
