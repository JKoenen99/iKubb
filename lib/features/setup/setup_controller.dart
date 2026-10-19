import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../game/game_mode.dart';
import 'player.dart';
import 'recent_players_repository.dart';

/// Which team a player is on in team mode.
enum Team { a, b }

class SetupState {
  const SetupState({
    this.mode = GameMode.numberKubb,
    this.kubbBestOf = 1,
    this.kubbClockSeconds,
    this.players = const [],
    this.recents = const [],
    this.teamMode = false,
    this.teamOf = const {},
    this.teamAName = '',
    this.teamBName = '',
    this.targetScore = 50,
    this.overshootResetValue = 25,
    this.missLimit = 3,
  });

  /// The official rules sheet: first to 50, back to 25, out after 3.
  static const classicTarget = 50;
  static const classicReset = 25;
  static const classicMissLimit = 3;

  final GameMode mode;
  final int kubbBestOf;
  final int? kubbClockSeconds;

  /// Selected players, in throw order.
  final List<Player> players;
  final List<Player> recents;
  final bool teamMode;

  /// playerId → team. Players missing from the map default to alternating.
  final Map<String, Team> teamOf;

  /// Custom team names; empty string means "use the localized default".
  final String teamAName;
  final String teamBName;

  final int targetScore;

  /// Score a side drops back to on overshoot; 0 means no penalty.
  final int overshootResetValue;

  /// Consecutive misses that eliminate a side; 0 means no elimination.
  final int missLimit;

  OvershootPolicy get overshootPolicy => overshootResetValue == 0
      ? OvershootPolicy.none
      : OvershootPolicy.resetToFixed;
  bool get eliminationEnabled => missLimit > 0;

  Team teamFor(Player p) => teamOf[p.id] ?? Team.values[players.indexOf(p) % 2];

  List<Player> onTeam(Team t) => [
    for (final p in players)
      if (teamFor(p) == t) p,
  ];

  bool get isClassic =>
      targetScore == classicTarget &&
      overshootResetValue == classicReset &&
      missLimit == classicMissLimit;

  /// Null when the game can start; otherwise which validation failed.
  SetupProblem? get problem {
    if (players.length < 2) return SetupProblem.needTwoPlayers;
    if (teamMode && (onTeam(Team.a).isEmpty || onTeam(Team.b).isEmpty)) {
      return SetupProblem.needBothTeams;
    }
    return null;
  }

  KubbRules get kubbRules =>
      KubbRules(bestOf: kubbBestOf, turnClockSeconds: kubbClockSeconds);

  GameRules get rules => GameRules(
    targetScore: targetScore,
    overshootPolicy: overshootPolicy,
    overshootResetValue: overshootResetValue,
    eliminationEnabled: eliminationEnabled,
    // The engine wants a positive limit even when elimination is off.
    missLimit: max(1, missLimit),
  );

  SetupState copyWith({
    GameMode? mode,
    int? kubbBestOf,
    Object? kubbClockSeconds = _sentinel,
    List<Player>? players,
    List<Player>? recents,
    bool? teamMode,
    Map<String, Team>? teamOf,
    String? teamAName,
    String? teamBName,
    int? targetScore,
    int? overshootResetValue,
    int? missLimit,
  }) => SetupState(
    mode: mode ?? this.mode,
    kubbBestOf: kubbBestOf ?? this.kubbBestOf,
    kubbClockSeconds: kubbClockSeconds == _sentinel
        ? this.kubbClockSeconds
        : kubbClockSeconds as int?,
    players: players ?? this.players,
    recents: recents ?? this.recents,
    teamMode: teamMode ?? this.teamMode,
    teamOf: teamOf ?? this.teamOf,
    teamAName: teamAName ?? this.teamAName,
    teamBName: teamBName ?? this.teamBName,
    targetScore: targetScore ?? this.targetScore,
    overshootResetValue: overshootResetValue ?? this.overshootResetValue,
    missLimit: missLimit ?? this.missLimit,
  );
}

enum SetupProblem { needTwoPlayers, needBothTeams }

const _sentinel = Object();

final recentPlayersRepositoryProvider = Provider<RecentPlayersRepository>(
  (ref) => RecentPlayersRepository(),
);

class SetupController extends Notifier<SetupState> {
  final _random = Random();

  @override
  SetupState build() {
    _loadRecents();
    return const SetupState();
  }

  Future<void> _loadRecents() async {
    final recents = await ref.read(recentPlayersRepositoryProvider).load();
    state = state.copyWith(recents: recents);
  }

  int _autoCounter = 0;

  void addPlayer(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final player = Player(
      id: 'p${DateTime.now().microsecondsSinceEpoch}',
      name: trimmed,
      colorIndex: state.players.length % playerColors.length,
    );
    state = state.copyWith(players: [...state.players, player]);
  }

  /// Adds a player with a generated name ("Player N"); names are optional
  /// and can be changed by tapping the row. [nameFor] localizes the name.
  void addAutoPlayer(String Function(int n) nameFor) {
    final n = ++_autoCounter;
    final player = Player(
      id: 'p${DateTime.now().microsecondsSinceEpoch}',
      name: nameFor(n),
      colorIndex: state.players.length % playerColors.length,
      autoNumber: n,
    );
    state = state.copyWith(players: [...state.players, player]);
  }

  /// Renames a player; an empty name keeps the current one.
  void renamePlayer(Player player, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed == player.name) return;
    state = state.copyWith(
      players: [
        for (final p in state.players)
          if (p.id == player.id) p.copyWith(name: trimmed) else p,
      ],
    );
  }

  /// Adds a recent player (no-op if already selected).
  void addRecent(Player player) {
    if (state.players.any((p) => p.id == player.id)) return;
    state = state.copyWith(players: [...state.players, player]);
  }

  void removePlayer(Player player) => state = state.copyWith(
    players: [...state.players]..removeWhere((p) => p.id == player.id),
  );

  void reorder(int oldIndex, int newIndex) {
    final players = [...state.players];
    players.insert(newIndex, players.removeAt(oldIndex));
    state = state.copyWith(players: players);
  }

  void shuffleOrder() =>
      state = state.copyWith(players: [...state.players]..shuffle(_random));

  void setTeamMode(bool enabled) => state = state.copyWith(teamMode: enabled);

  /// Classic kubb is a team game: switching to it forces team mode on.
  void setMode(GameMode mode) => state = state.copyWith(
    mode: mode,
    teamMode: mode == GameMode.classicKubb ? true : state.teamMode,
  );

  void setKubbBestOf(int bestOf) => state = state.copyWith(kubbBestOf: bestOf);

  void setKubbClock(int? seconds) =>
      state = state.copyWith(kubbClockSeconds: seconds);

  void assignTeam(Player player, Team team) =>
      state = state.copyWith(teamOf: {...state.teamOf, player.id: team});

  /// Alternates players over both teams, evening out the sizes.
  void autoBalance() => state = state.copyWith(
    teamOf: {
      for (final (i, p) in state.players.indexed) p.id: Team.values[i % 2],
    },
  );

  void setTeamName(Team team, String name) => state = team == Team.a
      ? state.copyWith(teamAName: name)
      : state.copyWith(teamBName: name);

  /// Every player changes team.
  void swapTeams() => state = state.copyWith(
    teamOf: {
      for (final p in state.players)
        p.id: state.teamFor(p) == Team.a ? Team.b : Team.a,
    },
  );

  static const minTarget = 10;
  static const maxTarget = 200;
  static const maxMissLimit = 9;

  /// The overshoot reset always stays below the target.
  void setTargetScore(int target) {
    final t = target.clamp(minTarget, maxTarget);
    state = state.copyWith(
      targetScore: t,
      overshootResetValue: min(state.overshootResetValue, t - 1),
    );
  }

  /// 0 = no penalty on overshoot.
  void setOvershootReset(int value) => state = state.copyWith(
    overshootResetValue: value.clamp(0, state.targetScore - 1),
  );

  /// 0 = no elimination.
  void setMissLimit(int limit) =>
      state = state.copyWith(missLimit: limit.clamp(0, maxMissLimit));

  void resetHouseRules() => state = state.copyWith(
    targetScore: SetupState.classicTarget,
    overshootResetValue: SetupState.classicReset,
    missLimit: SetupState.classicMissLimit,
  );

  /// Builds the sides for the engine, or null if setup is invalid.
  /// [defaultTeamNames] supplies the localized "Team A"/"Team B" fallbacks.
  List<Side>? buildSides({required (String, String) defaultTeamNames}) {
    if (state.problem != null) return null;
    _saveRecents();
    if (!state.teamMode) {
      return [for (final p in state.players) Side(id: p.id, name: p.name)];
    }
    final aName = state.teamAName.trim().isEmpty
        ? defaultTeamNames.$1
        : state.teamAName;
    final bName = state.teamBName.trim().isEmpty
        ? defaultTeamNames.$2
        : state.teamBName;
    return [
      Side(id: 'team-a', name: aName.trim()),
      Side(id: 'team-b', name: bName.trim()),
    ];
  }

  void _saveRecents() {
    // Fire and forget: persistence must never block starting a game.
    // Players who kept their generated name are not worth remembering.
    ref.read(recentPlayersRepositoryProvider).markUsed([
      for (final p in state.players)
        if (!p.isAutoNamed) p,
    ]).ignore();
  }
}

final setupControllerProvider = NotifierProvider<SetupController, SetupState>(
  SetupController.new,
);
