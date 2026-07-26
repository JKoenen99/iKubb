import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Subtle birch wood-grain texture for large brand surfaces (onboarding,
/// win screen) — never behind body text (SPEC.md §4). Deterministic wavy
/// strokes, low alpha, purely decorative.
class WoodGrainBackground extends StatelessWidget {
  const WoodGrainBackground({
    super.key,
    required this.color,
    this.opacity = 0.05,
  });

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _WoodGrainPainter(color.withValues(alpha: opacity)),
        ),
      ),
    );
  }
}

class _WoodGrainPainter extends CustomPainter {
  const _WoodGrainPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Long horizontal grain lines with gentle, fixed-phase waves.
    const spacing = 26.0;
    var row = 0;
    for (var y = spacing / 2; y < size.height; y += spacing, row++) {
      final path = Path()..moveTo(-10, y);
      final amplitude = 2.0 + (row % 3);
      final wavelength = 140.0 + (row % 4) * 35;
      final phase = row * 1.7;
      for (var x = -10.0; x <= size.width + 10; x += 12) {
        path.lineTo(
          x,
          y + amplitude * math.sin(x / wavelength * 2 * math.pi + phase),
        );
      }
      canvas.drawPath(path, paint);
      // Occasional knot.
      if (row % 5 == 2) {
        final cx = size.width * ((row * 37) % 100) / 100;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, y), width: 16, height: 7),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_WoodGrainPainter oldDelegate) =>
      oldDelegate.color != color;
}
