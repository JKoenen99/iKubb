import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Categorized rules reference with progressive disclosure (SPEC.md §3.6).
/// Placeholder — will become the slide-over panel reachable from every
/// screen, with one-rule-one-card categories and search.
class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rules)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
