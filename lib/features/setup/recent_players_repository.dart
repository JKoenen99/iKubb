import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'player.dart';

/// Persists recently used players so a rematch or next session starts with
/// one tap (SPEC.md §3.2). Most recently used first, capped.
///
/// shared_preferences is enough for now; this moves to the local database
/// when profiles/stats arrive (SPEC.md §3.5).
class RecentPlayersRepository {
  static const _key = 'recent_players_v1';
  static const _cap = 24;

  Future<List<Player>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const [];
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final e in list) Player.fromJson((e as Map).cast<String, Object?>()),
    ];
  }

  /// Moves [used] to the front of the recents list and saves.
  Future<void> markUsed(List<Player> used) async {
    final existing = await load();
    final usedIds = {for (final p in used) p.id};
    final merged = [...used, ...existing.where((p) => !usedIds.contains(p.id))];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode([for (final p in merged.take(_cap)) p.toJson()]),
    );
  }
}
