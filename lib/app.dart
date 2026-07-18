import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'router.dart';
import 'theme/ikubb_theme.dart';

class IKubbApp extends StatelessWidget {
  const IKubbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: IKubbTheme.light,
      darkTheme: IKubbTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
