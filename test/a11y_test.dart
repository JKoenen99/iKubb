import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaato/app.dart';
import 'package:kaato/features/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpHome(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [onboardingSeenProvider.overrideWithValue(true)],
      child: const KaatoApp(),
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

  testWidgets('settings meets guidelines', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await checkGuidelines(tester);
  });
}
