// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'El marcador del kubb numérico';

  @override
  String get startScoring => 'Conozco las reglas — empezar a puntuar';

  @override
  String get teachMe => 'Enséñame el juego';

  @override
  String get quickStart => 'Inicio rápido';

  @override
  String get newGame => 'Nueva partida';

  @override
  String get rules => 'Reglas';

  @override
  String get stats => 'Estadísticas';

  @override
  String get confirmThrow => 'Confirmar lanzamiento';

  @override
  String get miss => 'Fallo';

  @override
  String get undo => 'Deshacer';

  @override
  String needsExactly(int points) {
    return 'Necesita exactamente $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Pasado — vuelve a $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '¡$name gana!';
  }

  @override
  String get comingSoon => 'Próximamente';
}
