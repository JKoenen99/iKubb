import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ikubb/features/feedback/feedback_event.dart';
import 'package:ikubb/features/feedback/feedback_repository.dart';
import 'package:ikubb/features/feedback/feedback_scheduler.dart';
import 'package:ikubb/features/feedback/feedback_sink.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The prompt rules, the document shape, and the Supabase sink — all
/// without UI.
void main() {
  final t0 = DateTime.utc(2026, 10, 19, 20);

  group('scheduler: game end', () {
    bool ask(FeedbackPromptState state, int games, [DateTime? now]) =>
        FeedbackScheduler.shouldPrompt(
          FeedbackTrigger.gameEnd,
          state: state,
          finishedGames: games,
          now: now ?? t0,
        );

    test('waits for the second finished game', () {
      expect(ask(const FeedbackPromptState(), 1), isFalse);
      expect(ask(const FeedbackPromptState(), 2), isTrue);
    });

    test('never asks twice in one evening', () {
      final asked = FeedbackPromptState(lastPromptAt: t0, gamesAtLastPrompt: 2);
      expect(ask(asked, 14, t0.add(const Duration(hours: 3))), isFalse);
    });

    test('after a dismissal: 10 games or 30 days, whichever first', () {
      final dismissed = FeedbackPromptState(
        lastPromptAt: t0,
        gamesAtLastPrompt: 2,
      );
      expect(ask(dismissed, 11, t0.add(const Duration(days: 1))), isFalse);
      expect(ask(dismissed, 12, t0.add(const Duration(days: 1))), isTrue);
      expect(ask(dismissed, 3, t0.add(const Duration(days: 31))), isTrue);
    });

    test('after a submission: 20 games AND 30 days', () {
      final submitted = FeedbackPromptState(
        lastPromptAt: t0,
        lastSubmittedAt: t0,
        gamesAtLastPrompt: 2,
      );
      expect(ask(submitted, 30, t0.add(const Duration(days: 10))), isFalse);
      expect(ask(submitted, 10, t0.add(const Duration(days: 60))), isFalse);
      expect(ask(submitted, 22, t0.add(const Duration(days: 31))), isTrue);
    });

    test('"don\'t ask again" wins over everything', () {
      expect(ask(const FeedbackPromptState(optedOut: true), 100), isFalse);
    });
  });

  test('scheduler: tour asks once, settings always', () {
    expect(
      FeedbackScheduler.shouldPrompt(
        FeedbackTrigger.tourEnd,
        state: const FeedbackPromptState(),
        finishedGames: 0,
        now: t0,
      ),
      isTrue,
    );
    expect(
      FeedbackScheduler.shouldPrompt(
        FeedbackTrigger.tourEnd,
        state: const FeedbackPromptState(tourAsked: true),
        finishedGames: 0,
        now: t0,
      ),
      isFalse,
    );
    expect(
      FeedbackScheduler.shouldPrompt(
        FeedbackTrigger.settings,
        state: const FeedbackPromptState(optedOut: true),
        finishedGames: 0,
        now: t0,
      ),
      isTrue,
    );
  });

  test('store review only for 4+ stars and at most once a quarter', () {
    expect(
      FeedbackScheduler.shouldRequestStoreReview(
        3,
        state: const FeedbackPromptState(),
        now: t0,
      ),
      isFalse,
    );
    expect(
      FeedbackScheduler.shouldRequestStoreReview(
        5,
        state: const FeedbackPromptState(),
        now: t0,
      ),
      isTrue,
    );
    expect(
      FeedbackScheduler.shouldRequestStoreReview(
        5,
        state: FeedbackPromptState(
          lastStoreReviewAt: t0.subtract(const Duration(days: 30)),
        ),
        now: t0,
      ),
      isFalse,
    );
  });

  group('event document', () {
    final event = FeedbackEvent(
      eventId: '11111111-2222-4333-8444-555555555555',
      installId: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee',
      occurredAt: t0,
      trigger: FeedbackTrigger.gameEnd,
      response: FeedbackResponse.submitted,
      rating: 4,
      tags: const ['easy_scoring', 'other'],
      comment: 'Lekker snel',
      locale: 'nl-NL',
      appVersion: '0.1.0',
      buildNumber: '1',
      platform: 'ios',
      osVersion: 'Version 26.0',
      context: const {'mode': 'number_kubb', 'sides': 2},
    );

    test('is flat, snake_case, UTC, and round-trips', () {
      final json = event.toJson();
      expect(json['schema_version'], 1);
      expect(json['trigger'], 'game_end');
      expect(json['occurred_at'], '2026-10-19T20:00:00.000Z');
      expect(json['tags'], ['easy_scoring', 'other']);
      expect(json['context'], {'mode': 'number_kubb', 'sides': 2});
      final back = FeedbackEvent.fromJson(
        (jsonDecode(jsonEncode(json)) as Map).cast<String, Object?>(),
      );
      expect(back.toJson(), json);
    });

    test('uuids are v4 and unique', () {
      final a = FeedbackRepository.newUuid();
      final b = FeedbackRepository.newUuid();
      expect(a, isNot(b));
      expect(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ).hasMatch(a),
        isTrue,
      );
    });

    test('repository keeps an outbox and exports JSON Lines', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = FeedbackRepository();
      expect(await repo.installId(), await repo.installId());
      await repo.append(event);
      expect((await repo.unsynced()).single.eventId, event.eventId);
      await repo.markSynced([event.eventId]);
      expect(await repo.unsynced(), isEmpty);
      final lines = (await repo.exportJsonLines()).split('\n');
      expect(lines, hasLength(1));
      expect(jsonDecode(lines.first)['event_id'], event.eventId);
    });

    test('Supabase sink posts rows with the full payload', () async {
      late http.Request seen;
      final sink = SupabaseFeedbackSink(
        projectUrl: 'https://xyz.supabase.co',
        anonKey: 'anon',
        client: MockClient((request) async {
          seen = request;
          return http.Response('', 201);
        }),
      );
      expect(await sink.send([event]), isTrue);
      expect(
        seen.url.toString(),
        'https://xyz.supabase.co/rest/v1/feedback_events',
      );
      expect(seen.headers['apikey'], 'anon');
      expect(seen.headers['Prefer'], contains('ignore-duplicates'));
      final rows = jsonDecode(seen.body) as List;
      expect(rows.single['event_id'], event.eventId);
      expect(rows.single['rating'], 4);
      expect(rows.single['payload']['context']['mode'], 'number_kubb');
    });

    test('Supabase sink reports failure instead of throwing', () async {
      final sink = SupabaseFeedbackSink(
        projectUrl: 'https://xyz.supabase.co',
        anonKey: 'anon',
        client: MockClient((_) async => throw Exception('offline')),
      );
      expect(await sink.send([event]), isFalse);
      final denied = SupabaseFeedbackSink(
        projectUrl: 'https://xyz.supabase.co',
        anonKey: 'anon',
        client: MockClient((_) async => http.Response('nope', 401)),
      );
      expect(await denied.send([event]), isFalse);
    });

    test('without dart-defines the sink is a no-op', () {
      expect(SupabaseFeedbackSink.fromEnvironment(), isA<NoopFeedbackSink>());
    });
  });
}
