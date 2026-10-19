import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/app.dart';
import 'package:ikubb/features/feedback/feedback_controller.dart';
import 'package:ikubb/features/feedback/feedback_event.dart';
import 'package:ikubb/features/feedback/feedback_prompt.dart';
import 'package:ikubb/features/feedback/feedback_repository.dart';
import 'package:ikubb/features/feedback/feedback_sink.dart';
import 'package:ikubb/features/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

/// Records what the sink and the store-review gateway were asked to do.
class RecordingSink implements FeedbackSink {
  final sent = <FeedbackEvent>[];
  bool accept = true;

  @override
  Future<bool> send(List<FeedbackEvent> events) async {
    if (accept) sent.addAll(events);
    return accept;
  }
}

class RecordingStoreReview implements StoreReviewGateway {
  int requests = 0;

  @override
  Future<void> request() async => requests++;
}

Future<void> pumpApp(
  WidgetTester tester, {
  required RecordingSink sink,
  required RecordingStoreReview review,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        onboardingSeenProvider.overrideWithValue(true),
        feedbackSinkProvider.overrideWithValue(sink),
        storeReviewProvider.overrideWithValue(review),
      ],
      child: const IKubbApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Anna vs Björn to 12: one throw on pin 12 wins each game.
Future<void> setUpGameTo12(WidgetTester tester) async {
  await tester.tap(find.text('New game'));
  await tester.pumpAndSettle();
  await addPlayers(tester, ['Anna', 'Björn']);
  await setTarget(tester, 12);
  await tester.tapVisible(find.text('Start game'));
  await tester.pumpAndSettle();
}

Future<void> winWithPin12(WidgetTester tester) async {
  await tester.tap(find.text('12'));
  await tester.pump();
  await tester.tap(find.textContaining('Confirm throw'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the game-end ask waits for the second win, then records a '
      'full event and hands a 5-star rating to the store prompt', (
    tester,
  ) async {
    final sink = RecordingSink();
    final review = RecordingStoreReview();
    await pumpApp(tester, sink: sink, review: review);
    await setUpGameTo12(tester);

    // First win: too early to ask.
    await winWithPin12(tester);
    expect(find.text('Anna wins!'), findsOneWidget);
    expect(find.text('How was scoring with iKubb?'), findsNothing);

    // Rematch and win again: now the card is there, under the actions.
    await tester.tap(find.text('Rematch'));
    await tester.pumpAndSettle();
    await winWithPin12(tester);
    await tester.pumpAndSettle();
    expect(find.text('How was scoring with iKubb?'), findsOneWidget);

    // Five stars opens the form with the positive pills.
    await tester.tapVisible(find.byTooltip('5 of 5 stars'));
    await tester.pumpAndSettle();
    expect(find.text('What worked well?'), findsOneWidget);
    expect(find.text('Easy scoring'), findsOneWidget);
    expect(find.text('Confusing'), findsNothing);

    await tester.tap(find.text('Easy scoring'));
    await tester.tap(find.text('Looks great'));
    await tester.enterText(find.byType(TextField).last, '  Super snel!  ');
    await tester.tapVisible(find.text('Send feedback'));
    await tester.pumpAndSettle();

    // Thanks, store prompt, and one well-formed document in the sink.
    expect(find.text('Thanks, that helps us improve!'), findsWidgets);
    expect(review.requests, 1);
    final event = sink.sent.single;
    expect(event.trigger, FeedbackTrigger.gameEnd);
    expect(event.response, FeedbackResponse.submitted);
    expect(event.rating, 5);
    expect(event.tags, ['easy_scoring', 'looks_great']);
    expect(event.comment, 'Super snel!');
    expect(event.locale, 'en');
    expect(event.storeReviewRequested, isTrue);
    expect(event.context['mode'], 'number_kubb');
    expect(event.context['sides'], 2);
    expect(event.context['target_score'], 12);
    expect(event.installId, await FeedbackRepository().installId());

    // Answered: a third win in the same evening does not ask again.
    await tester.tap(find.text('Rematch'));
    await tester.pumpAndSettle();
    await winWithPin12(tester);
    await tester.pumpAndSettle();
    expect(find.text('How was scoring with iKubb?'), findsNothing);
  });

  testWidgets('a low rating asks what to improve and skips the store', (
    tester,
  ) async {
    final sink = RecordingSink();
    final review = RecordingStoreReview();
    await pumpApp(tester, sink: sink, review: review);
    await setUpGameTo12(tester);
    await winWithPin12(tester);
    await tester.tap(find.text('Rematch'));
    await tester.pumpAndSettle();
    await winWithPin12(tester);
    await tester.pumpAndSettle();

    await tester.tapVisible(find.byTooltip('2 of 5 stars'));
    await tester.pumpAndSettle();
    expect(find.text('What could be better?'), findsOneWidget);
    await tester.tap(find.text('Too many taps'));
    await tester.tapVisible(find.text('Send feedback'));
    await tester.pumpAndSettle();

    expect(review.requests, 0);
    expect(sink.sent.single.rating, 2);
    expect(sink.sent.single.tags, ['too_many_taps']);
    expect(sink.sent.single.storeReviewRequested, isFalse);
  });

  testWidgets('"Not now" is recorded as a dismissal and the outbox keeps '
      'events the sink refuses', (tester) async {
    final sink = RecordingSink()..accept = false;
    await pumpApp(tester, sink: sink, review: RecordingStoreReview());
    await setUpGameTo12(tester);
    await winWithPin12(tester);
    await tester.tap(find.text('Rematch'));
    await tester.pumpAndSettle();
    await winWithPin12(tester);
    await tester.pumpAndSettle();

    await tester.tapVisible(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(find.byType(FeedbackPromptCard), findsOneWidget);
    expect(find.text('How was scoring with iKubb?'), findsNothing);

    final pending = await FeedbackRepository().unsynced();
    expect(pending.single.response, FeedbackResponse.dismissed);
    expect(pending.single.rating, isNull);
  });

  testWidgets('settings always offers the form; the tour asks once', (
    tester,
  ) async {
    final sink = RecordingSink();
    await pumpApp(tester, sink: sink, review: RecordingStoreReview());

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    // Settings is a lazy ListView: scroll the row into existence first.
    await tester.scrollUntilVisible(
      find.text('Give feedback'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tapVisible(find.text('Give feedback'));
    await tester.pumpAndSettle();
    expect(find.text('Your feedback'), findsOneWidget);
    await tester.tap(find.byTooltip('4 of 5 stars'));
    await tester.pumpAndSettle();
    await tester.tapVisible(find.text('Send feedback'));
    await tester.pumpAndSettle();
    expect(sink.sent.single.trigger, FeedbackTrigger.settings);
    // Let the thank-you snackbar go, or it covers the tour's Next button.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // The tour's last card carries the one-time ask.
    await tester.scrollUntilVisible(
      find.text('Teach me the game'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Teach me the game'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Did the tour explain the game?'), findsOneWidget);
  });
}
