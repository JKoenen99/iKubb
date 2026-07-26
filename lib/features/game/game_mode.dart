import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two games the app scores.
enum GameMode { numberKubb, classicKubb }

/// Last played mode: drives Quick start and where the rules panel opens
/// from neutral screens. Persisted.
class LastModeController extends Notifier<GameMode> {
  static const _key = 'last_mode_v1';

  @override
  GameMode build() {
    SharedPreferences.getInstance().then((prefs) {
      final stored = GameMode.values.asNameMap()[prefs.getString(_key)];
      if (stored != null && stored != state) state = stored;
    });
    return GameMode.numberKubb;
  }

  void set(GameMode mode) {
    state = mode;
    SharedPreferences.getInstance().then((p) => p.setString(_key, mode.name));
  }
}

final lastModeProvider = NotifierProvider<LastModeController, GameMode>(
  LastModeController.new,
);
