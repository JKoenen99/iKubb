import 'package:flutter/material.dart';

import '../../widgets/viking_mascot.dart';

/// What the mascot reacts to (SPEC.md §3.7 "celebrate in the gaps",
/// UX audit finding #7).
enum ReactionKind { cheer, oops }

/// A corner pop-in mascot reaction: springs in, holds a beat, pops out —
/// ~1.6 s total, driven by one controller so tests can settle. Purely
/// decorative: wrapped in IgnorePointer, skipped under Reduce Motion, and
/// replaced instantly by the next reaction (the key changes).
class MascotReaction extends StatefulWidget {
  const MascotReaction({super.key, required this.kind, required this.onDone});

  final ReactionKind kind;
  final VoidCallback onDone;

  @override
  State<MascotReaction> createState() => _MascotReactionState();
}

class _MascotReactionState extends State<MascotReaction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 15,
    ),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
    TweenSequenceItem(
      tween:
          Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
      weight: 15,
    ),
  ]).animate(_controller);

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return const SizedBox.shrink();
    return IgnorePointer(
      child: ScaleTransition(
        scale: _scale,
        alignment: Alignment.bottomRight,
        child: VikingMascot(
          pose: widget.kind == ReactionKind.cheer
              ? MascotPose.cheer
              : MascotPose.oops,
          size: 96,
        ),
      ),
    );
  }
}
