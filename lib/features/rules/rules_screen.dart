import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/home_leading.dart';
import 'rules_view.dart';
import '../../theme/tokens.dart';

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
        leading: homeLeading(context),
        actions: [
          // Replay the "Teach me the game" tour any time (SPEC.md §3.1).
          IconButton(
            tooltip: l10n.teachMe,
            onPressed: () => context.push('/tour'),
            icon: const Icon(Icons.school_outlined),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: IKubbLayout.maxPanel),
          child: const RulesView(),
        ),
      ),
    );
  }
}
