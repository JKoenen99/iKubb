import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// One option of an [AdaptiveChoice].
class ChoiceOption<T> {
  const ChoiceOption({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// The one way to pick one of a few options.
///
/// Renders a [SegmentedButton] at normal text sizes and switches to a
/// wrapping row of [ChoiceChip]s once Dynamic Type grows past the point
/// where fixed-width segments clip or overflow (HIG: controls must stay
/// usable at every text size; WCAG 1.4.4). Both forms expose the same
/// selected/button semantics and the same ≥44pt hit targets.
class AdaptiveChoice<T> extends StatelessWidget {
  const AdaptiveChoice({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<ChoiceOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Scale above which segments give way to wrapping chips. 1.3× is where
  /// three-label rows stop fitting a 390pt phone with the standard gutters.
  static const double wrapAbove = 1.3;

  static bool shouldWrap(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(_referenceSize) / _referenceSize >
      wrapAbove;

  /// Body size used to derive the effective text scale.
  static const double _referenceSize = 16;

  @override
  Widget build(BuildContext context) {
    if (shouldWrap(context)) {
      return Wrap(
        spacing: IKubbSpacing.sm,
        runSpacing: IKubbSpacing.xs,
        children: [
          for (final o in options)
            ChoiceChip(
              avatar: o.icon == null
                  ? null
                  : Icon(o.icon, size: IKubbIconSize.sm),
              label: Text(o.label),
              selected: o.value == selected,
              showCheckmark: false,
              onSelected: (_) => onSelected(o.value),
            ),
        ],
      );
    }
    return SegmentedButton<T>(
      showSelectedIcon: false,
      segments: [
        for (final o in options)
          ButtonSegment(
            value: o.value,
            label: Text(o.label),
            icon: o.icon == null ? null : Icon(o.icon, size: IKubbIconSize.sm),
          ),
      ],
      selected: {selected},
      onSelectionChanged: (s) {
        if (s.first != selected) onSelected(s.first);
      },
    );
  }
}
