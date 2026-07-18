import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpToSetup(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('I know the rules — start scoring'));
  await tester.pumpAndSettle();
}

Future<void> addPlayer(WidgetTester tester, String name) async {
  await tester.enterText(find.byType(TextField).first, name);
  await tester.tap(find.text('Add player'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('set up a 2-player game with a custom target', (tester) async {
    await pumpToSetup(tester);

    // Start is blocked until two players exist.
    expect(find.text('Add at least 2 players'), findsOneWidget);
    await addPlayer(tester, 'Jasper');
    await addPlayer(tester, 'Freya');

    // House rules: expand, pick target 25.
    await tester.tap(find.text('House rules'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('25'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start game'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Jasper'), findsOneWidget);
    expect(find.text('Freya'), findsOneWidget);
    expect(find.text('Needs exactly 25'), findsOneWidget);
  });

  testWidgets('team mode plays as two sides with custom names',
      (tester) async {
    await pumpToSetup(tester);

    for (final name in ['Jasper', 'Freya', 'Erik', 'Saga']) {
      await addPlayer(tester, name);
    }

    // Enable teams; default alternating assignment covers both teams.
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Team A'), 'Ravens');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start game'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Ravens'), findsOneWidget); // custom team A name
    expect(find.text('Team B'), findsOneWidget); // default team B name
    expect(find.text('Jasper'), findsNothing); // sides are teams, not players
  });

  testWidgets('players are remembered as recents for the next setup',
      (tester) async {
    await pumpToSetup(tester);
    await addPlayer(tester, 'Jasper');
    await addPlayer(tester, 'Freya');
    await tester.tap(find.text('Start game'));
    await tester.pumpAndSettle();

    // Relaunch the app: a fresh scope must offer the players as chips.
    await tester.pumpWidget(ProviderScope(key: UniqueKey(), child: const IKubbApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I know the rules — start scoring'));
    await tester.pumpAndSettle();

    expect(find.text('Recent players'), findsOneWidget);
    expect(find.text('Jasper'), findsOneWidget);
    expect(find.text('Freya'), findsOneWidget);
  });
}
