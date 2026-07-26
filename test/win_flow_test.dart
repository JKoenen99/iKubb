import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/win_overlay.dart';
import 'package:ikubb/widgets/viking_mascot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

/// Sets up Anna vs Björn with a custom target of 12, so a single throw on
/// pin 12 wins the game.
Future<void> pumpToGameWithTarget12(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('I know the rules — start scoring'));
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
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('winning shows the personalized celebration', (tester) async {
    await pumpToGameWithTarget12(tester);

    await tester.tap(find.text('12'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();

    expect(find.byType(WinOverlay), findsOneWidget);
    expect(find.text('Anna wins!'), findsOneWidget);
    expect(find.byType(VikingMascot), findsOneWidget);
    // Final standings show both sides.
    expect(
      find.descendant(
        of: find.byType(WinOverlay),
        matching: find.text('Björn'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('celebration buttons are live on the very first frame', (
    tester,
  ) async {
    await pumpToGameWithTarget12(tester);
    await tester.tap(find.text('12'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));

    // A single frame — entry animation and confetti still mid-flight.
    await tester.pump();
    await tester.tap(find.text('Rematch'), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Fresh game with the same players and rules.
    expect(find.byType(WinOverlay), findsNothing);
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('Needs exactly 12'), findsOneWidget);
  });

  testWidgets('new game returns to setup', (tester) async {
    await pumpToGameWithTarget12(tester);
    await tester.tap(find.text('12'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('New game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    expect(find.text('Start game'), findsOneWidget);
  });
}
