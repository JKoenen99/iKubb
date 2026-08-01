import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The one way to head a content section (setup, stats, settings).
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.padded = false});

  final String text;

  /// Vertical breathing room for list contexts.
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
    if (!padded) return title;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: IKubbSpacing.sm),
      child: title,
    );
  }
}
