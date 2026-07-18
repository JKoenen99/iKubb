import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpToTour(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: IKubbApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Teach me the game'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the tour teaches scoring interactively', (tester) async {
    await pumpToTour(tester);

    // Card 1: the formation, with the same pin diagram as the game.
    expect(find.text('The formation'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Card 2: interactive demo — the explanation reacts to what you tap.
    expect(find.text('Try it — tap the pins that fell'), findsOneWidget);
    await tester.tap(find.text('11'));
    await tester.pumpAndSettle();
    expect(find.textContaining('exactly one pin'), findsOneWidget);
    await tester.tap(find.text('4'));
    await tester.pumpAndSettle();
    expect(find.textContaining('number of pins'), findsOneWidget);
    expect(find.text('2'), findsWidgets); // two pins down scores 2

    // Remaining cards through to the finish.
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Hit the target exactly'), findsOneWidget);
    await tester.tap(find.text('I know the rules — start scoring'));
    await tester.pumpAndSettle();
    expect(find.text('Start game'), findsOneWidget); // landed in setup
  });

  testWidgets('skip is available on every card and exits to setup',
      (tester) async {
    await pumpToTour(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Start game'), findsOneWidget);
  });

  testWidgets('after onboarding was seen the app opens on Home',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [onboardingSeenProvider.overrideWithValue(true)],
      child: const IKubbApp(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Quick start'), findsOneWidget);
    expect(find.text('Teach me the game'), findsNothing);
  });
}
