import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../game/game_controller.dart' show sideColorsProvider;
import '../game/game_mode.dart';
import '../stats/game_records_repository.dart';

/// Holds the active classic-kubb match. Mirrors GameController: every
/// mutation goes through the engine, every change persists (the app keeps
/// one active game across both modes — saving here replaces a number-kubb
/// active record and vice versa), finished matches enter the history.
class KubbController extends Notifier<KubbMatch> {
  late String _matchId;

  @override
  KubbMatch build() {
    final restored = ref.read(restoredGameProvider);
    if (restored?.kubb != null) {
      _matchId = restored!.id;
      return restored.kubb!;
    }
    _matchId = _newId();
    return KubbMatch.start(
      sides: const [
        Side(id: 'team-a', name: 'Team A'),
        Side(id: 'team-b', name: 'Team B'),
      ],
    );
  }

  static String _newId() => 'k${DateTime.now().microsecondsSinceEpoch}';

  void applyEvent(KubbEvent event) {
    state = state.applyEvent(event);
    _persist();
  }

  void undo() {
    state = state.undo();
    _persist();
  }

  void nextGame() {
    state = state.nextGame();
    _persist();
  }

  void newMatch({List<Side>? sides, KubbRules? rules}) {
    _matchId = _newId();
    state = KubbMatch.start(
      sides: sides ?? state.sides,
      rules: rules ?? state.rules,
    );
    _persist();
  }

  void _persist() {
    ref.read(lastModeProvider.notifier).set(GameMode.classicKubb);
    final repo = ref.read(gameRecordsRepositoryProvider);
    repo.saveActive(
      ActiveRecord(
        id: _matchId,
        kubb: state,
        sideColors: ref.read(sideColorsProvider),
      ),
    );
    if (state.isFinished) {
      repo.recordFinished(
        FinishedGame(
          id: _matchId,
          finishedAt: DateTime.now(),
          kubbMatch: state,
        ),
      );
    }
  }
}

final kubbControllerProvider = NotifierProvider<KubbController, KubbMatch>(
  KubbController.new,
);
