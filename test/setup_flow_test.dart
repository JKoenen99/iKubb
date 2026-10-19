import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

Future<void> pumpToSetup(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('I know the rules, start scoring'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('set up a 2-player game with a custom target', (tester) async {
    await pumpToSetup(tester);

    // Start is blocked until two players exist.
    expect(find.text('Add at least 2 players'), findsOneWidget);
    await addPlayers(tester, ['Jasper', 'Freya']);
    expect(find.text('Add at least 2 players'), findsNothing);

    // House rules: the target stepper counts in fives.
    for (var i = 0; i < 5; i++) {
      await tester.tapVisible(find.byTooltip('Decrease').first);
      await tester.pumpAndSettle();
    }
    expect(find.text('25'), findsOneWidget);
    // Back-to follows the target down so it always stays below it.
    expect(find.text('Number kubb, first to 25'), findsOneWidget);

    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Jasper'), findsOneWidget);
    expect(find.text('Freya'), findsOneWidget);
    expect(find.text('Needs exactly 25'), findsOneWidget);
  });

  testWidgets('names are optional: unnamed players get numbers and stay '
      'out of the recents', (tester) async {
    await pumpToSetup(tester);
    await tester.tapVisible(find.text('Add player'));
    await tester.pumpAndSettle();
    await tester.tapVisible(find.text('Add player'));
    await tester.pumpAndSettle();
    expect(find.text('Player 1'), findsOneWidget);
    expect(find.text('Player 2'), findsOneWidget);
    expect(find.text('2 players'), findsWidgets); // header and summary bar

    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(key: UniqueKey(), child: const IKubbApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('I know the rules, start scoring'));
    await tester.pumpAndSettle();
    expect(find.text('Recent'), findsNothing);
  });

  testWidgets('team mode plays as two sides with custom names', (tester) async {
    await pumpToSetup(tester);
    await addPlayers(tester, ['Jasper', 'Freya', 'Erik', 'Saga']);

    // Enable teams; default alternating assignment covers both teams.
    await toggleTeams(tester);
    expect(find.text('Team A'), findsWidgets); // pills + team card hint
    await tester.enterText(find.widgetWithText(TextField, 'Team A'), 'Ravens');
    await tester.pumpAndSettle();
    expect(find.text('Number kubb, first to 50, in teams'), findsOneWidget);

    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Ravens'), findsOneWidget); // custom team A name
    expect(find.text('Team B'), findsOneWidget); // default team B name
    expect(find.text('Jasper'), findsNothing); // sides are teams, not players
  });

  testWidgets('a team pill moves a player; swap flips both teams', (
    tester,
  ) async {
    await pumpToSetup(tester);
    await addPlayers(tester, ['Jasper', 'Freya']);
    await toggleTeams(tester);
    // Alternating: Jasper A, Freya B. Move Freya to A → B is empty.
    await tester.tapVisible(find.bySemanticsLabel('Move Freya to Team A'));
    await tester.pumpAndSettle();
    expect(find.text('Both teams need a player'), findsOneWidget);
    await tester.tapVisible(find.text('Swap teams'));
    await tester.pumpAndSettle();
    expect(find.text('Both teams need a player'), findsOneWidget);
    await tester.tapVisible(find.bySemanticsLabel('Move Freya to Team A'));
    await tester.pumpAndSettle();
    expect(find.text('Both teams need a player'), findsNothing);
  });

  testWidgets('players are remembered as recents for the next setup', (
    tester,
  ) async {
    await pumpToSetup(tester);
    await addPlayers(tester, ['Jasper', 'Freya']);
    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();

    // Relaunch the app: a fresh scope must offer the players as chips.
    await tester.pumpWidget(
      ProviderScope(key: UniqueKey(), child: const IKubbApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('I know the rules, start scoring'));
    await tester.pumpAndSettle();

    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('Jasper'), findsOneWidget);
    expect(find.text('Freya'), findsOneWidget);
    // Picking a chip adds the player and dims the chip.
    await tester.tap(find.text('Jasper'));
    await tester.pumpAndSettle();
    expect(find.text('Jasper'), findsNWidgets(2));
  });
}
