import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/kubb/kubb_field.dart';
import 'package:ikubb/features/kubb/kubb_screen.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpToKubb(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [onboardingSeenProvider.overrideWithValue(true)],
      child: const IKubbApp(),
    ),
  );
  await tester.pumpAndSettle();
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
  expect(find.byType(KubbScreen), findsOneWidget);
}

Finder blocksIn(String rowKey) => find.descendant(
  of: find.byKey(Key(rowKey)),
  matching: find.byType(KubbBlock),
);

Future<void> miss(WidgetTester tester, int batons) async {
  for (var b = 0; b < batons; b++) {
    await tester.tap(find.text('Miss'));
    await tester.pumpAndSettle();
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('a full kubb game: fell the line, clear nothing, take the king', (
    tester,
  ) async {
    await pumpToKubb(tester);

    // Team A fells all five of Team B's baseline kubbs with one baton
    // selection each? One baton can fell several: select all 5, confirm.
    for (final block in blocksIn('baselineRow').evaluate().toList()) {
      await tester.tap(find.byWidget(block.widget));
      await tester.pump();
    }
    await tester.tap(find.text('Confirm throw (+5)'));
    await tester.pumpAndSettle();

    // The throw-in only starts once all six batons are thrown.
    await miss(tester, 5);

    // Throw-in phase: no penalties.
    expect(find.text('Out of bounds twice'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Team B misses their whole turn (field kubbs stay standing).
    await miss(tester, 6);

    // Team A now has the advantage line and a free king.
    expect(find.text('Advantage line'), findsOneWidget);
    await tester.tap(find.byType(KubbKing));
    await tester.pumpAndSettle();

    expect(find.text('Anna wins!'), findsNothing); // teams, not players
    expect(find.text('Team A wins!'), findsOneWidget);
    expect(find.text('Rematch'), findsOneWidget);
  });

  testWidgets('toppling the king too early warns, then loses the game', (
    tester,
  ) async {
    await pumpToKubb(tester);

    await tester.tap(find.byType(KubbKing));
    await tester.pumpAndSettle();
    expect(find.text('Topple the king?'), findsOneWidget);

    // Cancel keeps playing.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(KubbScreen), findsOneWidget);

    // Confirming loses on the spot: Team B takes the game and match.
    await tester.tap(find.byType(KubbKing));
    await tester.pumpAndSettle();
    await tester.tap(find.text('King'));
    await tester.pumpAndSettle();
    expect(find.text('Team B wins!'), findsOneWidget);
  });

  testWidgets('the rules panel opens on kubb rules and can switch modes', (
    tester,
  ) async {
    await pumpToKubb(tester);

    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    // Kubb categories with the active match rules as chips.
    expect(find.text('Field kubbs'), findsOneWidget);
    expect(find.text('Single game'), findsOneWidget);

    // One tap switches the reference to the other game.
    await tester.tap(find.text('Number kubb'));
    await tester.pumpAndSettle();
    expect(find.text('Scoring'), findsOneWidget);
    expect(find.text('Field kubbs'), findsNothing);
  });

  testWidgets('the scoreboard shows kubbs remaining for a kubb match', (
    tester,
  ) async {
    await pumpToKubb(tester);

    // Fell one baseline kubb so the two counters differ.
    await tester.tap(blocksIn('baselineRow').first);
    await tester.pump();
    await tester.tap(find.text('Confirm throw (+1)'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scoreboard'));
    await tester.pumpAndSettle();

    // Kubbs remaining, not scores: 5 for Team A, 4 for Team B.
    expect(find.text('Team A'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);

    // Tap anywhere returns to the game.
    await tester.tap(find.text('Team A'));
    await tester.pumpAndSettle();
    expect(find.byType(KubbScreen), findsOneWidget);
  });

  testWidgets('a running kubb match resumes from Home as the primary action', (
    tester,
  ) async {
    await pumpToKubb(tester);

    // One baton fells one baseline kubb; miss the rest of the turn and
    // complete the throw-in.
    await tester.tap(blocksIn('baselineRow').first);
    await tester.pump();
    await tester.tap(find.text('Confirm throw (+1)'));
    await tester.pumpAndSettle();
    await miss(tester, 5);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('Resume game'), findsOneWidget);
    expect(find.textContaining('Team B 4'), findsOneWidget);

    await tester.tap(find.textContaining('Resume game'));
    await tester.pumpAndSettle();
    expect(find.byType(KubbScreen), findsOneWidget);
  });
}
