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

/// Lifetime classic-kubb numbers for one team name. Kept apart from
/// [PlayerStats]: kubbs-per-baton and points-per-throw are incomparable,
/// so the two modes are never summed — only games/wins share a header.
class KubbSideStats {
  KubbSideStats(this.name);

  final String name;
  int matches = 0;
  int matchWins = 0;
  int kingsFelled = 0;
  int earlyKings = 0;
  int batons = 0;
  int kubbsFelled = 0;
  int advantageTurns = 0;

  double get winRate => matches == 0 ? 0 : matchWins / matches;

  double get kubbsPerBaton => batons == 0 ? 0 : kubbsFelled / batons;
}

/// Per-team classic-kubb stats, replayed from the stored event logs.
Map<String, KubbSideStats> aggregateKubbStats(List<FinishedGame> history) {
  final byName = <String, KubbSideStats>{};
  KubbSideStats statsFor(String name) =>
      byName.putIfAbsent(name, () => KubbSideStats(name));

  for (final finished in history) {
    final match = finished.kubbMatch;
    if (match == null) continue;
    for (final side in match.sides) {
      statsFor(side.name).matches++;
    }
    if (match.matchWinner case final winner?) {
      statsFor(winner.name).matchWins++;
    }
    for (final game in match.games) {
      // Walk the event log with the same turn logic as the engine: track
      // who is attacking to attribute batons, kubbs, and advantage turns.
      final field = [0, 0];
      var attacker = game.startingSide;
      var batons = 0;
      var felledTurn = 0;

      void nextTurn() {
        attacker = 1 - attacker;
        batons = 0;
        felledTurn = 0;
        if (field[attacker] > 0) {
          statsFor(game.sides[attacker].name).advantageTurns++;
        }
      }

      for (final event in game.events) {
        final stats = statsFor(game.sides[attacker].name);
        switch (event) {
          case KubbBaton e:
            batons++;
            stats.batons++;
            if (e.hitKing) {
              // The king event is always the last one, so the game's own
              // verdict applies to it directly.
              if (game.earlyKing) {
                stats.earlyKings++;
              } else {
                stats.kingsFelled++;
              }
            } else {
              field[1 - attacker] -= e.felledField;
              final felled = e.felledField + e.felledBaseline;
              stats.kubbsFelled += felled;
              felledTurn += felled;
              if (batons >= game.rules.batonsPerTurn && felledTurn == 0) {
                nextTurn();
              }
            }
          case KubbThrowIn _:
            field[attacker] += felledTurn;
            nextTurn();
        }
      }
    }
  }
  return byName;
}

/// Computes per-player lifetime stats by replaying every stored game
/// through the engine — the stored throw log is the single source of truth.
Map<String, PlayerStats> aggregateStats(List<FinishedGame> history) {
  final byName = <String, PlayerStats>{};
  PlayerStats statsFor(String name) =>
      byName.putIfAbsent(name, () => PlayerStats(name));

  for (final finished in history) {
    final game = finished.game;
    if (game == null) continue; // kubb matches aggregate separately
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
