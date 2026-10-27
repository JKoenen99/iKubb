import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/palette.dart';
import '../theme/tokens.dart';
import 'adaptive_choice.dart';

/// A segmented control in the track-and-tile anatomy (iOS
/// UISegmentedControl, the designsystems.surf blueprint):
///
/// - **Track**: a recessed, softly tinted rounded rectangle.
/// - **Active tile**: a raised surface with a soft shadow that slides to the
///   chosen segment. No outlines, no fill in the brand color.
/// - **Segments**: equal widths; a label with an optional leading icon.
///   The active label is full strength and semibold, the others faded.
///
/// Corners are concentric: track 12, inset 4, tile 8. Use it for two to
/// four short, mutually exclusive options that switch a view or a setting
/// in place. Needs a bounded width (it fills it); [AdaptiveChoice] wraps
/// it and falls back to chips at large text sizes.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  }) : assert(options.length >= 2);

  final List<ChoiceOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Track inset around the tile; also the gap that makes the corners
  /// concentric (trackRadius - inset = tileRadius).
  static const double inset = IKubbSpacing.xs;
  static const double trackRadius = IKubbRadius.md;
  static const double tileRadius = IKubbRadius.sm;

  /// Whole control height: the 48pt tap minimum.
  static const double height = kMinInteractiveDimension;

  void _step(int delta) {
    final i = options.indexWhere((o) => o.value == selected);
    final next = (i + delta).clamp(0, options.length - 1);
    if (next != i) onSelected(options[next].value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final index = options
        .indexWhere((o) => o.value == selected)
        .clamp(0, options.length - 1);

    // The track is a tint of the text color, so it recedes from whatever
    // it sits on (the page or a card) in both themes.
    final track = scheme.onSurface.withValues(
      alpha: dark ? IKubbAlpha.segmentTrackDark : IKubbAlpha.segmentTrack,
    );
    final tile = dark ? IKubbPalette.segmentTileDark : scheme.surface;
    final tileShadow = BoxShadow(
      color: (dark ? Colors.black : IKubbPalette.ink).withValues(
        alpha: dark ? IKubbAlpha.segmentShadowDark : IKubbAlpha.segmentShadow,
      ),
      blurRadius: 4,
      offset: const Offset(0, 1),
    );
    final duration = IKubbMotion.resolve(context, IKubbMotion.quick);

    return Focus(
      // Arrow keys move the selection while any segment has focus
      // (radio-group keyboard behaviour).
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _step(rtl ? -1 : 1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _step(rtl ? 1 : -1);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final segment = (width - inset * 2) / options.length;
          // No padding on the track: the tile is inset visually, while the
          // segments span the full 48pt height so the whole track is the
          // tap target (HIG 44pt, Material 48dp).
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: track,
              borderRadius: BorderRadius.circular(trackRadius),
            ),
            child: Stack(
              children: [
                AnimatedPositionedDirectional(
                  duration: duration,
                  curve: IKubbMotion.enter,
                  start: inset + segment * index,
                  top: inset,
                  bottom: inset,
                  width: segment,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tile,
                      borderRadius: BorderRadius.circular(tileRadius),
                      boxShadow: [tileShadow],
                    ),
                  ),
                ),
                // Segments fill the track: centered labels, and the full
                // height and width are tappable.
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (i, o) in options.indexed)
                        Expanded(
                          child: _Segment(
                            option: o,
                            selected: i == index,
                            onTap: () {
                              if (o.value != selected) onSelected(o.value);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ChoiceOption<Object?> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: IKubbAlpha.faded);
    // Built on the theme's label style so family, letter spacing and text
    // scaling come from the app; AnimatedDefaultTextStyle replaces rather
    // than merges, so a bare TextStyle would drop them.
    final style = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: color,
      fontSize: 15,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
    );
    return Semantics(
      button: true,
      enabled: true,
      inMutuallyExclusiveGroup: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SegmentedControl.tileRadius),
        // The tile is the feedback; a ripple across it would fight it.
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: IKubbSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (option.icon != null) ...[
                Icon(option.icon, size: IKubbIconSize.sm, color: color),
                const SizedBox(width: IKubbSpacing.xs + IKubbSpacing.xxs),
              ],
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: IKubbMotion.resolve(context, IKubbMotion.quick),
                  style: style,
                  child: Text(
                    option.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
