import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';

/// The animated per-side card used by both standings strips: identity
/// color fill when the side is up, quiet surface otherwise.
class ActiveSideCard extends StatelessWidget {
  const ActiveSideCard({
    super.key,
    required this.isActive,
    required this.child,
  });

  final bool isActive;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: IKubbMotion.resolve(context, IKubbMotion.base),
      curve: IKubbMotion.standard,
      margin: const EdgeInsets.symmetric(horizontal: IKubbSpacing.xs),
      padding: const EdgeInsets.all(IKubbSpacing.md),
      decoration: BoxDecoration(
        color: isActive ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(IKubbRadius.lg),
      ),
      child: child,
    );
  }
}

/// Identity dot + ellipsized name — the one way a side is titled. The dot
/// is decorative (the name carries the identity for assistive tech).
class ColorDotName extends StatelessWidget {
  const ColorDotName({
    super.key,
    required this.color,
    required this.name,
    required this.textColor,
  });

  final Color color;
  final String name;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExcludeSemantics(
          child: Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(right: IKubbSpacing.sm),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: IKubbPalette.birchLight,
                width: IKubbBorder.hairline,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: IKubbType.emphasis.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
