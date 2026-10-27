import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The one way to head a content section (setup, stats, settings): a
/// bold title, an optional small detail ("2 players") and an optional
/// trailing action ("Shuffle order", "Reset").
class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.text, {
    super.key,
    this.padded = false,
    this.detail,
    this.trailing,
  });

  final String text;

  /// Vertical breathing room for list contexts.
  final bool padded;

  /// Small secondary text after the title.
  final String? detail;

  /// An action on the trailing edge.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget title = Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
    if (detail != null || trailing != null) {
      // Title and detail give way (ellipsis) before the action does, so
      // the row never overflows at large text sizes or in narrow columns.
      title = Row(
        children: [
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (detail != null) ...[
            const SizedBox(width: KaatoSpacing.sm),
            Flexible(
              child: Text(
                detail!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: KaatoAlpha.faded,
                  ),
                ),
              ),
            ),
          ],
          const Spacer(),
          ?trailing,
        ],
      );
    }
    if (!padded) return title;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KaatoSpacing.sm),
      child: title,
    );
  }
}
