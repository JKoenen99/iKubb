import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/scoreboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpToGame(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('I know the rules, start scoring'));
  await tester.pumpAndSettle();
  for (final name in ['Anna', 'Björn']) {
    await tester.enterText(find.byType(TextField).first, name);
    await tester.tap(find.text('Add player'));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.text('Start game'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('number-pad mode scores a throw with one tap', (tester) async {
    await pumpToGame(tester);

    await tester.tap(find.text('Number pad'));
    await tester.pumpAndSettle();
    // Pad replaces the pin diagram: no confirm button anymore.
    expect(find.textContaining('Confirm throw'), findsNothing);

    await tester.tap(find.text('7'));
    await tester.pumpAndSettle();

    // Anna scored 7 in one tap; turn moved to Björn.
    expect(find.text('7'), findsWidgets); // score card and pad key
    expect(find.text('Needs exactly 50'), findsOneWidget); // Björn's turn

    // The preference persists into the next launch.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('input_mode_v1'), 'pad');
  });

  testWidgets('scoreboard mode shows big live scores and taps back', (
    tester,
  ) async {
    await pumpToGame(tester);
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scoreboard'));
    await tester.pumpAndSettle();

    expect(find.byType(ScoreboardScreen), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('5'), findsOneWidget); // her score, big

    await tester.tap(find.text('Anna')); // tap anywhere returns
    await tester.pumpAndSettle();
    expect(find.byType(ScoreboardScreen), findsNothing);
    expect(find.textContaining('Confirm throw'), findsOneWidget);
  });
}
