import 'package:flutter/material.dart';

/// Kaato throwing the stick: the hand-drawn hero illustration on Home.
/// A transparent PNG, sized by its parent (it fills the space it gets and
/// keeps its aspect ratio). Text-free and decorative, so it is hidden from
/// semantics.
class ThrowerKaato extends StatelessWidget {
  const ThrowerKaato({super.key});

  static const asset = 'assets/character/thrower-kaato.png';

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
