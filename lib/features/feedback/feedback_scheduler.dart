import 'feedback_event.dart';
import 'feedback_repository.dart';

/// Pure eligibility rules: when the app may ask, so prompts stay rare,
/// well-timed, and never nag. Everything is a function of the prompt
/// state and the clock, so the rules are unit-testable without UI.
///
/// Principles:
/// - Ask after a *complete* experience, never before a player has one:
///   the game-end prompt waits for the second finished game.
/// - Someone who answered is left alone far longer than someone who
///   waved the card away.
/// - Never twice in one evening, and never again after "Don't ask again".
/// - The tour prompt fires once in a lifetime, on the first completion.
/// - Settings is always open; it is the player's own initiative.
abstract final class FeedbackScheduler {
  /// Finished games before the first game-end prompt.
  static const int minGamesBeforeFirstPrompt = 2;

  /// After a dismissal: wait this many games or this long, whichever
  /// comes first.
  static const int gamesBetweenPrompts = 10;
  static const Duration timeBetweenPrompts = Duration(days: 30);

  /// After a submission: both thresholds must pass.
  static const int gamesAfterSubmission = 20;
  static const Duration timeAfterSubmission = Duration(days: 30);

  /// Never twice in one session, however many games are played.
  static const Duration sameEveningGap = Duration(hours: 12);

  /// Apple allows ~3 store prompts a year; we ask at most once a quarter.
  static const Duration storeReviewGap = Duration(days: 90);

  static bool shouldPrompt(
    FeedbackTrigger trigger, {
    required FeedbackPromptState state,
    required int finishedGames,
    required DateTime now,
  }) {
    switch (trigger) {
      case FeedbackTrigger.settings:
        return true;
      case FeedbackTrigger.tourEnd:
        return !state.optedOut && !state.tourAsked;
      case FeedbackTrigger.gameEnd:
        if (state.optedOut) return false;
        if (finishedGames < minGamesBeforeFirstPrompt) return false;
        final last = state.lastPromptAt;
        if (last == null) return true;
        if (now.difference(last) < sameEveningGap) return false;
        final gamesSince = finishedGames - state.gamesAtLastPrompt;
        final submittedLast =
            state.lastSubmittedAt != null &&
            !state.lastSubmittedAt!.isBefore(last);
        if (submittedLast) {
          return gamesSince >= gamesAfterSubmission &&
              now.difference(last) >= timeAfterSubmission;
        }
        return gamesSince >= gamesBetweenPrompts ||
            now.difference(last) >= timeBetweenPrompts;
    }
  }

  /// Positive ratings may go on to the native store prompt, rate-limited.
  static bool shouldRequestStoreReview(
    int? rating, {
    required FeedbackPromptState state,
    required DateTime now,
  }) {
    if (rating == null || rating < 4) return false;
    final last = state.lastStoreReviewAt;
    return last == null || now.difference(last) >= storeReviewGap;
  }
}
