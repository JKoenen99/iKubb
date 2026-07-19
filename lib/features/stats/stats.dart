import 'package:scoring_engine/scoring_engine.dart';

import 'game_records_repository.dart';

/// Lifetime numbers for one player/side name, aggregated over the history.
/// Aggregation is by display name: profile ids stay stable for saved
/// players, but names are what people recognize across quick games too.
class PlayerStats {
  PlayerStats(this.name);

  final String name;
  int games = 0;
  int wins = 0;
  int throwCount = 0;
  int points = 0;
  int misses = 0;
  int overshoots = 0;
  int eliminations = 0;
  final Map<int, int> pinHits = {};

  double get winRate => games == 0 ? 0 : wins / games;

  double get avgPerThrow => throwCount == 0 ? 0 : points / throwCount;

  /// The most-hit pin, or null before any pin-tap throws.
  int? get favoritePin => pinHits.isEmpty
      ? null
      : pinHits.entries.reduce((a, b) => b.value > a.value ? b : a).key;
}

/// Computes per-player lifetime stats by replaying every stored game
/// through the engine — the stored throw log is the single source of truth.
Map<String, PlayerStats> aggregateStats(List<FinishedGame> history) {
  final byName = <String, PlayerStats>{};
  PlayerStats statsFor(String name) =>
      byName.putIfAbsent(name, () => PlayerStats(name));

  for (final finished in history) {
    final game = finished.game;
    for (final side in game.sides) {
      statsFor(side.name).games++;
    }
    if (game.winner != null) statsFor(game.winner!.name).wins++;
    for (final record in game.records) {
      final stats = statsFor(game.sides[record.sideIndex].name);
      stats.throwCount++;
      stats.points += record.thrown.score;
      if (record.thrown.isMiss) stats.misses++;
      if (record.outcome == ThrowOutcome.overshoot) stats.overshoots++;
      if (record.outcome == ThrowOutcome.eliminated) stats.eliminations++;
      for (final pin in record.thrown.pins ?? const <int>{}) {
        stats.pinHits.update(pin, (n) => n + 1, ifAbsent: () => 1);
      }
    }
  }
  return byName;
}
