import 'package:scoring_engine/scoring_engine.dart';

import 'live_score.dart';

/// Web (and any non-io platform): Live Activities don't exist — no-op.
LiveScore createLiveScore() => _NoopLiveScore();

class _NoopLiveScore implements LiveScore {
  @override
  void sync(Game game) {}

  @override
  void syncKubb(KubbMatch match) {}
}
