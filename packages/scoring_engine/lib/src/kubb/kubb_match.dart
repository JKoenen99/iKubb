import 'package:meta/meta.dart' show immutable;

import '../side.dart';
import 'kubb_event.dart';
import 'kubb_game.dart';
import 'kubb_rules.dart';

/// A best-of-N kubb match: an ordered list of game event-logs, replayed.
/// Game `i` is started by side `i % 2` (starting side alternates).
@immutable
class KubbMatch {
  KubbMatch._(this.sides, this.rules, List<List<KubbEvent>> gameEvents)
      : gameEvents = List.unmodifiable(
            [for (final g in gameEvents) List<KubbEvent>.unmodifiable(g)]) {
    games = List.unmodifiable([
      for (final (i, eventList) in this.gameEvents.indexed)
        _replayGame(i, eventList),
    ]);
    final winCounts = [0, 0];
    for (final game in games) {
      final w = game.winner;
      if (w != null) winCounts[sides.indexOf(w)]++;
    }
    wins = List.unmodifiable(winCounts);
    final needed = rules.gamesToWin;
    matchWinner = winCounts[0] >= needed
        ? sides[0]
        : winCounts[1] >= needed
            ? sides[1]
            : null;
  }

  factory KubbMatch.start({
    required List<Side> sides,
    KubbRules rules = KubbRules.classic,
  }) =>
      KubbMatch._(List.unmodifiable(sides), rules, const [[]]);

  final List<Side> sides;
  final KubbRules rules;
  final List<List<KubbEvent>> gameEvents;

  late final List<KubbGame> games;
  late final List<int> wins;
  late final Side? matchWinner;

  KubbGame get currentGame => games.last;
  bool get isFinished => matchWinner != null;

  /// True when the current game ended but the match still needs games.
  bool get needsNextGame => currentGame.isFinished && !isFinished;

  KubbGame _replayGame(int index, List<KubbEvent> events) {
    var game = KubbGame.start(
      sides: sides,
      rules: rules,
      startingSide: index % 2,
    );
    for (final event in events) {
      game = game.applyEvent(event);
    }
    return game;
  }

  KubbMatch applyEvent(KubbEvent event) {
    if (isFinished) throw StateError('Match is finished');
    currentGame.applyEvent(event); // validates against game state
    final updated = [...gameEvents];
    updated[updated.length - 1] = [...updated.last, event];
    return KubbMatch._(sides, rules, updated);
  }

  /// Starts the next game of the match (only after the current finished).
  KubbMatch nextGame() {
    if (!needsNextGame) throw StateError('Current game is still running');
    return KubbMatch._(sides, rules, [...gameEvents, const []]);
  }

  /// Removes the last event; crossing back over a game boundary removes
  /// the empty game first so undo is seamless across the whole match.
  KubbMatch undo() {
    final updated = [
      for (final g in gameEvents) [...g],
    ];
    if (updated.last.isEmpty) {
      if (updated.length == 1) return this;
      updated.removeLast();
    }
    if (updated.last.isNotEmpty) updated.last.removeLast();
    return KubbMatch._(sides, rules, updated);
  }

  bool get hasEvents => gameEvents.any((g) => g.isNotEmpty);

  Map<String, Object?> toJson() => {
        'sides': [for (final s in sides) s.toJson()],
        'rules': rules.toJson(),
        'games': [
          for (final g in gameEvents) [for (final e in g) e.toJson()],
        ],
      };

  factory KubbMatch.fromJson(Map<String, Object?> json) => KubbMatch._(
        List.unmodifiable([
          for (final s in json['sides'] as List)
            Side.fromJson((s as Map).cast<String, Object?>()),
        ]),
        KubbRules.fromJson((json['rules'] as Map).cast<String, Object?>()),
        [
          for (final g in json['games'] as List)
            [
              for (final e in g as List)
                KubbEvent.fromJson((e as Map).cast<String, Object?>()),
            ],
        ],
      );
}
