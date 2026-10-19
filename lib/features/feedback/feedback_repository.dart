import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'feedback_event.dart';

/// When the app last asked, and how the player reacted — the inputs of the
/// prompt-eligibility rules in [FeedbackScheduler].
class FeedbackPromptState {
  const FeedbackPromptState({
    this.lastPromptAt,
    this.lastSubmittedAt,
    this.lastStoreReviewAt,
    this.gamesAtLastPrompt = 0,
    this.tourAsked = false,
    this.optedOut = false,
  });

  final DateTime? lastPromptAt;
  final DateTime? lastSubmittedAt;
  final DateTime? lastStoreReviewAt;

  /// Finished-game count at the moment of the last game-end prompt.
  final int gamesAtLastPrompt;
  final bool tourAsked;

  /// "Don't ask again": no more automatic prompts; Settings still works.
  final bool optedOut;

  FeedbackPromptState copyWith({
    DateTime? lastPromptAt,
    DateTime? lastSubmittedAt,
    DateTime? lastStoreReviewAt,
    int? gamesAtLastPrompt,
    bool? tourAsked,
    bool? optedOut,
  }) => FeedbackPromptState(
    lastPromptAt: lastPromptAt ?? this.lastPromptAt,
    lastSubmittedAt: lastSubmittedAt ?? this.lastSubmittedAt,
    lastStoreReviewAt: lastStoreReviewAt ?? this.lastStoreReviewAt,
    gamesAtLastPrompt: gamesAtLastPrompt ?? this.gamesAtLastPrompt,
    tourAsked: tourAsked ?? this.tourAsked,
    optedOut: optedOut ?? this.optedOut,
  );

  Map<String, Object?> toJson() => {
    'lastPromptAt': lastPromptAt?.toUtc().toIso8601String(),
    'lastSubmittedAt': lastSubmittedAt?.toUtc().toIso8601String(),
    'lastStoreReviewAt': lastStoreReviewAt?.toUtc().toIso8601String(),
    'gamesAtLastPrompt': gamesAtLastPrompt,
    'tourAsked': tourAsked,
    'optedOut': optedOut,
  };

  factory FeedbackPromptState.fromJson(Map<String, Object?> json) =>
      FeedbackPromptState(
        lastPromptAt: _date(json['lastPromptAt']),
        lastSubmittedAt: _date(json['lastSubmittedAt']),
        lastStoreReviewAt: _date(json['lastStoreReviewAt']),
        gamesAtLastPrompt: (json['gamesAtLastPrompt'] as num?)?.toInt() ?? 0,
        tourAsked: json['tourAsked'] as bool? ?? false,
        optedOut: json['optedOut'] as bool? ?? false,
      );

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v) : null;
}

/// Local, system-independent storage for feedback: every event is kept on
/// the device as JSON (the outbox), marked synced once a sink accepted it.
/// Nothing is ever lost to a bad connection, and the whole history can be
/// exported as JSON Lines regardless of which backend is configured.
class FeedbackRepository {
  static const _installIdKey = 'feedback_install_id_v1';
  static const _stateKey = 'feedback_prompt_state_v1';
  static const _eventsKey = 'feedback_events_v1';
  static const _syncedKey = 'feedback_synced_ids_v1';

  /// Local cap: the outbox is a buffer, not an archive. Oldest synced
  /// events are dropped first; unsynced ones are kept.
  static const _cap = 200;

  /// The anonymous per-installation id, created on first use.
  Future<String> installId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_installIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = newUuid();
    await prefs.setString(_installIdKey, id);
    return id;
  }

  Future<FeedbackPromptState> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_stateKey);
    if (raw == null) return const FeedbackPromptState();
    try {
      return FeedbackPromptState.fromJson(
        (jsonDecode(raw) as Map).cast<String, Object?>(),
      );
    } on Object {
      return const FeedbackPromptState();
    }
  }

  Future<void> saveState(FeedbackPromptState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stateKey, jsonEncode(state.toJson()));
  }

  Future<List<FeedbackEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_eventsKey);
    if (raw == null) return const [];
    try {
      return [
        for (final e in jsonDecode(raw) as List)
          FeedbackEvent.fromJson((e as Map).cast<String, Object?>()),
      ];
    } on Object {
      return const [];
    }
  }

  Future<Set<String>> syncedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_syncedKey) ?? const []).toSet();
  }

  Future<void> append(FeedbackEvent event) async {
    final events = [...await loadEvents(), event];
    await _saveEvents(events, await syncedIds());
  }

  /// Replaces an event (same id) — used to flag the store-review request.
  Future<void> update(FeedbackEvent event) async {
    final events = [
      for (final e in await loadEvents())
        e.eventId == event.eventId ? event : e,
    ];
    await _saveEvents(events, await syncedIds());
  }

  Future<List<FeedbackEvent>> unsynced() async {
    final synced = await syncedIds();
    return [
      for (final e in await loadEvents())
        if (!synced.contains(e.eventId)) e,
    ];
  }

  Future<void> markSynced(Iterable<String> ids) async {
    final synced = {...await syncedIds(), ...ids};
    await _saveEvents(await loadEvents(), synced);
  }

  /// Every stored event as JSON Lines, newest last — the portable export.
  Future<String> exportJsonLines() async =>
      [for (final e in await loadEvents()) jsonEncode(e.toJson())].join('\n');

  Future<void> _saveEvents(
    List<FeedbackEvent> events,
    Set<String> synced,
  ) async {
    var kept = events;
    if (kept.length > _cap) {
      final overflow = kept.length - _cap;
      var dropped = 0;
      kept = [
        for (final e in kept)
          if (dropped < overflow && synced.contains(e.eventId))
            ..._drop(() => dropped++)
          else
            e,
      ];
    }
    final ids = kept.map((e) => e.eventId).toSet();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _eventsKey,
      jsonEncode([for (final e in kept) e.toJson()]),
    );
    await prefs.setStringList(_syncedKey, [
      for (final id in synced)
        if (ids.contains(id)) id,
    ]);
  }

  static Iterable<FeedbackEvent> _drop(void Function() count) {
    count();
    return const [];
  }

  /// RFC 4122 version-4 UUID from a cryptographic RNG; no extra package.
  static String newUuid() {
    final rng = Random.secure();
    final b = List<int>.generate(16, (_) => rng.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final hex = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
