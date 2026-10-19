import 'package:flutter/material.dart';

import '../theme/glass.dart';
import '../theme/tokens.dart';

/// The one app bar. On iOS it follows the Liquid Glass navigation bar:
/// the bar has no background, the leading button sits in a circular
/// glass, the actions share one glass capsule (one group, icons only,
/// monochrome), the title stays on a soft scroll-edge fade so content
/// scrolling beneath never fights it. Elsewhere it is a plain Material
/// [AppBar] with the same parts.
///
/// Pair it with `extendBodyBehindAppBar: LiquidGlass.isCupertino(context)`
/// on the Scaffold so content really does flow under the bar.
class IKubbAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IKubbAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions = const [],
    this.glassVariant = GlassVariant.regular,
  });

  final Widget? title;

  /// Null keeps the default back button (wrapped in glass on iOS).
  final Widget? leading;
  final List<Widget> actions;

  /// [GlassVariant.clear] over rich backdrops (wood grain, scrims).
  final GlassVariant glassVariant;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (!LiquidGlass.isCupertino(context)) {
      return AppBar(title: title, leading: leading, actions: actions);
    }
    final scheme = Theme.of(context).colorScheme;
    final canPop = Navigator.of(context).canPop();
    final lead = leading ?? (canPop ? const BackButton() : null);
    return AppBar(
      title: title,
      // Soft scroll edge: the scaffold color fades out under the bar so
      // the title keeps contrast against whatever scrolls beneath.
      flexibleSpace: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scheme.surface.withValues(alpha: IKubbAlpha.scrim),
                scheme.surface.withValues(alpha: 0),
              ],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
      leadingWidth: lead == null ? null : kToolbarHeight + IKubbSpacing.sm,
      leading: lead == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: IKubbSpacing.sm),
              child: Center(
                child: GlassGroup(variant: glassVariant, children: [lead]),
              ),
            ),
      actions: actions.isEmpty
          ? const []
          : [
              Padding(
                padding: const EdgeInsets.only(right: IKubbSpacing.sm),
                child: Center(
                  child: GlassGroup(variant: glassVariant, children: actions),
                ),
              ),
            ],
    );
  }
}
