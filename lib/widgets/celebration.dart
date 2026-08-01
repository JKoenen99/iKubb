import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'confetti.dart';
import 'viking_mascot.dart';
import 'wood_grain.dart';

/// Buttons that sit on the dark celebration scrim — birch on forest.
class OverlayFilledButton extends StatelessWidget {
  const OverlayFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: IKubbPalette.birchLight,
      foregroundColor: IKubbPalette.forestDeep,
    );
    return icon == null
        ? FilledButton(style: style, onPressed: onPressed, child: child)
        : FilledButton.icon(
            style: style,
            onPressed: onPressed,
            icon: icon,
            label: child,
          );
  }
}

class OverlayOutlinedButton extends StatelessWidget {
  const OverlayOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: IKubbPalette.birchLight,
      side: const BorderSide(color: IKubbPalette.birchLight),
    );
    return icon == null
        ? OutlinedButton(style: style, onPressed: onPressed, child: child)
        : OutlinedButton.icon(
            style: style,
            onPressed: onPressed,
            icon: icon,
            label: child,
          );
  }
}

/// The one end-of-game overlay chrome, in two intensities:
/// [celebrate] true — winner-tinted scrim, wood grain, cheering mascot,
/// confetti (match/game won); false — plain scrim, no fanfare (between
/// games of a best-of match).
///
/// Per SPEC.md §3.7 nothing ever blocks input: every action is live from
/// the first frame, the entry motion is decoration on top of final state.
class CelebrationScaffold extends StatelessWidget {
  const CelebrationScaffold({
    super.key,
    required this.banner,
    required this.actions,
    this.winnerColor,
    this.scoreLine,
    this.details,
    this.celebrate = true,
  });

  final Widget banner;
  final List<Widget> actions;

  /// The winner's identity color, tinting the scrim on full celebrations.
  final Color? winnerColor;
  final Widget? scoreLine;

  /// Optional block between the banner and the actions (standings rows).
  final Widget? details;
  final bool celebrate;

  @override
  Widget build(BuildContext context) {
    final scrim = celebrate && winnerColor != null
        ? Color.alphaBlend(
            winnerColor!.withValues(alpha: IKubbAlpha.activeTint),
            IKubbPalette.forestDeep,
          )
        : IKubbPalette.forestDeep.withValues(alpha: IKubbAlpha.scrim);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (celebrate) ...[
          const VikingMascot(pose: MascotPose.cheer, size: 150),
          const SizedBox(height: IKubbSpacing.md),
        ],
        banner,
        if (scoreLine != null) ...[
          const SizedBox(height: IKubbSpacing.sm),
          scoreLine!,
        ],
        if (details != null) ...[
          const SizedBox(height: IKubbSpacing.xl),
          details!,
        ],
        const SizedBox(height: IKubbSpacing.xl),
        for (final (i, action) in actions.indexed) ...[
          if (i > 0) const SizedBox(height: IKubbSpacing.md),
          action,
        ],
      ],
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: scrim),
        if (celebrate)
          const WoodGrainBackground(
            color: IKubbPalette.birchLight,
            opacity: IKubbAlpha.grain,
          ),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: IKubbLayout.maxOverlay,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(IKubbSpacing.xl),
                child: celebrate
                    ? TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.9, end: 1),
                        duration: IKubbMotion.gentle,
                        curve: IKubbMotion.emphasized,
                        builder: (context, scale, child) =>
                            Transform.scale(scale: scale, child: child),
                        child: content,
                      )
                    : content,
              ),
            ),
          ),
        ),
        if (celebrate) const ConfettiBurst(),
      ],
    );
  }
}

/// Banner text styled for the celebration scrim.
class CelebrationBanner extends StatelessWidget {
  const CelebrationBanner(this.text, {super.key, this.size});

  final String text;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: size ?? IKubbType.stepScoreLg,
        color: IKubbPalette.birchLight,
      ),
    );
  }
}
