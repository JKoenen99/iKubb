import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'rules_view.dart';

/// Full-screen rules reference — the target of the onboarding
/// "Teach me the game" fork and the Home rules button. In-game, the same
/// content opens as a slide-over panel via [showRulesPanel].
class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rules),
        actions: [
          // Replay the "Teach me the game" tour any time (SPEC.md §3.1).
          IconButton(
            tooltip: l10n.teachMe,
            onPressed: () => context.go('/tour'),
            icon: const Icon(Icons.school_outlined),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: const RulesView(),
        ),
      ),
    );
  }
}
