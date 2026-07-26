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
    this.overshootPolicy = OvershootPolicy.resetToFixed,
    this.eliminationEnabled = true,
    this.missLimit = 3,
  });

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
  final OvershootPolicy overshootPolicy;
  final bool eliminationEnabled;
  final int missLimit;

  Team teamFor(Player p) => teamOf[p.id] ?? Team.values[players.indexOf(p) % 2];

  List<Player> onTeam(Team t) => [
    for (final p in players)
      if (teamFor(p) == t) p,
  ];

  bool get isClassic =>
      targetScore == 50 &&
      overshootPolicy == OvershootPolicy.resetToFixed &&
      eliminationEnabled &&
      missLimit == 3;

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
    // Classic pairs 50 with 25; other targets fall back to half.
    overshootResetValue: targetScore == 50 ? 25 : max(1, targetScore ~/ 2),
    eliminationEnabled: eliminationEnabled,
    missLimit: missLimit,
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
    OvershootPolicy? overshootPolicy,
    bool? eliminationEnabled,
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
    overshootPolicy: overshootPolicy ?? this.overshootPolicy,
    eliminationEnabled: eliminationEnabled ?? this.eliminationEnabled,
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

  void setTargetScore(int target) {
    if (target < 2) return;
    state = state.copyWith(targetScore: target);
  }

  void setOvershootPolicy(OvershootPolicy policy) =>
      state = state.copyWith(overshootPolicy: policy);

  void setElimination(bool enabled) =>
      state = state.copyWith(eliminationEnabled: enabled);

  void setMissLimit(int limit) {
    if (limit < 1 || limit > 9) return;
    state = state.copyWith(missLimit: limit);
  }

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
    ref.read(recentPlayersRepositoryProvider).markUsed(state.players);
  }
}

final setupControllerProvider = NotifierProvider<SetupController, SetupState>(
  SetupController.new,
);
