import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two scoring input modes (SPEC.md §3.3): the mistake-proof pin
/// diagram, or the fast 0–12 number pad for experienced scorers.
enum InputMode { pins, pad }

const _prefsKey = 'input_mode_v1';

/// User-switchable in-game via the app-bar toggle; the choice persists.
class InputModeController extends Notifier<InputMode> {
  @override
  InputMode build() {
    SharedPreferences.getInstance().then((prefs) {
      final stored = prefs.getString(_prefsKey);
      if (stored == InputMode.pad.name) state = InputMode.pad;
    });
    return InputMode.pins;
  }

  void toggle() {
    state = state == InputMode.pins ? InputMode.pad : InputMode.pins;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString(_prefsKey, state.name));
  }
}

final inputModeProvider =
    NotifierProvider<InputModeController, InputMode>(InputModeController.new);
