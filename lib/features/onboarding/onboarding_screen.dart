import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../widgets/viking_mascot.dart';
import '../../widgets/wood_grain.dart';
import 'onboarding_state.dart';
import '../../theme/tokens.dart';

/// First-launch welcome with the audience fork (SPEC.md §3.1):
/// experienced players jump straight to setup; newcomers get the tour.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const WoodGrainBackground(color: IKubbPalette.walnut),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: IKubbLayout.maxColumn,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(IKubbSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const VikingMascot(size: 160),
                      const SizedBox(height: IKubbSpacing.sm),
                      Text(
                        l10n.appTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(l10n.tagline, textAlign: TextAlign.center),
                      const SizedBox(height: IKubbSpacing.huge),
                      FilledButton(
                        onPressed: () {
                          markOnboardingSeen();
                          context.go('/setup');
                        },
                        child: Text(l10n.startScoring),
                      ),
                      const SizedBox(height: IKubbSpacing.md),
                      OutlinedButton.icon(
                        onPressed: () {
                          markOnboardingSeen();
                          context.go('/tour');
                        },
                        icon: const Icon(Icons.school_outlined),
                        label: Text(l10n.teachMe),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
