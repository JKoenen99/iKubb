import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

/// AppBar leading fallback so no screen is ever a dead end: when the
/// navigator has history the default back button appears; otherwise a
/// home button takes over (screens are often reached via `go`, which
/// replaces the stack).
Widget? homeLeading(BuildContext context) {
  if (Navigator.of(context).canPop()) return null; // default back button
  return IconButton(
    tooltip: AppLocalizations.of(context)!.homeLabel,
    onPressed: () => context.go('/'),
    icon: const Icon(Icons.home_outlined),
  );
}
