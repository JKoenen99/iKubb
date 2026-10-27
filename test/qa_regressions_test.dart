import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaato/app.dart';
import 'package:kaato/features/game/game_screen.dart';
import 'package:kaato/features/game/win_overlay.dart';
import 'package:kaato/features/onboarding/onboarding_state.dart';
import 'package:kaato/features/stats/game_records_repository.dart';
import 'package:scoring_engine/scoring_engine.dart';
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
      child: const KaatoApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Anna vs Björn to 12; one throw on pin 12 wins.
Future<void> winAGame(WidgetTester tester) async {
  await pumpHome(tester);
  await tester.tap(find.text('New game'));
  await tester.pumpAndSettle();
  await addPlayers(tester, ['Anna', 'Björn']);
  await setTarget(tester, 12);
  await tester.tapVisible(find.text('Start game'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('12'));
  await tester.pump();
  await tester.tap(find.textContaining('Confirm throw'));
  await tester.pumpAndSettle();
  expect(find.byType(WinOverlay), findsOneWidget);
}

/// QA regressions for the review round: resume/quick-start, corrupt
/// storage, destructive-action consistency, and old two-mode records.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('quick start after a finished game is a rematch, not the old '
      'win overlay', (tester) async {
    await winAGame(tester);

    // Relaunch with the saved game restored (as main() does): a finished
    // game opens on Home with Quick start.
    final restored = await GameRecordsRepository().loadActive();
    expect(restored?.game.isFinished, isTrue);
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

  testWidgets('a corrupt recent-players record does not break setup', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'recent_players_v1': '{not json'});
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    expect(find.text('Add player'), findsOneWidget);
    expect(find.text('Recent'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('setup with players meets tap-target and label guidelines', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    await addPlayers(tester, ['Anna', 'Björn']);
    await toggleTeams(tester);
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

  test('records from the two-mode era load without the kubb matches', () async {
    final game = Game.start(
      sides: const [
        Side(id: 'a', name: 'Anna'),
        Side(id: 'b', name: 'Björn'),
      ],
    );
    SharedPreferences.setMockInitialValues({
      // Builds before 0.4.0 stored classic-kubb matches next to number
      // kubb games; the kubb payload is irrelevant, only its key matters.
      'game_history_v1': jsonEncode([
        {
          'id': 'kubb-1',
          'finishedAt': '2026-10-01T20:00:00.000',
          'kubbMatch': {'legacy': true},
        },
        {
          'id': 'number-1',
          'finishedAt': '2026-10-02T20:00:00.000',
          'game': game.toJson(),
        },
      ]),
      'active_game_v1': jsonEncode({
        'id': 'kubb-2',
        'kubbMatch': {'legacy': true},
        'sideColors': <String, int>{},
      }),
    });
    final repo = GameRecordsRepository();
    final history = await repo.loadHistory();
    expect(history.map((g) => g.id), ['number-1']);
    expect(await repo.loadActive(), isNull);
  });
}
