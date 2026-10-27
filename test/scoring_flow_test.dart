import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaato/app.dart';
import 'package:kaato/features/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('set up and score a pin-tap throw end to end', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: KaatoApp()));
    await tester.pumpAndSettle();

    // Onboarding fork → straight to scoring for experienced players.
    expect(find.text('I know the rules, start scoring'), findsOneWidget);
    await tester.tap(find.text('I know the rules, start scoring'));
    await tester.pumpAndSettle();

    // Set up a classic 2-player game.
    await addPlayers(tester, ['Player 1', 'Player 2']);
    await tester.tap(find.text('Start game'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);

    // Player 1 needs exactly 50; knock over pin 12 and confirm.
    expect(find.text('Needs exactly 50'), findsOneWidget);
    await tester.tap(find.text('12'));
    await tester.pump();
    await tester.tap(find.text('Confirm throw (+12)'));
    await tester.pumpAndSettle();

    // Score updated and turn passed to Player 2.
    expect(find.text('12'), findsWidgets); // pin 12 and the score card
    expect(find.text('Needs exactly 50'), findsOneWidget); // now Player 2's
  });
}
