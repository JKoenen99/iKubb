import 'dart:async' show unawaited;
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
  static const _appGroupId = 'group.nl.jasperkoenen.kaato';

  final _plugin = LiveActivities();
  bool _initialized = false;
  String? _activityId;
  bool _busy = false;

  /// The newest state that arrived while a platform call was in flight. It
  /// runs as soon as the call finishes, so the Live Activity always ends on
  /// the latest throw — including the winning one.
  ({bool ended, Map<String, dynamic> data})? _pending;

  @override
  void sync(Game game) {
    if (!Platform.isIOS) return;
    _syncAsync(
      ended: game.winner != null || game.throws.isEmpty,
      data: {
        for (final (i, state) in game.sideStates.indexed) ...{
          'name$i': state.side.name,
          'score$i': '${state.score}',
        },
        'sideCount': '${game.sideStates.length}',
        'activeIndex': '${game.currentSideIndex ?? 0}',
        'target': '${game.rules.targetScore}',
      },
    );
  }

  Future<void> _syncAsync({
    required bool ended,
    required Map<String, dynamic> data,
  }) async {
    if (_busy) {
      _pending = (ended: ended, data: data); // last write wins, never lost
      return;
    }
    _busy = true;
    try {
      if (!_initialized) {
        await _plugin.init(appGroupId: _appGroupId);
        _initialized = true;
      }
      if (ended) {
        if (_activityId != null) {
          await _plugin.endActivity(_activityId!);
          _activityId = null;
        }
        return;
      }
      if (_activityId == null) {
        _activityId = await _plugin.createActivity(
          'kaato-live-score',
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
      if (_pending case final next?) {
        _pending = null;
        unawaited(_syncAsync(ended: next.ended, data: next.data));
      }
    }
  }
}
