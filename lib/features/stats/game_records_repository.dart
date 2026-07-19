import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The active game plus its presentation extras, as persisted.
typedef ActiveGameRecord = ({
  String id,
  Game game,
  Map<String, int> sideColors,
});

/// A finished game in the history list.
class FinishedGame {
  const FinishedGame({
    required this.id,
    required this.finishedAt,
    required this.game,
  });

  final String id;
  final DateTime finishedAt;
  final Game game;

  Map<String, Object?> toJson() => {
    'id': id,
    'finishedAt': finishedAt.toIso8601String(),
    'game': game.toJson(),
  };

  factory FinishedGame.fromJson(Map<String, Object?> json) => FinishedGame(
    id: json['id'] as String,
    finishedAt: DateTime.parse(json['finishedAt'] as String),
    game: Game.fromJson((json['game'] as Map).cast<String, Object?>()),
  );
}

/// Persists the active game (for exact resume, undo history included — the
/// throw log IS the history) and the finished-games list (SPEC.md §3.5).
///
/// JSON in shared_preferences behind this interface for now; a local
/// database (Drift) can replace the storage without touching callers.
class GameRecordsRepository {
  static const _activeKey = 'active_game_v1';
  static const _historyKey = 'game_history_v1';
  static const _historyCap = 200;

  Future<ActiveGameRecord?> loadActive() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activeKey);
    if (raw == null) return null;
    try {
      final json = (jsonDecode(raw) as Map).cast<String, Object?>();
      return (
        id: json['id'] as String,
        game: Game.fromJson((json['game'] as Map).cast<String, Object?>()),
        sideColors: ((json['sideColors'] as Map?) ?? {}).map(
          (k, v) => MapEntry(k as String, (v as num).toInt()),
        ),
      );
    } on Object {
      return null; // A corrupt record must never brick the app.
    }
  }

  Future<void> saveActive(ActiveGameRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _activeKey,
      jsonEncode({
        'id': record.id,
        'game': record.game.toJson(),
        'sideColors': record.sideColors,
      }),
    );
  }

  Future<List<FinishedGame>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return const [];
    try {
      return [
        for (final e in jsonDecode(raw) as List)
          FinishedGame.fromJson((e as Map).cast<String, Object?>()),
      ];
    } on Object {
      return const [];
    }
  }

  Future<void> deleteFinished(String id) async {
    final history = await loadHistory();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _historyKey,
      jsonEncode([
        for (final g in history.where((g) => g.id != id)) g.toJson(),
      ]),
    );
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  /// Adds [entry] to the front of the history. An existing entry with the
  /// same id is replaced — winning, undoing, and winning again must not
  /// duplicate the game.
  Future<void> recordFinished(FinishedGame entry) async {
    final history = await loadHistory();
    final rest = history.where((g) => g.id != entry.id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _historyKey,
      jsonEncode([
        for (final g in [entry, ...rest].take(_historyCap)) g.toJson(),
      ]),
    );
  }
}

final gameRecordsRepositoryProvider = Provider<GameRecordsRepository>(
  (ref) => GameRecordsRepository(),
);

/// The game restored at startup (resolved in main() before runApp), or null
/// on a fresh start. Tests and cold starts use the default.
final restoredGameProvider = Provider<ActiveGameRecord?>((ref) => null);

/// Finished games, newest first. autoDispose so the stats screen re-reads
/// on every visit.
final gameHistoryProvider = FutureProvider.autoDispose<List<FinishedGame>>(
  (ref) => ref.watch(gameRecordsRepositoryProvider).loadHistory(),
);
