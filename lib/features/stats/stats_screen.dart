import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Player history and statistics (SPEC.md §3.5). Placeholder.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.stats)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
