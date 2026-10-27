import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'palette.dart';
import 'tokens.dart';

/// Liquid Glass (Apple HIG, iOS 26) rebuilt in Flutter for the iOS build.
///
/// Flutter draws its own UI, so the system material is not available;
/// this reproduces its rules rather than its shader: glass lives on the
/// *navigation and controls layer* only (bars, floating button groups,
/// sheets), never on content; it blurs and tints what scrolls beneath,
/// carries a thin specular rim, and keeps text at AA contrast through a
/// tint strong enough to steady the backdrop. Two variants as in the HIG:
/// [GlassVariant.regular] adapts to light/dark and suits most chrome;
/// [GlassVariant.clear] is darker and reserved for rich media backdrops
/// (wood grain, the celebration scrim) where it always dims first.
///
/// Everywhere else (Android, web) the same widgets render their plain
/// Material counterparts, so one widget tree serves both platforms.
abstract final class LiquidGlass {
  /// Glass is an iOS/macOS idiom. It is also switched off under Increase
  /// Contrast, the closest signal Flutter exposes to Reduce Transparency:
  /// the chrome then falls back to opaque surfaces with a visible border.
  static bool isEnabled(BuildContext context) {
    final platform = Theme.of(context).platform;
    final native =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
    return native && !MediaQuery.highContrastOf(context);
  }

  /// Whether the app runs in the Cupertino idiom at all (glass or its
  /// opaque high-contrast fallback): capsule buttons, floating bars.
  static bool isCupertino(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }
}

enum GlassVariant { regular, clear }

/// One glass surface: blur, tint, specular rim, soft shadow, superellipse
/// corners. Wrap a group of controls, a bar, or a sheet body in it.
class KaatoGlass extends StatelessWidget {
  const KaatoGlass({
    super.key,
    required this.child,
    this.variant = GlassVariant.regular,
    this.radius = KaatoRadius.glass,
    this.padding = EdgeInsets.zero,
    this.shadow = true,
  });

  final Widget child;
  final GlassVariant variant;

  /// Corner radius; [KaatoRadius.capsule] for pills.
  final double radius;
  final EdgeInsetsGeometry padding;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final enabled = LiquidGlass.isEnabled(context);

    // Tint: strong enough that onSurface text stays AA over any backdrop
    // (regular), or a dimming layer for media (clear, HIG: "always dim").
    final Color tint;
    final Color rim;
    switch (variant) {
      case GlassVariant.regular:
        tint = scheme.surface.withValues(
          alpha: enabled ? KaatoAlpha.glassTint : 1,
        );
        rim = (dark ? KaatoPalette.birchLight : KaatoPalette.ink).withValues(
          alpha: enabled ? KaatoAlpha.glassRim : KaatoAlpha.glassRimOpaque,
        );
      case GlassVariant.clear:
        tint = KaatoPalette.forestDeep.withValues(
          alpha: enabled ? KaatoAlpha.glassDim : 1,
        );
        rim = KaatoPalette.birchLight.withValues(alpha: KaatoAlpha.glassRim);
    }

    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: rim, width: KaatoBorder.hairline),
    );

    Widget surface = DecoratedBox(
      decoration: ShapeDecoration(
        // A ShapeDecoration takes a color or a gradient, never both: the
        // sheen gradient already starts from the tint.
        color: enabled ? null : tint,
        shape: shape,
        // Specular highlight along the top edge: the "lensing" cue, kept
        // subtle so it reads as glass, not as a gradient fill.
        gradient: enabled
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.alphaBlend(
                    KaatoPalette.birchLight.withValues(
                      alpha: KaatoAlpha.glassSheen,
                    ),
                    tint,
                  ),
                  tint,
                ],
                stops: const [0, 0.35],
              )
            : null,
        shadows: shadow
            ? [
                BoxShadow(
                  color: KaatoPalette.ink.withValues(
                    alpha: enabled
                        ? KaatoAlpha.glassShadow
                        : KaatoAlpha.glassShadow / 2,
                  ),
                  blurRadius: KaatoSpacing.xl,
                  offset: const Offset(0, KaatoSpacing.sm),
                ),
              ]
            : null,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (!enabled) return surface;
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: KaatoMotion.glassBlur,
          sigmaY: KaatoMotion.glassBlur,
        ),
        child: surface,
      ),
    );
  }
}

/// A floating group of controls in one glass capsule (HIG: related
/// controls share a container; few per group). Lays its children out in
/// a row with hairline gaps.
class GlassGroup extends StatelessWidget {
  const GlassGroup({
    super.key,
    required this.children,
    this.variant = GlassVariant.regular,
  });

  final List<Widget> children;
  final GlassVariant variant;

  @override
  Widget build(BuildContext context) {
    return KaatoGlass(
      variant: variant,
      radius: KaatoRadius.capsule,
      padding: const EdgeInsets.symmetric(horizontal: KaatoSpacing.xxs),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

/// A floating glass toolbar for a screen's primary actions, inset from
/// the edges and above the home indicator. Inside it, tonal buttons turn
/// into monochrome glass buttons so only the primary action is tinted
/// (HIG: tint sparingly).
class GlassToolbar extends StatelessWidget {
  const GlassToolbar({
    super.key,
    required this.child,
    this.variant = GlassVariant.regular,
  });

  final Widget child;
  final GlassVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final onGlass = variant == GlassVariant.clear
        ? KaatoPalette.birchLight
        : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KaatoSpacing.lg,
        KaatoSpacing.sm,
        KaatoSpacing.lg,
        KaatoSpacing.lg,
      ),
      child: KaatoGlass(
        variant: variant,
        padding: const EdgeInsets.all(KaatoSpacing.sm),
        child: Theme(
          data: theme.copyWith(
            colorScheme: scheme.copyWith(
              secondaryContainer: onGlass.withValues(
                alpha: KaatoAlpha.glassControl,
              ),
              onSecondaryContainer: onGlass,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A screen's bottom action row: a floating glass toolbar on iOS, a
/// plain padded row elsewhere. Same child, same layout.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.child,
    this.variant = GlassVariant.regular,
  });

  final Widget child;
  final GlassVariant variant;

  @override
  Widget build(BuildContext context) {
    if (LiquidGlass.isCupertino(context)) {
      return GlassToolbar(variant: variant, child: child);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KaatoSpacing.lg,
        0,
        KaatoSpacing.lg,
        KaatoSpacing.lg,
      ),
      child: child,
    );
  }
}

/// Body of a modal bottom sheet. On iOS it is the inset half sheet of
/// iOS 26: floating off the display edges, large concentric corners, a
/// glass surface with its own grabber, content peeking through around
/// it. Elsewhere the child is returned as-is for the Material sheet.
Widget glassSheet(BuildContext context, Widget child) {
  if (!LiquidGlass.isCupertino(context)) return child;
  final scheme = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.fromLTRB(
      KaatoSpacing.sm,
      0,
      KaatoSpacing.sm,
      KaatoSpacing.sm,
    ),
    child: KaatoGlass(
      radius: KaatoRadius.sheet,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber (HIG: resizable sheets show one; it also works with
          // VoiceOver through the sheet's own drag semantics).
          Padding(
            padding: const EdgeInsets.symmetric(vertical: KaatoSpacing.sm),
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: scheme.onSurface.withValues(alpha: KaatoAlpha.dotIdle),
                borderRadius: BorderRadius.circular(KaatoRadius.capsule),
              ),
            ),
          ),
          Flexible(child: child),
        ],
      ),
    ),
  );
}

/// An icon button floating on its own glass disc (Home settings,
/// scoreboard close): [GlassVariant.clear] over media backdrops.
Widget glassIconButton(
  BuildContext context,
  Widget button, {
  GlassVariant variant = GlassVariant.clear,
}) => LiquidGlass.isCupertino(context)
    ? GlassGroup(variant: variant, children: [button])
    : button;
