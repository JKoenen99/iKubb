import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/game_screen.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:ikubb/features/stats/game_records_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> winAGame(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('I know the rules — start scoring'));
  await tester.pumpAndSettle();
  for (final name in ['Anna', 'Björn']) {
    await tester.enterText(find.byType(TextField).first, name);
    await tester.tap(find.text('Add player'));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.text('House rules'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Custom'));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextFormField, 'Custom'), '12');
  await tester.tap(find.text('Start game'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('12'));
  await tester.pump();
  await tester.tap(find.textContaining('Confirm throw'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('a finished game appears in history with player stats',
      (tester) async {
    await winAGame(tester);

    // Relaunch fresh (finished game: opens on Home) and open stats.
    await tester.pumpWidget(ProviderScope(
      key: UniqueKey(),
      overrides: [onboardingSeenProvider.overrideWithValue(true)],
      child: const IKubbApp(),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();

    // Player stats: Anna played 1, won 1, favorite pin 12.
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    // History entry with final scores.
    expect(find.textContaining('Anna 12'), findsOneWidget);
    expect(find.textContaining('Björn 0'), findsOneWidget);
  });

  testWidgets('an interrupted game resumes exactly, undo included',
      (tester) async {
    // Play two throws of a classic game, then "kill" the app.
    await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I know the rules — start scoring'));
    await tester.pumpAndSettle();
    for (final name in ['Anna', 'Björn']) {
      await tester.enterText(find.byType(TextField).first, name);
      await tester.tap(find.text('Add player'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Start game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();

    // Relaunch the way main() does: restore the active game.
    final restored = await GameRecordsRepository().loadActive();
    expect(restored, isNotNull);
    await tester.pumpWidget(ProviderScope(
      key: UniqueKey(),
      overrides: [
        onboardingSeenProvider.overrideWithValue(true),
        restoredGameProvider.overrideWithValue(restored),
      ],
      child: const IKubbApp(),
    ));
    await tester.pumpAndSettle();

    // The app opens on Home with Resume as the primary action, showing
    // the standings inline; tapping it lands in the exact game.
    expect(find.textContaining('Resume game'), findsOneWidget);
    expect(find.textContaining('Anna 5'), findsOneWidget);
    await tester.tap(find.textContaining('Resume game'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('Needs exactly 45'), findsNothing); // Anna threw 5...
    expect(find.text('Needs exactly 50'), findsOneWidget); // Björn's turn
    // Undo history survived the restore.
    await tester.tap(find.byIcon(Icons.undo));
    await tester.pumpAndSettle();
    expect(find.text('Needs exactly 50'), findsWidgets);
  });
}
