import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpToGame(WidgetTester tester) async {
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
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('rules panel opens in-game with categories and active rules',
      (tester) async {
    await pumpToGame(tester);

    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    // Categorized rows, collapsed by default (progressive disclosure).
    expect(find.text('Setup & field'), findsOneWidget);
    expect(find.text('Overshoot & reset'), findsOneWidget);
    expect(find.text('The formation'), findsNothing);

    // Active house rules of the current game shown inline.
    expect(find.text('Target score: 50'), findsOneWidget);

    // Expanding a category reveals its rule cards.
    await tester.tap(find.text('Setup & field'));
    await tester.pumpAndSettle();
    expect(find.text('The formation'), findsOneWidget);
  });

  testWidgets('search flattens to matching rule cards', (tester) async {
    await pumpToGame(tester);
    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'leaning');
    await tester.pumpAndSettle();

    expect(find.text("Leaning pins don't count"), findsOneWidget);
    expect(find.text('Setup & field'), findsNothing);
  });

  testWidgets('miss dots deep-link to the elimination rule', (tester) async {
    await pumpToGame(tester);

    // Tap the miss-streak dots on the active player card.
    await tester.tap(find.byIcon(Icons.circle).first, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Panel opens with the misses category already expanded.
    expect(find.text("Three misses and you're out"), findsOneWidget);
  });
}
