import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';

/// Number-pad scoring (SPEC.md §3.3): one tap scores the throw. The pad
/// still carries the safety rails of pin-tap mode as color: the exact
/// winning score is highlighted, scores that would overshoot are amber.
class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.pointsNeeded,
    required this.overshootPenalty,
    required this.onScore,
  });

  /// Points the active side needs exactly; scores above it bust.
  final int pointsNeeded;

  /// Whether overshooting carries a penalty (colors the busting scores).
  final bool overshootPenalty;

  final ValueChanged<int> onScore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var score = 1; score <= 12; score++)
              SizedBox(
                width: 68,
                height: 60,
                child: _scoreButton(context, score),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 220,
          height: 56,
          child: FilledButton.tonal(
            onPressed: () => onScore(0),
            child: Text(l10n.miss),
          ),
        ),
      ],
    );
  }

  Widget _scoreButton(BuildContext context, int score) {
    final wins = score == pointsNeeded;
    final busts = overshootPenalty && score > pointsNeeded;
    final style = wins
        ? FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          )
        : busts
        ? FilledButton.styleFrom(
            backgroundColor: IKubbPalette.amber,
            foregroundColor: IKubbPalette.ink,
          )
        : null;
    final button = wins || busts
        ? FilledButton(
            style: style,
            onPressed: () => onScore(score),
            child: Text('$score'),
          )
        : FilledButton.tonal(
            onPressed: () => onScore(score),
            child: Text('$score'),
          );
    return button;
  }
}
