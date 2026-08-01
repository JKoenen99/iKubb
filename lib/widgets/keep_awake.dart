import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../features/settings/settings_controller.dart';

/// Keeps the screen on while mounted, when enabled in settings — wrap any
/// screen a game is glanced at (SPEC.md §3.3): /game, /kubb, /scoreboard.
/// Best-effort: platforms without the plugin (tests, unsupported targets)
/// must never break play.
class KeepAwake extends ConsumerStatefulWidget {
  const KeepAwake({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<KeepAwake> createState() => _KeepAwakeState();
}

class _KeepAwakeState extends ConsumerState<KeepAwake> {
  @override
  void initState() {
    super.initState();
    _set(ref.read(keepAwakeProvider));
  }

  @override
  void dispose() {
    _set(false);
    super.dispose();
  }

  void _set(bool enable) {
    try {
      WakelockPlus.toggle(enable: enable).catchError((_) {});
    } on Object {
      // Wakelock is a nicety, not a requirement.
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(keepAwakeProvider, (_, enabled) => _set(enabled));
    return widget.child;
  }
}
