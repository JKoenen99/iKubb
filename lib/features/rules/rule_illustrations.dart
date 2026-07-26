import 'package:flutter/material.dart';

import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../game/pin_diagram.dart';
import '../kubb/kubb_field.dart';
import '../setup/player.dart' show playerColors;

/// One small, text-free illustration per rule card — the visual carries
/// the rule so nobody has to parse prose alone. All code-drawn in the
/// brand palette; shared between the rules panel and the tour.
Widget? ruleIllustration(String ruleId) => switch (ruleId) {
  'formation' => const PinDiagram(selected: {}, onToggle: null, pinSize: 34),
  'pinsStand' => const _ScatteredPins(),
  'turns' => const _AlternatingTurns(),
  'underhand' => const _UnderhandThrow(),
  'onePin' => const _ScoreExample(pins: [7], score: 7),
  'manyPins' => const _ScoreExample(pins: [7, 9, 12], score: 3),
  'leaning' => const _LeaningPin(),
  'overshoot' => const OvershootIllustration(),
  'misses' => const MissDotsIllustration(),
  'exact' => const _ExactTarget(),
  'lastStanding' => const _LastStanding(),
  'teams' => const _TeamClusters(),
  // Classic kubb — drawn with the same wooden blocks as the /kubb field.
  'kubbField' => const KubbFieldSchematic(),
  'kubbTeams' => const _TeamClusters(),
  'kubbBatons' => const _BatonRow(),
  'kubbThrowIn' => const _ThrowInArc(),
  'kubbFieldFirst' => const _FieldFirstOrder(),
  'kubbPenalty' => const _PenaltyKubb(),
  'kubbAdvantage' => const _AdvantageIllustration(),
  'kubbKing' => const _KingWins(),
  'kubbEarlyKing' => const _EarlyKingLoses(),
  'kubbMatch' => const _MatchDots(),
  _ => null,
};

/// A single wooden pin, reusing the game's pin look at illustration scale.
class _MiniPin extends StatelessWidget {
  const _MiniPin({
    this.number,
    this.fallen = false,
    this.angle = 0,
    this.size = 34,
  });

  final int? number;
  final bool fallen;
  final double angle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fallen ? IKubbPalette.walnut : IKubbPalette.oak,
          shape: BoxShape.circle,
          border: Border.all(
            color: fallen
                ? IKubbPalette.ink.withValues(alpha: 0.55)
                : IKubbPalette.walnut,
            width: 2,
          ),
        ),
        child: number == null
            ? null
            : Center(
                child: Container(
                  width: size * 0.58,
                  height: size * 0.58,
                  decoration: const BoxDecoration(
                    color: IKubbPalette.birchLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: IKubbType.score(
                        size: size * 0.34,
                        color: IKubbPalette.ink,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: IKubbPalette.forest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: IKubbType.score(size: 16, color: IKubbPalette.birchLight),
    ),
  );
}

/// Pins stood back up where they fell: an uneven, drifted formation.
class _ScatteredPins extends StatelessWidget {
  const _ScatteredPins();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: 190,
      child: Stack(
        children: const [
          Positioned(left: 6, top: 26, child: _MiniPin(size: 28)),
          Positioned(left: 52, top: 2, child: _MiniPin(size: 28)),
          Positioned(left: 88, top: 36, child: _MiniPin(size: 28)),
          Positioned(left: 128, top: 10, child: _MiniPin(size: 28)),
          Positioned(left: 158, top: 40, child: _MiniPin(size: 28)),
        ],
      ),
    );
  }
}

/// Sides throw in a fixed alternating order.
class _AlternatingTurns extends StatelessWidget {
  const _AlternatingTurns();

  @override
  Widget build(BuildContext context) {
    Widget dot(int colorIndex) => Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: playerColors[colorIndex],
        shape: BoxShape.circle,
        border: Border.all(color: IKubbPalette.birchLight, width: 2),
      ),
    );
    const arrow = Icon(
      Icons.arrow_forward,
      size: 20,
      color: IKubbPalette.walnut,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot(0),
        const SizedBox(width: 6),
        arrow,
        const SizedBox(width: 6),
        dot(1),
        const SizedBox(width: 6),
        arrow,
        const SizedBox(width: 6),
        dot(0),
      ],
    );
  }
}

/// The stick flies underhand: a low-to-high arc.
class _UnderhandThrow extends StatelessWidget {
  const _UnderhandThrow();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 150,
    height: 64,
    child: CustomPaint(painter: _UnderhandPainter()),
  );
}

class _UnderhandPainter extends CustomPainter {
  const _UnderhandPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = IKubbPalette.pine;
    final path = Path()
      ..moveTo(8, size.height - 10)
      ..quadraticBezierTo(
        size.width * 0.45,
        -18,
        size.width - 26,
        size.height * 0.42,
      );
    canvas.drawPath(path, arc);
    // Arrow head.
    canvas.drawLine(
      Offset(size.width - 26, size.height * 0.42),
      Offset(size.width - 38, size.height * 0.30),
      arc,
    );
    canvas.drawLine(
      Offset(size.width - 26, size.height * 0.42),
      Offset(size.width - 42, size.height * 0.46),
      arc,
    );
    // The stick, mid-flight.
    final stick = Paint()
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = IKubbPalette.walnut;
    canvas.save();
    canvas.translate(size.width * 0.42, size.height * 0.28);
    canvas.rotate(-0.5);
    canvas.drawLine(const Offset(-16, 0), const Offset(16, 0), stick);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_UnderhandPainter oldDelegate) => false;
}

/// N pins down → the resulting score, side by side.
class _ScoreExample extends StatelessWidget {
  const _ScoreExample({required this.pins, required this.score});

  final List<int> pins;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final pin in pins)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _MiniPin(number: pin, fallen: true, angle: 0.5),
          ),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_forward, size: 20, color: IKubbPalette.walnut),
        const SizedBox(width: 10),
        _ScoreChip('+$score'),
      ],
    );
  }
}

/// A pin resting on another doesn't count.
class _LeaningPin extends StatelessWidget {
  const _LeaningPin();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 64,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Positioned(left: 24, bottom: 0, child: _MiniPin()),
          Positioned(left: 46, bottom: 10, child: const _MiniPin(angle: 0.85)),
          Positioned(
            right: 8,
            top: 0,
            child: Icon(
              Icons.cancel,
              size: 26,
              color: IKubbPalette.danger(Theme.of(context).brightness),
            ),
          ),
        ],
      ),
    );
  }
}

/// The classic overshoot example: 47 + 8 falls back to 25.
class OvershootIllustration extends StatelessWidget {
  const OvershootIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final style = IKubbType.score(
      size: 28,
      color: Theme.of(context).colorScheme.onSurface,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('47 + 8', style: style),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.arrow_forward, size: 26, color: IKubbPalette.amber),
        ),
        Text('25', style: style.copyWith(color: IKubbPalette.amber)),
      ],
    );
  }
}

/// Three misses in a row.
class MissDotsIllustration extends StatelessWidget {
  const MissDotsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.circle,
              size: 18,
              color: IKubbPalette.danger(Theme.of(context).brightness),
            ),
          ),
      ],
    );
  }
}

/// Exactly the target wins.
class _ExactTarget extends StatelessWidget {
  const _ExactTarget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '50',
          style: IKubbType.score(
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.emoji_events, size: 28, color: IKubbPalette.oak),
      ],
    );
  }
}

/// Everyone else eliminated: the last side standing wins.
class _LastStanding extends StatelessWidget {
  const _LastStanding();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 66,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            bottom: 0,
            child: const _MiniPin(fallen: true, angle: 1.1),
          ),
          Positioned(
            left: 44,
            bottom: 2,
            child: const _MiniPin(fallen: true, angle: 0.9),
          ),
          const Positioned(left: 84, bottom: 0, child: _MiniPin()),
          const Positioned(
            left: 88,
            top: 0,
            child: Icon(Icons.emoji_events, size: 22, color: IKubbPalette.oak),
          ),
        ],
      ),
    );
  }
}

/// The kubb field in miniature: two baselines of five, the king alone in
/// the middle. Public: the tour's kubb branch opens with it at full size.
class KubbFieldSchematic extends StatelessWidget {
  const KubbFieldSchematic({super.key, this.scale = 1});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KubbBlockRow(
          standing: 5,
          felled: 0,
          blockWidth: 16 * scale,
          blockHeight: 22 * scale,
        ),
        SizedBox(height: 14 * scale),
        const KubbKing(),
        SizedBox(height: 14 * scale),
        KubbBlockRow(
          standing: 5,
          felled: 0,
          blockWidth: 16 * scale,
          blockHeight: 22 * scale,
        ),
      ],
    );
  }
}

/// The six batons of a turn.
class _BatonRow extends StatelessWidget {
  const _BatonRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 6; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Transform.rotate(
              angle: 0.35,
              child: Container(
                width: 7,
                height: 34,
                decoration: BoxDecoration(
                  color: IKubbPalette.walnut,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A felled kubb arcs back into the other half and stands up again.
class _ThrowInArc extends StatelessWidget {
  const _ThrowInArc();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KubbBlock(felled: true),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.redo, size: 28, color: IKubbPalette.pine),
        ),
        KubbBlock(),
      ],
    );
  }
}

/// Field kubbs are target number one, the baseline number two.
class _FieldFirstOrder extends StatelessWidget {
  const _FieldFirstOrder();

  @override
  Widget build(BuildContext context) {
    Widget numbered(Widget block, String label) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [block, const SizedBox(height: 4), _ScoreChip(label)],
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numbered(const KubbBlock(width: 22, height: 30), '1'),
        const Padding(
          padding: EdgeInsets.only(bottom: 26, left: 8, right: 8),
          child: Icon(
            Icons.arrow_forward,
            size: 20,
            color: IKubbPalette.walnut,
          ),
        ),
        numbered(const KubbBlock(), '2'),
      ],
    );
  }
}

/// Thrown out twice: the kubb becomes a penalty placement.
class _PenaltyKubb extends StatelessWidget {
  const _PenaltyKubb();

  @override
  Widget build(BuildContext context) {
    final danger = IKubbPalette.danger(Theme.of(context).brightness);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const KubbBlock(felled: true),
        const SizedBox(width: 10),
        Icon(Icons.cancel, size: 24, color: danger),
        Icon(Icons.cancel, size: 24, color: danger),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_forward, size: 20, color: IKubbPalette.walnut),
        const SizedBox(width: 10),
        const KubbBlock(),
        const KubbKing(),
      ],
    );
  }
}

/// A field kubb ahead of the baseline marks the new throwing line.
class _AdvantageIllustration extends StatelessWidget {
  const _AdvantageIllustration();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 190,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KubbBlock(),
          SizedBox(height: 4),
          AdvantageLine(label: '→'),
        ],
      ),
    );
  }
}

/// A rightful king throw wins.
class _KingWins extends StatelessWidget {
  const _KingWins();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KubbKing(),
        SizedBox(width: 12),
        Icon(Icons.emoji_events, size: 30, color: IKubbPalette.oak),
      ],
    );
  }
}

/// The king down too soon: instant loss.
class _EarlyKingLoses extends StatelessWidget {
  const _EarlyKingLoses();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(angle: 0.9, child: const KubbKing()),
        const SizedBox(width: 12),
        Icon(
          Icons.cancel,
          size: 28,
          color: IKubbPalette.danger(Theme.of(context).brightness),
        ),
      ],
    );
  }
}

/// Best-of-three match dots: two games taken, one to spare.
class _MatchDots extends StatelessWidget {
  const _MatchDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              i < 2 ? Icons.circle : Icons.circle_outlined,
              size: 20,
              color: IKubbPalette.amber,
            ),
          ),
      ],
    );
  }
}

/// Two team clusters in identity colors.
class _TeamClusters extends StatelessWidget {
  const _TeamClusters();

  @override
  Widget build(BuildContext context) {
    Widget dot(int colorIndex) => Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: playerColors[colorIndex],
        shape: BoxShape.circle,
        border: Border.all(color: IKubbPalette.birchLight, width: 2),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [dot(0), dot(0)]),
            dot(0),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'vs',
            style: IKubbType.heading(
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Column(
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [dot(1), dot(1)]),
            dot(1),
          ],
        ),
      ],
    );
  }
}
