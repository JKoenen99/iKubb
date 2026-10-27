import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:ikubb/features/settings/app_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('AppVersion', () {
    test('reads as "version (build)"', () {
      expect(
        AppVersion(version: '0.2.0', buildNumber: '2', commit: '').short,
        '0.2.0 (2)',
      );
      expect(
        AppVersion(version: '0.2.0', buildNumber: '', commit: '').short,
        '0.2.0',
      );
    });

    test('shortens a full commit hash and keeps the local-changes mark', () {
      expect(
        AppVersion.shortCommit('58cf66b1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7'),
        '58cf66b',
      );
      expect(AppVersion.shortCommit('58cf66b+'), '58cf66b+');
      expect(AppVersion.shortCommit(''), '');
    });
  });

  testWidgets('Settings shows which build is on the device', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingSeenProvider.overrideWithValue(true),
          appVersionProvider.overrideWith(
            (ref) async => AppVersion(
              version: '0.2.0',
              buildNumber: '2',
              commit: '58cf66b',
            ),
          ),
        ],
        child: const IKubbApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    final footer = find.text('Version 0.2.0 (2), commit 58cf66b');
    await tester.scrollUntilVisible(
      footer,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(footer, findsOneWidget);
  });
}
