import 'package:flutter/material.dart';

import '../../theme/palette.dart';
import '../../theme/typography.dart';

/// A wooden kubb block in the game's visual language: oak standing,
/// walnut when (marked as) felled — the same wood grammar as the pins.
class KubbBlock extends StatelessWidget {
  const KubbBlock({
    super.key,
    this.felled = false,
    this.selected = false,
    this.width = 26,
    this.height = 36,
    this.onTap,
  });

  final bool felled;

  /// Marked to fall with the current baton (pending confirmation).
  final bool selected;
  final double width;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final down = felled || selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        width: width,
        height: height,
        margin: const EdgeInsets.all(3),
        transform: Matrix4.rotationZ(down ? 0.6 : 0),
        transformAlignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: down ? IKubbPalette.walnut : IKubbPalette.oak,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: down ? IKubbPalette.birch : IKubbPalette.walnut,
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// The king: taller, forest-deep, crowned. Toppling it decides the game.
class KubbKing extends StatelessWidget {
  const KubbKing({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 54,
        decoration: BoxDecoration(
          color: IKubbPalette.forestDeep,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: IKubbPalette.oak, width: 2),
        ),
        child: const Icon(
          Icons.workspace_premium,
          color: IKubbPalette.amber,
          size: 22,
        ),
      ),
    );
  }
}

/// A row of identical blocks: [standing] tappable/selectable, [felled]
/// rendered as down. Selection is index-based within the standing set.
class KubbBlockRow extends StatelessWidget {
  const KubbBlockRow({
    super.key,
    required this.standing,
    required this.felled,
    this.selectedIndices = const {},
    this.onToggle,
    this.blockWidth = 26,
    this.blockHeight = 36,
  });

  final int standing;
  final int felled;
  final Set<int> selectedIndices;
  final ValueChanged<int>? onToggle;
  final double blockWidth;
  final double blockHeight;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (var i = 0; i < standing; i++)
          KubbBlock(
            selected: selectedIndices.contains(i),
            width: blockWidth,
            height: blockHeight,
            onTap: onToggle == null ? null : () => onToggle!(i),
          ),
        for (var i = 0; i < felled; i++)
          KubbBlock(felled: true, width: blockWidth, height: blockHeight),
      ],
    );
  }
}

/// The dashed advantage line with its label chip.
class AdvantageLine extends StatelessWidget {
  const AdvantageLine({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _DashedLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: IKubbPalette.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: IKubbType.heading(size: 12, color: IKubbPalette.ink),
            ),
          ),
        ),
        const Expanded(child: _DashedLine()),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(double.infinity, 2),
    painter: _DashPainter(),
  );
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = IKubbPalette.amber
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var x = 0.0; x < size.width; x += 12) {
      canvas.drawLine(Offset(x, 1), Offset(x + 6, 1), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => false;
}
