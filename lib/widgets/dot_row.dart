import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The one way to show progress dots (misses, match wins, batons).
///
/// Filled and idle dots differ in *shape* (filled vs outlined), not just
/// color (WCAG 1.4.1), and the row carries a caller-provided semantic
/// summary so assistive tech hears "2 of 6" instead of six circles.
class DotRow extends StatelessWidget {
  const DotRow({
    super.key,
    required this.count,
    required this.filled,
    required this.activeColor,
    required this.idleColor,
    this.size = IKubbIconSize.dot,
    this.padding = const EdgeInsets.all(IKubbSpacing.xxs),
    this.semanticLabel,
  });

  final int count;
  final int filled;
  final Color activeColor;
  final Color idleColor;
  final double size;
  final EdgeInsets padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < count; i++)
              Padding(
                padding: padding,
                child: Icon(
                  i < filled ? Icons.circle : Icons.circle_outlined,
                  size: size,
                  color: i < filled ? activeColor : idleColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
