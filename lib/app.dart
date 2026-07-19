import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/settings/settings_controller.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';
import 'theme/ikubb_theme.dart';

class IKubbApp extends ConsumerWidget {
  const IKubbApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: ref.watch(localeControllerProvider),
      themeMode: ref.watch(themeModeProvider),
      theme: IKubbTheme.light,
      darkTheme: IKubbTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
