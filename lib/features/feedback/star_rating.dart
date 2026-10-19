import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/tokens.dart';
import '../settings/haptics.dart';

/// Five tappable stars (HIG: ≥44pt targets, each with a VoiceOver label
/// "n of 5 stars", selected state on the chosen one). Amber stars echo the
/// win confetti; the idle outline keeps shape as the second channel.
class StarRating extends ConsumerWidget {
  const StarRating({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = IKubbIconSize.display,
    this.idleColor,
  });

  /// 0 = nothing picked yet.
  final int value;
  final ValueChanged<int> onChanged;
  final double size;
  final Color? idleColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final idle =
        idleColor ??
        Theme.of(context).colorScheme.onSurface
            .withValues(alpha: IKubbAlpha.dotIdle);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var star = 1; star <= 5; star++)
          Semantics(
            selected: star == value,
            child: IconButton(
              tooltip: l10n.feedbackStarsSemantics(star),
              iconSize: size,
              constraints: const BoxConstraints(
                minWidth: IKubbTap.min,
                minHeight: IKubbTap.min,
              ),
              onPressed: () {
                Haptics.selection(ref);
                onChanged(star);
              },
              icon: Icon(
                star <= value ? Icons.star_rounded : Icons.star_outline_rounded,
                color: star <= value ? IKubbPalette.amber : idle,
              ),
            ),
          ),
      ],
    );
  }
}
