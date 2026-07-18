import 'package:flutter/material.dart';

import '../../theme/palette.dart';

/// The 12 pins in their official diamond formation. Tap to toggle which pins
/// fell this throw. Selection wobbles the pin over — state updates
/// instantly, the motion only decorates it (SPEC.md §3.7).
class PinDiagram extends StatelessWidget {
  const PinDiagram({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  /// Pin rows exactly as on the rules sheet.
  static const formation = [
    [7, 9, 8],
    [5, 11, 12, 6],
    [3, 10, 4],
    [1, 2],
  ];

  final Set<int> selected;
  final ValueChanged<int> onToggle;

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
                  onTap: () => onToggle(pin),
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
  });

  final int number;
  final bool isDown;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Pin $number',
      selected: isDown,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          width: 60,
          height: 60,
          margin: const EdgeInsets.all(5),
          transform: Matrix4.rotationZ(isDown ? 0.35 : 0),
          transformAlignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: isDown ? IKubbPalette.oak : scheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDown ? IKubbPalette.walnut : scheme.primary,
              width: 2.5,
            ),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDown ? IKubbPalette.ink : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
