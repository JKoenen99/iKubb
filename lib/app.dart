import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/feedback/feedback_controller.dart';
import 'features/settings/settings_controller.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';
import 'theme/kaato_theme.dart';

class KaatoApp extends ConsumerWidget {
  const KaatoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // Loads the prompt state at launch (and retries the feedback outbox).
    ref.watch(feedbackControllerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      // Dynamic Type is honored up to 2× — beyond that the field layouts
      // stop being playable; HIG allows clamping on layout-critical UI.
      builder: (context, child) =>
          MediaQuery.withClampedTextScaling(maxScaleFactor: 2, child: child!),
      locale: ref.watch(localeControllerProvider),
      themeMode: ref.watch(themeModeProvider),
      theme: KaatoTheme.light,
      darkTheme: KaatoTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
