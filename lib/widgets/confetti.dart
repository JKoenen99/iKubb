import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// One-shot celebration confetti: falling birch leaves and rune strokes in
/// palette colors. Purely decorative — wrapped in [IgnorePointer] so it can
/// never block input (SPEC.md §3.7) — and skipped under Reduce Motion.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    this.duration = const Duration(milliseconds: 2500),
  });

  final Duration duration;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particles = List.generate(42, (_) => _Particle.random(random));
    _controller.forward();
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(_particles, _controller.value),
        ),
      ),
    );
  }
}

class _Particle {
  _Particle.random(math.Random random)
    : x = random.nextDouble(),
      speed = 0.7 + random.nextDouble() * 0.6,
      sway = 0.02 + random.nextDouble() * 0.05,
      phase = random.nextDouble() * 2 * math.pi,
      spin = (random.nextDouble() - 0.5) * 6,
      sizeFactor = 6 + random.nextDouble() * 7,
      isLeaf = random.nextBool(),
      color = _colors[random.nextInt(_colors.length)];

  static const _colors = [
    IKubbPalette.forest,
    IKubbPalette.pine,
    IKubbPalette.oak,
    IKubbPalette.amber,
    IKubbPalette.birch,
  ];

  final double x, speed, sway, phase, spin, sizeFactor;
  final bool isLeaf;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter(this.particles, this.t);

  final List<_Particle> particles;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final fadeOut = (1 - t).clamp(0.0, 0.3) / 0.3;
    for (final p in particles) {
      final y = (-0.1 + t * p.speed * 1.3) * size.height;
      if (y > size.height) continue;
      final x = (p.x + math.sin(t * 8 + p.phase) * p.sway) * size.width;
      final paint = Paint()
        ..color = p.color.withValues(alpha: fadeOut)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.phase + t * p.spin);
      if (p.isLeaf) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.sizeFactor,
            height: p.sizeFactor * 0.55,
          ),
          paint,
        );
      } else {
        // A minimal rune-like stroke pair.
        final h = p.sizeFactor;
        canvas.drawLine(Offset(0, -h / 2), Offset(0, h / 2), paint);
        canvas.drawLine(Offset(0, -h / 4), Offset(h / 2, 0), paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => oldDelegate.t != t;
}
