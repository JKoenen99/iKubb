import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../../theme/tokens.dart';

/// The 12 pins in their official diamond formation. Tap to toggle which pins
/// fell this throw. Selection wobbles the pin over — state updates
/// instantly, the motion only decorates it (SPEC.md §3.7).
class PinDiagram extends StatelessWidget {
  const PinDiagram({
    super.key,
    required this.selected,
    required this.onToggle,
    this.pinSize = 60,
  });

  /// Pin rows exactly as on the rules sheet.
  static const formation = [
    [7, 9, 8],
    [5, 11, 12, 6],
    [3, 10, 4],
    [1, 2],
  ];

  final Set<int> selected;

  /// Null renders a static, non-interactive diagram (e.g. in rule cards).
  final ValueChanged<int>? onToggle;

  /// Diameter of one pin; the default suits the scoring screen.
  final double pinSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in formation)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final pin in row)
                _Pin(
                  number: pin,
                  isDown: selected.contains(pin),
                  onTap: onToggle == null ? null : () => onToggle!(pin),
                  size: pinSize,
                ),
            ],
          ),
      ],
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({
    required this.number,
    required this.isDown,
    required this.onTap,
    required this.size,
  });

  final int number;
  final bool isDown;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Wooden pins in both themes (UX audit #3/#8): standing = light oak,
    // fallen = dark walnut; the number sits on a painted birch disc, like
    // a number painted on the wood.
    return Semantics(
      button: onTap != null,
      label: AppLocalizations.of(context)!.pinSemantics(number),
      selected: isDown,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: IKubbMotion.resolve(context, IKubbMotion.base),
          curve: IKubbMotion.emphasized,
          width: size,
          height: size,
          margin: EdgeInsets.all(size / 12),
          transform: Matrix4.rotationZ(isDown ? 0.35 : 0),
          transformAlignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: isDown ? IKubbPalette.walnut : IKubbPalette.oak,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDown ? IKubbPalette.birch : IKubbPalette.walnut,
              width: 2.5,
            ),
          ),
          child: Center(
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
      ),
    );
  }
}
