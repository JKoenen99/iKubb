import 'package:scoring_engine/scoring_engine.dart';

import 'live_score_stub.dart' if (dart.library.io) 'live_score_io.dart';

/// Live Activity bridge (Dynamic Island / Lock Screen score while the app
/// is backgrounded). The real implementation only exists on iO-capable
/// platforms and only acts on iOS 16.1+ with the widget extension
/// installed; everywhere else this is a no-op. It must never be able to
/// affect gameplay: every call is fire-and-forget and error-swallowing.
abstract class LiveScore {
  /// Reflects the current game: starts the activity on the first throw,
  /// updates it on every change, ends it on a win or reset.
  void sync(Game game);

  /// The classic-kubb equivalent: baseline kubbs remaining per team
  /// instead of scores, ended when the match is decided.
  void syncKubb(KubbMatch match);
}

final LiveScore liveScore = createLiveScore();
