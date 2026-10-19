import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// The one confirmation dialog: platform-adaptive, cancel on the left,
/// and a destructive confirm rendered in the error color (HIG).
///
/// On iOS/macOS the actions are real [CupertinoDialogAction]s, so the
/// system conveys the roles: Cancel is the bold default, a destructive
/// confirm is red. Elsewhere Material [TextButton]s do the same job.
/// Returns true only on explicit confirmation.
Future<bool> confirmAdaptive(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  bool isDestructive = false,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: Text(body),
      actions: [
        adaptiveDialogAction(
          context,
          onPressed: () => Navigator.of(context).pop(false),
          isDefault: true,
          child: Text(l10n.cancel),
        ),
        adaptiveDialogAction(
          context,
          onPressed: () => Navigator.of(context).pop(true),
          isDestructive: isDestructive,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed == true;
}

/// A dialog action in the platform's own idiom.
Widget adaptiveDialogAction(
  BuildContext context, {
  required VoidCallback onPressed,
  required Widget child,
  bool isDefault = false,
  bool isDestructive = false,
}) {
  final platform = Theme.of(context).platform;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      isDefaultAction: isDefault,
      isDestructiveAction: isDestructive,
      child: child,
    );
  }
  return TextButton(
    onPressed: onPressed,
    style: isDestructive
        ? TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          )
        : null,
    child: child,
  );
}
