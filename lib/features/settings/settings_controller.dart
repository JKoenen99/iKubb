import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App settings (SPEC.md §3.8), each persisted individually and loaded
/// lazily — a missing value falls back to the default without blocking
/// startup.

/// Manual language override; null follows the device language.
class LocaleController extends Notifier<Locale?> {
  static const _key = 'locale_override_v1';

  @override
  Locale? build() {
    SharedPreferences.getInstance().then((prefs) {
      final code = prefs.getString(_key);
      if (code != null && code.isNotEmpty) state = Locale(code);
    });
    return null;
  }

  void set(Locale? locale) {
    state = locale;
    SharedPreferences.getInstance()
        .then((p) => p.setString(_key, locale?.languageCode ?? ''));
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);

/// A persisted boolean setting.
class _BoolSetting extends Notifier<bool> {
  _BoolSetting(this.key, this.defaultValue);

  final String key;
  final bool defaultValue;

  @override
  bool build() {
    SharedPreferences.getInstance().then((prefs) {
      final stored = prefs.getBool(key);
      if (stored != null && stored != state) state = stored;
    });
    return defaultValue;
  }

  void set(bool value) {
    state = value;
    SharedPreferences.getInstance().then((p) => p.setBool(key, value));
  }
}

/// Haptic feedback on throws (SPEC.md §3.7 "haptics can be disabled").
final hapticsEnabledProvider = NotifierProvider<_BoolSetting, bool>(
    () => _BoolSetting('haptics_enabled_v1', true));

/// Keep the screen awake during an active game (SPEC.md §3.3).
final keepAwakeProvider = NotifierProvider<_BoolSetting, bool>(
    () => _BoolSetting('keep_awake_v1', true));
