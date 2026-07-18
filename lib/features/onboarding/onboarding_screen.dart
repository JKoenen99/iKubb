import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/viking_mascot.dart';
import 'onboarding_state.dart';

/// First-launch welcome with the audience fork (SPEC.md §3.1):
/// experienced players jump straight to setup; newcomers get the tour.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VikingMascot(size: 160),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(l10n.tagline, textAlign: TextAlign.center),
                  const SizedBox(height: 48),
                  FilledButton(
                    onPressed: () {
                      markOnboardingSeen();
                      context.go('/setup');
                    },
                    child: Text(l10n.startScoring),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () {
                      markOnboardingSeen();
                      context.go('/tour');
                    },
                    child: Text(l10n.teachMe),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
