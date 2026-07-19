import 'dart:io';

import 'package:live_activities/live_activities.dart';
import 'package:scoring_engine/scoring_engine.dart';

import 'live_score.dart';

LiveScore createLiveScore() => _LiveScoreIos();

/// Mirrors the running game into an iOS Live Activity so the score shows
/// in the Dynamic Island / on the Lock Screen while the app is in the
/// background. Requires the LiveScoreWidget extension target — see
/// docs/LIVE_ACTIVITY_SETUP.md; without it every call fails quietly.
class _LiveScoreIos implements LiveScore {
  static const _appGroupId = 'group.nl.jasperkoenen.ikubb';

  final _plugin = LiveActivities();
  bool _initialized = false;
  String? _activityId;
  bool _busy = false;

  @override
  void sync(Game game) {
    if (!Platform.isIOS) return;
    _syncAsync(game);
  }

  Future<void> _syncAsync(Game game) async {
    if (_busy) return; // last-write-wins; the next sync carries fresh state
    _busy = true;
    try {
      if (!_initialized) {
        await _plugin.init(appGroupId: _appGroupId);
        _initialized = true;
      }
      if (game.winner != null || game.throws.isEmpty) {
        if (_activityId != null) {
          await _plugin.endActivity(_activityId!);
          _activityId = null;
        }
        return;
      }
      final data = <String, dynamic>{
        for (final (i, state) in game.sideStates.indexed) ...{
          'name$i': state.side.name,
          'score$i': '${state.score}',
        },
        'sideCount': '${game.sideStates.length}',
        'activeIndex': '${game.currentSideIndex ?? 0}',
        'target': '${game.rules.targetScore}',
      };
      if (_activityId == null) {
        _activityId = await _plugin.createActivity(
          'ikubb-live-score',
          data,
          removeWhenAppIsKilled: true,
        );
      } else {
        await _plugin.updateActivity(_activityId!, data);
      }
    } on Object {
      // Missing extension, iOS < 16.1, simulator, permissions — all fine.
    } finally {
      _busy = false;
    }
  }
}
