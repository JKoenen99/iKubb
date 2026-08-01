import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../theme/palette.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'viking_mascot.dart';
import 'wood_grain.dart';

/// One line on the result card: a side and its number.
class ShareRow {
  const ShareRow(
    this.label,
    this.value, {
    this.emphasized = false,
    this.struck = false,
  });

  final String label;
  final String value;

  /// The winner's row.
  final bool emphasized;

  /// Eliminated sides.
  final bool struck;
}

/// End-of-game share dialog (SPEC.md §3.5): previews exactly what gets
/// shared; the image is captured from the preview itself so they can
/// never differ. Both game modes feed the same card.
Future<void> showShareCardDialog(
  BuildContext context, {
  required String banner,
  required List<ShareRow> rows,
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
              child: ShareCard(
                banner: banner,
                rows: rows,
                winnerColor: winnerColor,
              ),
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

/// The branded result card: birch surface, grain, cheering mascot, winner
/// banner, result rows, date and wordmark. All copy localized.
class ShareCard extends StatelessWidget {
  const ShareCard({
    super.key,
    required this.banner,
    required this.rows,
    required this.winnerColor,
  });

  final String banner;
  final List<ShareRow> rows;
  final Color winnerColor;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: IKubbPalette.birchLight,
        borderRadius: BorderRadius.circular(IKubbRadius.xl),
        border: Border.all(color: winnerColor, width: IKubbBorder.frame),
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
                  banner,
                  textAlign: TextAlign.center,
                  style: IKubbType.heading(
                    size: IKubbType.stepHeadline,
                    color: IKubbPalette.ink,
                  ),
                ),
                const SizedBox(height: IKubbSpacing.lg),
                for (final row in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: IKubbSpacing.xxs,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: IKubbType.emphasis.copyWith(
                              color: IKubbPalette.ink,
                              fontWeight: row.emphasized
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              decoration: row.struck
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                          row.value,
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
