import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension TapVisible on WidgetTester {
  /// Scrolls [finder] into view before tapping — the setup screen's list
  /// grew past the default test viewport when the mode picker landed.
  Future<void> tapVisible(Finder finder) async {
    expect(finder, findsOneWidget); // names the finder when it is missing
    await ensureVisible(finder);
    await pumpAndSettle();
    await tap(finder);
  }
}

/// Adds players on the setup screen: "Add player" creates a numbered
/// player, then the new row's name is tapped and replaced inline.
Future<void> addPlayers(WidgetTester tester, List<String> names) async {
  for (final name in names) {
    await tester.tapVisible(find.text('Add player'));
    await tester.pumpAndSettle();
    // The new row is the only auto-named one left (earlier rows were
    // renamed). The team cards (kubb or team mode) repeat the name as a
    // member further down the tree, so the first match is the row.
    final auto = find.textContaining(RegExp(r'^Player \d+$')).first;
    final autoName = (tester.widget(auto) as Text).data!;
    await tester.tapVisible(auto);
    await tester.pumpAndSettle();
    // The row's field is prefilled with the generated name; team-name
    // fields (kubb mode) are empty, so this never hits those.
    await tester.enterText(
      find.byWidgetPredicate(
        (w) => w is TextField && w.controller?.text == autoName,
      ),
      name,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }
}

/// Types a target score into the stepper's value dialog (the stepper's
/// own buttons move in fives).
Future<void> setTarget(WidgetTester tester, int target) async {
  await tester.tapVisible(find.text('50'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).last, '$target');
  await tester.tap(find.text('Done'));
  await tester.pumpAndSettle();
}

/// Flips the Teams switch on the setup screen.
Future<void> toggleTeams(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(Switch).first);
  await tester.pumpAndSettle();
  await tester.tap(find.byType(Switch).first);
  await tester.pumpAndSettle();
}
