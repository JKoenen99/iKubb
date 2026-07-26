import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/share_card.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

Future<void> pumpHome(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [onboardingSeenProvider.overrideWithValue(true)],
      child: const IKubbApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'no screen is a dead end: game exits home, stats always reachable',
    (tester) async {
      await pumpHome(tester);

      // Home → game via quick start (replaces the stack)...
      await tester.tap(find.text('Quick start'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm throw (+0)'), findsOneWidget);

      // ...stats is reachable from the game's overflow menu...
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Stats'));
      await tester.pumpAndSettle();
      expect(find.text('No games yet — the field awaits!'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // ...and the home leading always exits the game.
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Quick start'), findsOneWidget);

      // Hub screens pushed from home keep a back button.
      await tester.tap(find.text('Stats'));
      await tester.pumpAndSettle();
      expect(find.byType(BackButton), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Quick start'), findsOneWidget);
    },
  );

  testWidgets('settings: language override switches the app language', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nederlands').last);
    await tester.pumpAndSettle();

    // The settings screen itself re-renders in Dutch...
    expect(find.text('Instellingen'), findsOneWidget);
    expect(find.text('Taal'), findsOneWidget);

    // ...and so does home after going back.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Snel starten'), findsOneWidget);

    // The override persists.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('locale_override_v1'), 'nl');
  });

  testWidgets('the win overlay offers a share card preview', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    for (final name in ['Anna', 'Björn']) {
      await tester.enterText(find.byType(TextField).first, name);
      await tester.tap(find.text('Add player'));
      await tester.pumpAndSettle();
    }
    await tester.tapVisible(find.text('House rules'));
    await tester.pumpAndSettle();
    await tester.tapVisible(find.text('Custom'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Custom'), '12');
    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();

    // The preview shows the branded result card with the standings.
    expect(find.byType(ShareCard), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ShareCard),
        matching: find.text('Anna wins!'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('new game asks for confirmation only mid-game', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.text('Quick start'));
    await tester.pumpAndSettle();

    // Score a throw so the game is genuinely in progress.
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();

    // New game from the overflow now needs consent.
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    expect(find.text('Start a new game?'), findsOneWidget);

    // Cancel keeps the game...
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsWidgets); // score still on the board

    // ...confirming resets it.
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New game').last); // dialog action
    await tester.pumpAndSettle();
    expect(find.text('Needs exactly 50'), findsOneWidget);
  });
}
