import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/palette.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'adaptive_choice.dart';

/// The card-based form language of the New game redesign, shared by setup,
/// settings and the design-system page: quiet surface cards with a
/// title/subtitle pair and one control, selection cards with a radio dot,
/// circular steppers, dashed "add" buttons, avatar pills.

/// A quiet card surface (surfaceContainerHighest, 16pt corners), the
/// container behind every form row.
class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: IKubbSpacing.lg,
      vertical: IKubbSpacing.md,
    ),
    this.borderColor,
    this.color,
    this.margin = const EdgeInsets.only(bottom: IKubbSpacing.sm),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? color;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(IKubbRadius.lg),
      side: borderColor == null
          ? BorderSide.none
          : BorderSide(color: borderColor!, width: IKubbBorder.hairline),
    );
    return Padding(
      padding: margin,
      child: Material(
        color: color ?? scheme.surfaceContainerHighest,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Title + optional subtitle, the text half of most form rows.
class FormLabel extends StatelessWidget {
  const FormLabel({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
  });

  final String title;
  final String? subtitle;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: IKubbType.cardTitle.copyWith(
            fontSize: IKubbType.stepLabel,
            color: titleColor,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: IKubbSpacing.xxs),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: IKubbAlpha.faded),
            ),
          ),
        ],
      ],
    );
  }
}

/// A row card: label on the left, one control on the right. With [onTap]
/// and no [trailing] it shows a disclosure chevron (opens a sheet).
class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FormCard(
      onTap: onTap,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: IKubbSpacing.md),
          ],
          Expanded(
            child: FormLabel(title: title, subtitle: subtitle),
          ),
          const SizedBox(width: IKubbSpacing.md),
          trailing ??
              (onTap == null
                  ? const SizedBox.shrink()
                  : Icon(Icons.chevron_right, color: scheme.onSurface)),
        ],
      ),
    );
  }
}

/// A toggle row (platform-adaptive switch).
class SwitchCard extends StatelessWidget {
  const SwitchCard({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final bool value;

  /// Null renders the row disabled (switch greyed, card not tappable).
  final ValueChanged<bool>? onChanged;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    // One semantics node: "Haptics, switch, on" instead of a label and an
    // unnamed toggle side by side.
    final onChanged = this.onChanged;
    return MergeSemantics(
      child: SettingCard(
        title: title,
        subtitle: subtitle,
        leading: leading,
        onTap: onChanged == null ? null : () => onChanged(!value),
        trailing: Switch.adaptive(value: value, onChanged: onChanged),
      ),
    );
  }
}

/// A selectable option card with a radio dot: the selected one carries
/// the accent border and a filled dot (the "Game" picker).
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      child: FormCard(
        onTap: onTap,
        margin: EdgeInsets.zero,
        borderColor: selected ? scheme.primary : null,
        color: selected
            ? Color.alphaBlend(
                scheme.primary.withValues(alpha: IKubbAlpha.choiceTint),
                scheme.surfaceContainerHighest,
              )
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: IKubbSpacing.xxs),
              child: ExcludeSemantics(
                child: Container(
                  width: IKubbIconSize.md,
                  height: IKubbIconSize.md,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? scheme.primary : null,
                    border: selected
                        ? null
                        : Border.all(
                            color: scheme.onSurface.withValues(
                              alpha: IKubbAlpha.faded,
                            ),
                            width: IKubbBorder.hairline,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: IKubbSpacing.md),
            Expanded(
              child: FormLabel(title: title, subtitle: subtitle),
            ),
          ],
        ),
      ),
    );
  }
}

/// − value + on a card, with circular buttons. [format] renders the value
/// (e.g. "Off" for 0). Tapping the value opens a dialog to type one.
class StepperCard extends StatelessWidget {
  const StepperCard({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.format,
    this.editTitle,
    this.decreaseLabel,
    this.increaseLabel,
    this.cancelLabel,
    this.doneLabel,
  });

  final String title;
  final String? subtitle;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final String Function(int value)? format;

  /// Dialog title for typing a value; null disables the tap-to-edit.
  final String? editTitle;
  final String? decreaseLabel;
  final String? increaseLabel;
  final String? cancelLabel;
  final String? doneLabel;

  Future<void> _edit(BuildContext context) async {
    final typed = await showDialog<int>(
      context: context,
      builder: (context) => _ValueDialog(
        title: editTitle!,
        initial: value,
        cancelLabel: cancelLabel ?? '',
        doneLabel: doneLabel ?? '',
      ),
    );
    if (typed != null) onChanged(typed.clamp(min, max));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = format?.call(value) ?? '$value';
    return FormCard(
      child: Row(
        children: [
          Expanded(
            child: FormLabel(title: title, subtitle: subtitle),
          ),
          const SizedBox(width: IKubbSpacing.sm),
          _RoundIconButton(
            icon: Icons.remove,
            tooltip: decreaseLabel,
            onPressed: value - step >= min
                ? () => onChanged(value - step)
                : null,
          ),
          Semantics(
            label: '$title: $label',
            button: editTitle != null,
            child: InkWell(
              borderRadius: BorderRadius.circular(IKubbRadius.sm),
              onTap: editTitle == null ? null : () => _edit(context),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: kMinInteractiveDimension + IKubbSpacing.xs,
                  minHeight: kMinInteractiveDimension,
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Text(
                      label,
                      style: IKubbType.score(
                        size: IKubbType.stepTitle,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _RoundIconButton(
            icon: Icons.add,
            tooltip: increaseLabel,
            onPressed: value + step <= max
                ? () => onChanged(value + step)
                : null,
          ),
        ],
      ),
    );
  }
}

/// Type-a-value dialog; owns its controller so it outlives the dialog's
/// exit animation.
class _ValueDialog extends StatefulWidget {
  const _ValueDialog({
    required this.title,
    required this.initial,
    required this.cancelLabel,
    required this.doneLabel,
  });

  final String title;
  final int initial;
  final String cancelLabel;
  final String doneLabel;

  @override
  State<_ValueDialog> createState() => _ValueDialogState();
}

class _ValueDialogState extends State<_ValueDialog> {
  late final _controller = TextEditingController(text: '${widget.initial}');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _done() => Navigator.of(context).pop(int.tryParse(_controller.text));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        onSubmitted: (_) => _done(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        TextButton(onPressed: _done, child: Text(widget.doneLabel)),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: scheme.onSurface.withValues(
          alpha: IKubbAlpha.glassControl,
        ),
        foregroundColor: scheme.onSurface,
        minimumSize: const Size(IKubbTap.min, IKubbTap.min),
      ),
      icon: Icon(icon, size: IKubbIconSize.md),
    );
  }
}

/// Full-width dashed outline button ("+ Add player").
class DashedAddButton extends StatelessWidget {
  const DashedAddButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(IKubbRadius.lg),
        onTap: onPressed,
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: scheme.onSurface.withValues(alpha: IKubbAlpha.dotIdle),
            radius: IKubbRadius.lg,
          ),
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: IKubbIconSize.md,
                  color: scheme.onSurface,
                ),
                const SizedBox(width: IKubbSpacing.sm),
                Text(label, style: IKubbType.emphasis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = IKubbBorder.hairline;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ).deflate(IKubbBorder.hairline / 2),
      );
    const dash = 6.0, gap = 5.0;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

/// A select ("dropdown") that looks like every other input: the themed
/// outlined field with the current value and a chevron. Tapping opens a
/// menu as wide as the field, with a check on the current option.
class SelectField<T> extends StatelessWidget {
  const SelectField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.semanticLabel,
  });

  final T value;
  final List<ChoiceOption<T>> options;
  final ValueChanged<T> onChanged;

  /// What the field is for ("Language"); the current value is announced
  /// after it.
  final String? semanticLabel;

  Future<void> _open(BuildContext context) async {
    final box = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final rect = Rect.fromPoints(
      box.localToGlobal(Offset(0, box.size.height), ancestor: overlay),
      box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
    );
    final picked = await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      constraints: BoxConstraints(minWidth: box.size.width),
      items: [
        for (final o in options)
          PopupMenuItem<T>(
            value: o.value,
            child: Row(
              children: [
                if (o.icon != null) ...[
                  Icon(o.icon, size: IKubbIconSize.md),
                  const SizedBox(width: IKubbSpacing.md),
                ],
                Expanded(child: Text(o.label)),
                if (o.value == value)
                  const Icon(Icons.check, size: IKubbIconSize.md),
              ],
            ),
          ),
      ],
    );
    if (picked != null && picked != value) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final current = options.firstWhere(
      (o) => o.value == value,
      orElse: () => options.first,
    );
    return Semantics(
      button: true,
      label: semanticLabel,
      value: current.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(IKubbRadius.md),
        onTap: () => _open(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.expand_more),
          ),
          child: ExcludeSemantics(
            child: Text(
              current.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: IKubbType.emphasis,
            ),
          ),
        ),
      ),
    );
  }
}

/// A player's identity disc: an initial, or a number for unnamed players.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.color,
    required this.label,
    this.size = 40,
    this.dimmed = false,
  });

  final Color color;
  final String label;
  final double size;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: dimmed ? color.withValues(alpha: 0.45) : color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: IKubbPalette.on(color),
            fontWeight: FontWeight.w700,
            fontSize: size * 0.42,
          ),
        ),
      ),
    );
  }
}

/// A small tinted pill ("Team A") in the team's identity color.
class TintPill extends StatelessWidget {
  const TintPill({
    super.key,
    required this.label,
    required this.color,
    this.onTap,
    this.semanticLabel,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: Material(
        color: color,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            padding: const EdgeInsets.symmetric(horizontal: IKubbSpacing.md),
            alignment: Alignment.center,
            child: ExcludeSemantics(
              child: Text(
                label,
                style: IKubbType.emphasis.copyWith(
                  color: IKubbPalette.on(color),
                  fontSize: IKubbType.stepChip + 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A recent-player chip: avatar + name in a capsule; dimmed once picked.
class RecentChip extends StatelessWidget {
  const RecentChip({
    super.key,
    required this.name,
    required this.color,
    required this.initial,
    required this.onPressed,
    this.dimmed = false,
  });

  final String name;
  final Color color;
  final String initial;
  final VoidCallback? onPressed;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ActionChip(
      avatar: AvatarCircle(
        color: color,
        label: initial,
        size: IKubbIconSize.lg,
        dimmed: dimmed,
      ),
      label: Text(
        name,
        style: TextStyle(
          color: dimmed
              ? scheme.onSurface.withValues(alpha: IKubbAlpha.faded)
              : scheme.onSurface,
        ),
      ),
      shape: const StadiumBorder(),
      side: BorderSide(
        color: scheme.onSurface.withValues(alpha: IKubbAlpha.dotIdle),
      ),
      onPressed: onPressed,
    );
  }
}
