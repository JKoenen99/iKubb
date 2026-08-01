import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/game/mascot_reaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('an overshoot triggers a brief, self-dismissing mascot wince', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I know the rules, start scoring'));
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

    // Anna 10, Björn 1, then Anna busts with a 3-pin throw (13 > 12).
    for (final pin in ['10']) {
      await tester.tap(find.text(pin));
      await tester.pump();
    }
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.textContaining('Confirm throw'));
    await tester.pumpAndSettle();
    for (final pin in ['2', '3', '4']) {
      await tester.tap(find.text(pin));
      await tester.pump();
    }
    // The confirm button itself warns before a bust — that's the label now.
    expect(find.textContaining('Overshoot'), findsOneWidget);
    await tester.tap(find.textContaining('Overshoot'));

    // The wince pops in immediately on the bust.
    await tester.pump();
    expect(find.byType(MascotReaction), findsOneWidget);

    // ...and disappears on its own once the animation completes.
    await tester.pumpAndSettle();
    expect(find.byType(MascotReaction), findsNothing);
  });
}
