import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scoring_engine/scoring_engine.dart';
import 'package:share_plus/share_plus.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../../widgets/viking_mascot.dart';
import '../../widgets/wood_grain.dart';
import '../../theme/tokens.dart';

/// End-of-game share card (SPEC.md §3.5): a branded result image for
/// Messages/WhatsApp. The dialog previews exactly what gets shared; the
/// image is captured from the preview itself so they can never differ.
Future<void> showShareDialog(
  BuildContext context, {
  required Game game,
  required Color winnerColor,
}) {
  final boundaryKey = GlobalKey();
  return showDialog(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: boundaryKey,
              child: ShareCard(game: game, winnerColor: winnerColor),
            ),
            const SizedBox(height: IKubbSpacing.md),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: IKubbPalette.birchLight,
                foregroundColor: IKubbPalette.forestDeep,
              ),
              onPressed: () => _captureAndShare(boundaryKey),
              icon: Icon(Icons.adaptive.share),
              label: Text(l10n.share),
            ),
          ],
        ),
      );
    },
  );
}

/// The classic-kubb share dialog: same capture pipeline, kubb result.
Future<void> showKubbShareDialog(
  BuildContext context, {
  required KubbMatch match,
  required Color winnerColor,
}) {
  final boundaryKey = GlobalKey();
  return showDialog(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: boundaryKey,
              child: KubbShareCard(match: match, winnerColor: winnerColor),
            ),
            const SizedBox(height: IKubbSpacing.md),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: IKubbPalette.birchLight,
                foregroundColor: IKubbPalette.forestDeep,
              ),
              onPressed: () => _captureAndShare(boundaryKey),
              icon: Icon(Icons.adaptive.share),
              label: Text(l10n.share),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _captureAndShare(GlobalKey boundaryKey) async {
  try {
    final boundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return;
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(bytes.buffer.asUint8List(), mimeType: 'image/png'),
        ],
        fileNameOverrides: ['ikubb-result.png'],
      ),
    );
  } on Object {
    // Sharing is best-effort: platforms without a share sheet just no-op.
  }
}

/// The kubb result card: winner line, per-team game wins (best-of) and
/// the deciding game's kubbs still standing — same branding as [ShareCard].
class KubbShareCard extends StatelessWidget {
  const KubbShareCard({
    super.key,
    required this.match,
    required this.winnerColor,
  });

  final KubbMatch match;
  final Color winnerColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final game = match.currentGame;
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: IKubbPalette.birchLight,
        borderRadius: BorderRadius.circular(IKubbRadius.xl),
        border: Border.all(color: winnerColor, width: 4),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const WoodGrainBackground(
            color: IKubbPalette.walnut,
            opacity: IKubbAlpha.grain,
          ),
          Padding(
            padding: const EdgeInsets.all(IKubbSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VikingMascot(pose: MascotPose.cheer, size: 110),
                const SizedBox(height: IKubbSpacing.sm),
                Text(
                  l10n.winnerBanner(match.matchWinner?.name ?? ''),
                  textAlign: TextAlign.center,
                  style: IKubbType.heading(
                    size: IKubbType.stepHeadline,
                    color: IKubbPalette.ink,
                  ),
                ),
                const SizedBox(height: IKubbSpacing.lg),
                for (final (i, side) in match.sides.indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: IKubbSpacing.xxs,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            side.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: IKubbType.emphasis.copyWith(
                              color: IKubbPalette.ink,
                              fontWeight: side == match.matchWinner
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          match.rules.bestOf > 1
                              ? '${match.wins[i]}'
                              : '${game.baseline[i]}',
                          style: IKubbType.score(
                            size: IKubbType.stepLabel,
                            color: IKubbPalette.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: IKubbSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMd(locale).format(DateTime.now()),
                      style: IKubbType.caption.copyWith(
                        color: IKubbPalette.ink.withValues(
                          alpha: IKubbAlpha.faded,
                        ),
                      ),
                    ),
                    Text(
                      'iKubb',
                      style: IKubbType.heading(
                        size: IKubbType.stepBody,
                        color: IKubbPalette.forest,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The card itself: birch surface, grain, cheering mascot, winner line,
/// standings, date, wordmark. Text-free illustrations; all copy localized.
class ShareCard extends StatelessWidget {
  const ShareCard({super.key, required this.game, required this.winnerColor});

  final Game game;
  final Color winnerColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: IKubbPalette.birchLight,
        borderRadius: BorderRadius.circular(IKubbRadius.xl),
        border: Border.all(color: winnerColor, width: 4),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const WoodGrainBackground(
            color: IKubbPalette.walnut,
            opacity: IKubbAlpha.grain,
          ),
          Padding(
            padding: const EdgeInsets.all(IKubbSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VikingMascot(pose: MascotPose.cheer, size: 110),
                const SizedBox(height: IKubbSpacing.sm),
                Text(
                  l10n.winnerBanner(game.winner?.name ?? ''),
                  textAlign: TextAlign.center,
                  style: IKubbType.heading(
                    size: IKubbType.stepHeadline,
                    color: IKubbPalette.ink,
                  ),
                ),
                const SizedBox(height: IKubbSpacing.lg),
                for (final state in game.sideStates)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: IKubbSpacing.xxs,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.side.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: IKubbType.emphasis.copyWith(
                              color: IKubbPalette.ink,
                              fontWeight: state.side == game.winner
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              decoration: state.isEliminated
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                          '${state.score}',
                          style: IKubbType.score(
                            size: IKubbType.stepLabel,
                            color: IKubbPalette.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: IKubbSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMd(locale).format(DateTime.now()),
                      style: IKubbType.caption.copyWith(
                        color: IKubbPalette.ink.withValues(
                          alpha: IKubbAlpha.faded,
                        ),
                      ),
                    ),
                    Text(
                      'iKubb',
                      style: IKubbType.heading(
                        size: IKubbType.stepBody,
                        color: IKubbPalette.forest,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
