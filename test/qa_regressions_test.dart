import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/game_screen.dart';
import 'package:ikubb/features/game/win_overlay.dart';
import 'package:ikubb/features/kubb/kubb_screen.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:ikubb/features/stats/game_records_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

Future<void> pumpHome(
  WidgetTester tester, {
  Key? key,
  ActiveRecord? restored,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      key: key,
      overrides: [
        onboardingSeenProvider.overrideWithValue(true),
        restoredGameProvider.overrideWithValue(restored),
      ],
      child: const IKubbApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> addPlayers(WidgetTester tester, List<String> names) async {
  for (final name in names) {
    await tester.enterText(find.byType(TextField).first, name);
    await tester.tap(find.text('Add player'));
    await tester.pumpAndSettle();
  }
}

/// Anna vs Björn to 12; one throw on pin 12 wins.
Future<void> winAGame(WidgetTester tester) async {
  await pumpHome(tester);
  await tester.tap(find.text('New game'));
  await tester.pumpAndSettle();
  await addPlayers(tester, ['Anna', 'Björn']);
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
  expect(find.byType(WinOverlay), findsOneWidget);
}

/// QA regressions for the review round: resume/quick-start, the kubb turn
/// clock, corrupt storage, and destructive-action consistency.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('quick start after a finished game is a rematch, not the old '
      'win overlay', (tester) async {
    await winAGame(tester);

    // Relaunch with the saved game restored (as main() does): a finished
    // game opens on Home with Quick start.
    final restored = await GameRecordsRepository().loadActive();
    expect(restored?.molkky?.isFinished, isTrue);
    await pumpHome(tester, key: UniqueKey(), restored: restored);
    expect(find.text('Quick start'), findsOneWidget);
    await tester.tap(find.text('Quick start'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.byType(WinOverlay), findsNothing);
    // Same players, fresh scores.
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('Björn'), findsOneWidget);
    expect(find.text('Needs exactly 12'), findsOneWidget);
  });

  testWidgets('quick start names the default players in the app language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'locale_override_v1': 'nl'});
    await pumpHome(tester);
    await tester.tap(find.text('Snel starten'));
    await tester.pumpAndSettle();
    expect(find.text('Speler 1'), findsOneWidget);
    expect(find.text('Speler 2'), findsOneWidget);
  });

  testWidgets('a stale language override that the app does not ship is '
      'ignored', (tester) async {
    SharedPreferences.setMockInitialValues({'locale_override_v1': 'xx'});
    await pumpHome(tester);
    expect(find.text('Quick start'), findsOneWidget);
  });

  testWidgets('the kubb turn clock counts down from the start of a turn', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kubb'));
    await tester.pumpAndSettle();
    await addPlayers(tester, ['Anna', 'Björn']);
    await tester.tapVisible(find.text('60s'));
    await tester.pumpAndSettle();
    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();
    expect(find.byType(KubbScreen), findsOneWidget);
    expect(find.text('60'), findsOneWidget);

    // No baton thrown yet — the clock must still run.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(find.text('57'), findsOneWidget);

    // A throw mid-turn does not restart the countdown...
    await tester.tap(find.text('Miss'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('56'), findsOneWidget);

    // ...the next turn does.
    for (var b = 0; b < 5; b++) {
      await tester.tap(find.text('Miss'));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('60'), findsOneWidget);
  });

  testWidgets('a corrupt recent-players record does not break setup', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'recent_players_v1': '{not json'});
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    expect(find.text('Add player'), findsOneWidget);
    expect(find.text('Recent players'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('setup with players meets tap-target and label guidelines', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await addPlayers(tester, ['Anna', 'Björn']);
    await tester.tapVisible(find.text('Teams'));
    await tester.pumpAndSettle();
    final handle = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    // The remove button names its player.
    expect(find.byTooltip('Remove Anna'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('swiping a history entry away asks for confirmation first', (
    tester,
  ) async {
    await winAGame(tester);
    await pumpHome(tester, key: UniqueKey());
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Anna 12'), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Delete game'), findsWidgets);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Anna 12'), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(-600, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Anna 12'), findsNothing);
  });

  testWidgets('the kubb overflow and overlay say "New match", not "New game"', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kubb'));
    await tester.pumpAndSettle();
    await addPlayers(tester, ['Anna', 'Björn']);
    await tester.tapVisible(find.text('Start game'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    expect(find.text('New match'), findsOneWidget);
    expect(find.text('New game'), findsNothing);
  });
}
