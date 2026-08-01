import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Odometer-style number: the value updates instantly, the old digits roll
/// away as decoration (SPEC.md §3.7 — state first, motion second).
class RollingNumber extends StatelessWidget {
  const RollingNumber({super.key, required this.value, this.style});

  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: IKubbMotion.resolve(context, IKubbMotion.gentle),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => ClipRect(
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.7),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
      ),
      child: Text('$value', key: ValueKey(value), style: style),
    );
  }
}
