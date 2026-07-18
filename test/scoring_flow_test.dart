import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/game_screen.dart';

void main() {
  testWidgets('quick start scores a pin-tap throw end to end', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
    await tester.pumpAndSettle();

    // Onboarding fork → straight to scoring for experienced players.
    expect(find.text('I know the rules — start scoring'), findsOneWidget);
    await tester.tap(find.text('I know the rules — start scoring'));
    await tester.pumpAndSettle();

    // Setup placeholder → quick start.
    await tester.tap(find.text('Quick start'));
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
