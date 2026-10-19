import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

/// Storybook-style documentation blocks for the design-system page: a
/// [Story] documents one component (what it is, where it is used, its
/// props, its variants on a neutral canvas, and its accessibility
/// contract). Foundations use the same canvas.

/// One documented constructor parameter.
class Prop {
  const Prop(this.name, this.type, this.note);

  final String name;
  final String type;
  final String note;
}

/// One rendered state of a component.
class Variant {
  const Variant(this.label, this.child, {this.note, this.background});

  /// Short state name ("Selected", "Disabled", "Dark fill").
  final String label;
  final Widget child;

  /// What to look for, or the rule the state follows.
  final String? note;

  /// Canvas color when the component is meant for a non-surface context
  /// (overlay buttons on the forest scrim, glass over wood).
  final Color? background;
}

/// A neutral canvas: the theme surface with a soft line around it, so the
/// component's own edges and fills are what you see.
class StoryCanvas extends StatelessWidget {
  const StoryCanvas({
    super.key,
    required this.child,
    this.background,
    this.padding = const EdgeInsets.all(IKubbSpacing.lg),
  });

  final Widget child;
  final Color? background;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? scheme.surface,
        borderRadius: BorderRadius.circular(IKubbRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}

/// The documentation block of one component.
class Story extends StatelessWidget {
  const Story({
    super.key,
    required this.name,
    required this.source,
    required this.summary,
    this.usedIn,
    this.props = const [],
    this.variants = const [],
    this.a11y,
  });

  /// Class or function name as written in code.
  final String name;

  /// Where it lives, relative to `lib/`.
  final String source;

  /// What it is and when to reach for it (two or three sentences).
  final String summary;

  /// The screens or flows that use it.
  final String? usedIn;

  final List<Prop> props;
  final List<Variant> variants;

  /// The accessibility contract: semantics, tap size, contrast, motion.
  final String? a11y;

  static const code = TextStyle(
    fontFamily: 'monospace',
    fontFamilyFallback: ['Menlo', 'Courier New', 'monospace'],
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final faded = theme.colorScheme.onSurface.withValues(
      alpha: IKubbAlpha.faded,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: IKubbSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: IKubbSpacing.md,
            children: [
              Text(name, style: Story.code.copyWith(fontSize: 16)),
              Text(source, style: IKubbType.caption.copyWith(color: faded)),
            ],
          ),
          const SizedBox(height: IKubbSpacing.xs),
          Text(summary, style: theme.textTheme.bodyMedium),
          if (usedIn != null) ...[
            const SizedBox(height: IKubbSpacing.xs),
            Text(
              'Used in: $usedIn',
              style: IKubbType.caption.copyWith(color: faded),
            ),
          ],
          if (props.isNotEmpty) ...[
            const SizedBox(height: IKubbSpacing.md),
            _PropsTable(props),
          ],
          for (final v in variants) ...[
            const SizedBox(height: IKubbSpacing.md),
            Text(
              v.label,
              style: IKubbType.caption.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: IKubbSpacing.xs),
            StoryCanvas(background: v.background, child: v.child),
            if (v.note != null) ...[
              const SizedBox(height: IKubbSpacing.xs),
              Text(v.note!, style: IKubbType.caption.copyWith(color: faded)),
            ],
          ],
          if (a11y != null) ...[
            const SizedBox(height: IKubbSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.accessibility_new,
                  size: IKubbIconSize.sm,
                  color: faded,
                ),
                const SizedBox(width: IKubbSpacing.sm),
                Expanded(
                  child: Text(
                    a11y!,
                    style: IKubbType.caption.copyWith(color: faded),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PropsTable extends StatelessWidget {
  const _PropsTable(this.props);

  final List<Prop> props;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final faded = scheme.onSurface.withValues(alpha: IKubbAlpha.faded);
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(5),
      },
      border: TableBorder(
        horizontalInside: BorderSide(color: scheme.outlineVariant),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        for (final p in props)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: IKubbSpacing.xs),
                child: Text(p.name, style: Story.code),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: IKubbSpacing.xs,
                  horizontal: IKubbSpacing.xs,
                ),
                child: Text(
                  p.type,
                  style: IKubbType.caption.copyWith(color: faded),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: IKubbSpacing.xs),
                child: Text(p.note, style: IKubbType.caption),
              ),
            ],
          ),
      ],
    );
  }
}

/// A foundations entry: a token name, its value and a swatch or sample.
class TokenRow extends StatelessWidget {
  const TokenRow({
    super.key,
    required this.name,
    required this.value,
    required this.sample,
  });

  final String name;
  final String value;
  final Widget sample;

  @override
  Widget build(BuildContext context) {
    final faded = Theme.of(context).colorScheme.onSurface
        .withValues(alpha: IKubbAlpha.faded);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: IKubbSpacing.xs),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(name, style: Story.code)),
          SizedBox(
            width: 72,
            child: Text(value, style: IKubbType.caption.copyWith(color: faded)),
          ),
          Expanded(child: sample),
        ],
      ),
    );
  }
}
