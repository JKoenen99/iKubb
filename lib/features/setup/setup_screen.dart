import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// Game setup (SPEC.md §3.2): players, teams, house rules, turn order.
/// Placeholder — quick start goes straight into a classic 2-player game.
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.newGame)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.comingSoon),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/game'),
              child: Text(l10n.quickStart),
            ),
          ],
        ),
      ),
    );
  }
}
