import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Kaato at the workbench, carving pins: the hand-drawn hero illustration
/// on Home. Text-free and decorative, so it is hidden from semantics.
///
/// The SVG must not use <style> or classes (flutter_svg ignores them and
/// draws everything black); run `dart tool/inline_svg_styles.dart` on a
/// fresh Illustrator export.
class WorkbenchKaato extends StatelessWidget {
  const WorkbenchKaato({super.key, this.height = 220});

  static const asset = 'assets/character/workbench-kaato.svg';

  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SvgPicture.asset(asset, height: height, fit: BoxFit.contain),
    );
  }
}
