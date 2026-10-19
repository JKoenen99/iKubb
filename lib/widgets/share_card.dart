import 'dart:ui' as ui;

import 'dart:math' as math;

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
      // The card never exceeds the viewport: narrow phones shrink it and
      // large Dynamic Type scrolls it instead of overflowing.
      final cardWidth = math.min(
        ShareCard.defaultWidth,
        MediaQuery.sizeOf(context).width - 2 * IKubbSpacing.xl,
      );
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: boundaryKey,
                child: ShareCard(
                  banner: banner,
                  rows: rows,
                  winnerColor: winnerColor,
                  width: cardWidth,
                ),
              ),
              const SizedBox(height: IKubbSpacing.md),
              // Builder: the share sheet is anchored to this very button,
              // which iPad needs to place the popover (HIG).
              Builder(
                builder: (buttonContext) => FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: IKubbPalette.birchLight,
                    foregroundColor: IKubbPalette.forestDeep,
                  ),
                  onPressed: () => _captureAndShare(
                    boundaryKey,
                    origin: _rectOf(buttonContext),
                  ),
                  icon: Icon(Icons.adaptive.share),
                  label: Text(l10n.share),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: IKubbPalette.birchLight,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.closeLabel),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Global rect of a widget, for anchoring the iPad share popover.
Rect? _rectOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}

Future<void> _captureAndShare(GlobalKey boundaryKey, {Rect? origin}) async {
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
        sharePositionOrigin: origin,
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
    this.width = defaultWidth,
  });

  static const double defaultWidth = 320;

  final String banner;
  final List<ShareRow> rows;
  final Color winnerColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Container(
      width: width,
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
