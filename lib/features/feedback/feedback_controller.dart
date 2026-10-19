import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../stats/game_records_repository.dart';
import 'device_info.dart';
import 'feedback_event.dart';
import 'feedback_repository.dart';
import 'feedback_scheduler.dart';
import 'feedback_sink.dart';

final feedbackRepositoryProvider = Provider<FeedbackRepository>(
  (ref) => FeedbackRepository(),
);

/// The configured backend; tests override this with a recording fake.
final feedbackSinkProvider = Provider<FeedbackSink>(
  (ref) => SupabaseFeedbackSink.fromEnvironment(),
);

/// The native store-review prompt behind an interface, so tests can
/// record the request instead of hitting the platform channel.
abstract class StoreReviewGateway {
  Future<void> request();
}

class InAppReviewGateway implements StoreReviewGateway {
  const InAppReviewGateway();

  @override
  Future<void> request() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) await review.requestReview();
  }
}

final storeReviewProvider = Provider<StoreReviewGateway>(
  (ref) => const InAppReviewGateway(),
);

/// What the prompt UI needs to decide whether to show: the persisted
/// prompt state and the finished-game count. Loaded once per app run and
/// updated in place after every prompt so the same evening never asks
/// twice.
class FeedbackController extends AsyncNotifier<FeedbackPromptState> {
  @override
  Future<FeedbackPromptState> build() async {
    final state = await ref.read(feedbackRepositoryProvider).loadState();
    // The app version is read once, in the background: a feedback event
    // must never wait on a platform channel (nor hang in tests).
    _packageInfo().ignore();
    // Anything the sink did not accept last time gets another try now.
    flushOutbox().ignore();
    return state;
  }

  /// Whether a prompt may be shown now for [trigger]. Synchronous on
  /// purpose: it runs inside build methods. Before the state has loaded
  /// the answer is no — a missed prompt beats a duplicate one.
  bool shouldPrompt(FeedbackTrigger trigger, {required int finishedGames}) {
    final s = state.value;
    if (s == null) return false;
    return FeedbackScheduler.shouldPrompt(
      trigger,
      state: s,
      finishedGames: finishedGames,
      now: DateTime.now(),
    );
  }

  /// Records that a prompt was shown (before the player reacts), so a
  /// dismissal by closing the app still counts as asked.
  Future<void> markPrompted(
    FeedbackTrigger trigger, {
    required int finishedGames,
  }) async {
    final current = state.value ?? const FeedbackPromptState();
    final next = current.copyWith(
      lastPromptAt: trigger == FeedbackTrigger.settings
          ? current.lastPromptAt
          : DateTime.now(),
      gamesAtLastPrompt: trigger == FeedbackTrigger.gameEnd
          ? finishedGames
          : current.gamesAtLastPrompt,
      tourAsked: trigger == FeedbackTrigger.tourEnd || current.tourAsked,
    );
    state = AsyncData(next);
    await ref.read(feedbackRepositoryProvider).saveState(next);
  }

  Future<void> optOut() async {
    final next = (state.value ?? const FeedbackPromptState()).copyWith(
      optedOut: true,
    );
    state = AsyncData(next);
    await ref.read(feedbackRepositoryProvider).saveState(next);
  }

  /// Stores an event locally, then tries the sink. Returns whether the
  /// native store-review prompt should follow (positive rating, not
  /// asked this quarter).
  Future<bool> record({
    required FeedbackTrigger trigger,
    required FeedbackResponse response,
    required Locale locale,
    int? rating,
    List<String> tags = const [],
    String? comment,
    Map<String, Object?> context = const {},
  }) async {
    final repo = ref.read(feedbackRepositoryProvider);
    final info = _info; // prefetched at launch; empty strings if not yet
    final trimmed = comment?.trim();
    final current = state.value ?? const FeedbackPromptState();
    final now = DateTime.now();
    final wantsStoreReview =
        response == FeedbackResponse.submitted &&
        FeedbackScheduler.shouldRequestStoreReview(
          rating,
          state: current,
          now: now,
        );
    final event = FeedbackEvent(
      eventId: FeedbackRepository.newUuid(),
      installId: await repo.installId(),
      occurredAt: now,
      trigger: trigger,
      response: response,
      rating: rating,
      tags: tags,
      comment: trimmed == null || trimmed.isEmpty
          ? null
          : trimmed.length > FeedbackEvent.maxCommentLength
          ? trimmed.substring(0, FeedbackEvent.maxCommentLength)
          : trimmed,
      locale: locale.toLanguageTag(),
      appVersion: info?.version ?? '',
      buildNumber: info?.buildNumber ?? '',
      platform: DeviceInfo.platform(),
      osVersion: DeviceInfo.osVersion(),
      storeReviewRequested: wantsStoreReview,
      context: context,
    );
    await repo.append(event);
    if (response == FeedbackResponse.submitted) {
      final next = current.copyWith(
        lastSubmittedAt: now,
        lastStoreReviewAt: wantsStoreReview ? now : current.lastStoreReviewAt,
      );
      state = AsyncData(next);
      await repo.saveState(next);
    }
    await flushOutbox();
    return wantsStoreReview;
  }

  /// Hands the system the review request. It decides whether to show
  /// anything; we never see the result. Best-effort everywhere.
  Future<void> requestStoreReview() async {
    try {
      await ref.read(storeReviewProvider).request();
    } on Object {
      // Not available on this platform/build; nothing to do.
    }
  }

  /// Sends everything the sink has not accepted yet. Safe to call often:
  /// at startup, after a submission, when connectivity returns.
  Future<void> flushOutbox() async {
    final repo = ref.read(feedbackRepositoryProvider);
    final pending = await repo.unsynced();
    if (pending.isEmpty) return;
    if (await ref.read(feedbackSinkProvider).send(pending)) {
      await repo.markSynced(pending.map((e) => e.eventId));
    }
  }

  PackageInfo? _info;
  Future<void> _packageInfo() async {
    try {
      _info ??= await PackageInfo.fromPlatform();
    } on Object {
      // Tests and exotic platforms: version fields stay empty.
    }
  }
}

final feedbackControllerProvider =
    AsyncNotifierProvider<FeedbackController, FeedbackPromptState>(
      FeedbackController.new,
    );

/// Finished games on this device, for the eligibility rules: seeded from
/// the stored history at launch, then bumped synchronously by the game
/// controllers the moment a game is won — so the win overlay never races
/// the asynchronous history write. Null until the seed has loaded.
class FinishedGameCounter extends Notifier<int?> {
  final Set<String> _counted = {};

  @override
  int? build() {
    ref.read(gameRecordsRepositoryProvider).loadHistory().then((history) {
      state = (state ?? 0) + history.length;
    }).ignore();
    return null;
  }

  /// Counts [gameId] once, however often its win is undone and redone.
  void markFinished(String gameId) {
    if (!_counted.add(gameId)) return;
    state = (state ?? 0) + 1;
  }
}

final finishedGameCountProvider = NotifierProvider<FinishedGameCounter, int?>(
  FinishedGameCounter.new,
);
