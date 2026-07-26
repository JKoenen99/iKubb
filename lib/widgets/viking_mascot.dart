import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palette.dart';

enum MascotPose { idle, cheer, oops }

/// The iKubb Viking mascot as code-drawn vector art: flat shapes, chunky
/// rounded linework, brand palette, no text (SPEC.md §4).
///
/// Poses are state-driven and spring between each other ([MascotPose.cheer]
/// raises the arms and stick). Deliberately no looping animation — motion
/// only decorates state changes (§3.7); a Rive state machine can replace
/// this painter later without changing call sites.
class VikingMascot extends StatelessWidget {
  const VikingMascot({super.key, this.pose = MascotPose.idle, this.size = 120});

  final MascotPose pose;
  final double size;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 450);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: pose == MascotPose.cheer ? 1.0 : 0.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, cheer, _) => TweenAnimationBuilder<double>(
        tween: Tween(end: pose == MascotPose.oops ? 1.0 : 0.0),
        duration: duration,
        curve: Curves.easeOut,
        // Center loosens tight constraints (e.g. stretch columns) so the
        // painter's box is always exactly [size] — it must never scale to
        // a forced width and paint outside its bounds.
        builder: (context, oops, _) => Center(
          child: SizedBox.square(
            dimension: size,
            child: CustomPaint(
              size: Size.square(size),
              painter: _VikingPainter(cheer: cheer, oops: oops),
            ),
          ),
        ),
      ),
    );
  }
}

class _VikingPainter extends CustomPainter {
  const _VikingPainter({required this.cheer, this.oops = 0});

  /// 0 = idle (arms down), 1 = full cheer (arms and stick raised).
  final double cheer;

  /// 0 = normal, 1 = full wince: frown, slight sag and tilt.
  final double oops;

  static const _skin = Color(0xFFF0C9A5);
  static const _cheek = Color(0x33A84A3F);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    canvas.scale(s);
    final fill = Paint()..style = PaintingStyle.fill;

    // Cheer lifts the whole figure a touch; oops sags and tilts it.
    canvas.translate(0, 2 - 2 * cheer + 2.5 * oops);
    if (oops > 0) {
      canvas.translate(50, 50);
      canvas.rotate(0.07 * oops);
      canvas.translate(-50, -50);
    }

    // Boots.
    fill.color = IKubbPalette.walnut;
    canvas.drawRRect(
      RRect.fromLTRBR(38, 88, 47, 96, const Radius.circular(4)),
      fill,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(53, 88, 62, 96, const Radius.circular(4)),
      fill,
    );

    // Tunic.
    fill.color = IKubbPalette.forest;
    canvas.drawRRect(
      RRect.fromLTRBR(33, 58, 67, 90, const Radius.circular(14)),
      fill,
    );
    // Belt.
    fill.color = IKubbPalette.oak;
    canvas.drawRRect(
      RRect.fromLTRBR(33, 74, 67, 80, const Radius.circular(3)),
      fill,
    );

    // Arms: rotate from hanging (idle) to raised (cheer).
    final armAngle = _lerp(0.35, -2.35, cheer); // radians from vertical-down
    _arm(canvas, const Offset(35, 62), armAngle, holdsStick: false);
    _arm(canvas, const Offset(65, 62), -armAngle, holdsStick: true);

    // Head.
    fill.color = _skin;
    canvas.drawCircle(const Offset(50, 40), 15, fill);

    // Beard: lower half of the face, with two braid tips.
    fill.color = IKubbPalette.oak;
    final beard = Path()
      ..addArc(
        Rect.fromCircle(center: const Offset(50, 42), radius: 15.5),
        0,
        math.pi,
      )
      ..close();
    canvas.drawPath(beard, fill);
    canvas.drawCircle(const Offset(41, 58), 3.4, fill);
    canvas.drawCircle(const Offset(59, 58), 3.4, fill);

    // Mouth: happy arc normally, flipped to a wince when oops.
    final mouthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..color = IKubbPalette.ink;
    if (oops > 0.5) {
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(50, 50.5), radius: 4.5),
        math.pi + 0.3,
        math.pi - 0.6,
        false,
        mouthPaint,
      );
    } else {
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(50, 46), radius: 4.5),
        0.3,
        math.pi - 0.6,
        false,
        mouthPaint,
      );
    }

    // Eyes and cheeks.
    fill.color = IKubbPalette.ink;
    canvas.drawCircle(const Offset(44.5, 38), 1.8, fill);
    canvas.drawCircle(const Offset(55.5, 38), 1.8, fill);
    fill.color = _cheek;
    canvas.drawCircle(const Offset(41, 43), 2.6, fill);
    canvas.drawCircle(const Offset(59, 43), 2.6, fill);

    // Helmet dome + rim.
    fill.color = IKubbPalette.forestDeep;
    canvas.drawPath(
      Path()
        ..addArc(
          Rect.fromCircle(center: const Offset(50, 36), radius: 15),
          math.pi,
          math.pi,
        )
        ..close(),
      fill,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(34, 33, 66, 38, const Radius.circular(2.5)),
      fill,
    );

    // Horns.
    fill.color = IKubbPalette.birchLight;
    canvas.drawPath(
      Path()
        ..moveTo(34, 34)
        ..quadraticBezierTo(26, 30, 27, 20)
        ..quadraticBezierTo(33, 26, 37, 30)
        ..close(),
      fill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(66, 34)
        ..quadraticBezierTo(74, 30, 73, 20)
        ..quadraticBezierTo(67, 26, 63, 30)
        ..close(),
      fill,
    );
  }

  /// One arm as a rounded capsule rotating around the shoulder; the right
  /// hand holds the throwing stick.
  void _arm(
    Canvas canvas,
    Offset shoulder,
    double angle, {
    required bool holdsStick,
  }) {
    canvas.save();
    canvas.translate(shoulder.dx, shoulder.dy);
    canvas.rotate(angle);
    final fill = Paint()..color = IKubbPalette.forest;
    canvas.drawRRect(
      RRect.fromLTRBR(-3.5, 0, 3.5, 18, const Radius.circular(3.5)),
      fill,
    );
    // Hand.
    fill.color = _skin;
    canvas.drawCircle(const Offset(0, 18), 4, fill);
    if (holdsStick) {
      fill.color = IKubbPalette.walnut;
      canvas.drawRRect(
        RRect.fromLTRBR(-2.5, 8, 2.5, 34, const Radius.circular(2.5)),
        fill,
      );
    }
    canvas.restore();
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(_VikingPainter oldDelegate) =>
      oldDelegate.cheer != cheer || oldDelegate.oops != oops;
}
