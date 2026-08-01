import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_controller.dart';

/// One haptic vocabulary, honoring the settings toggle everywhere:
/// selection clicks for picking things up, light for routine confirms,
/// medium for warnings/bad outcomes, heavy for wins.
abstract final class Haptics {
  static void selection(WidgetRef ref) =>
      _fx(ref, HapticFeedback.selectionClick);

  static void light(WidgetRef ref) => _fx(ref, HapticFeedback.lightImpact);

  static void medium(WidgetRef ref) => _fx(ref, HapticFeedback.mediumImpact);

  static void heavy(WidgetRef ref) => _fx(ref, HapticFeedback.heavyImpact);

  static void _fx(WidgetRef ref, void Function() effect) {
    if (ref.read(hapticsEnabledProvider)) effect();
  }
}
