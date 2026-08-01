import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpHome(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [onboardingSeenProvider.overrideWithValue(true)],
      child: const IKubbApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Accessibility guardrails (WCAG AA / HIG): tap targets and labeled
/// controls on the core screens of both game modes.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> checkGuidelines(WidgetTester tester) async {
    final handle = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  }

  testWidgets('home meets tap-target and label guidelines', (tester) async {
    await pumpHome(tester);
    await checkGuidelines(tester);
  });

  testWidgets('number kubb game meets guidelines', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.text('Quick start'));
    await tester.pumpAndSettle();
    await checkGuidelines(tester);
  });

  testWidgets('classic kubb game meets guidelines', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kubb'));
    await tester.pumpAndSettle();
    for (final name in ['Anna', 'Björn']) {
      await tester.enterText(find.byType(TextField).first, name);
      await tester.tap(find.text('Add player'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Start game'));
    await tester.pumpAndSettle();
    await checkGuidelines(tester);
  });

  testWidgets('settings meets guidelines', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await checkGuidelines(tester);
  });
}
