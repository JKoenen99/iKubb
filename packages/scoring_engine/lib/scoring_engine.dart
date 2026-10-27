/// Pure Dart scoring engine for number kubb (Scandinavian kegelspel).
///
/// The engine is deliberately Flutter-free: a [Game] is an immutable value
/// built from a list of [Throw]s, and every derived fact (scores, miss
/// streaks, eliminations, whose turn it is, who won) is recomputed by
/// replaying that list. Undo and throw-editing therefore fall out for free
/// and can never disagree with the displayed state.
library;

export 'src/game.dart';
export 'src/rules.dart';
export 'src/side.dart';
export 'src/throw.dart';
