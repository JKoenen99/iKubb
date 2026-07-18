// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Il segnapunti del kubb numerato';

  @override
  String get startScoring => 'Conosco le regole — inizia a segnare';

  @override
  String get teachMe => 'Insegnami il gioco';

  @override
  String get quickStart => 'Avvio rapido';

  @override
  String get newGame => 'Nuova partita';

  @override
  String get rules => 'Regole';

  @override
  String get stats => 'Statistiche';

  @override
  String get confirmThrow => 'Conferma il lancio';

  @override
  String get miss => 'Mancato';

  @override
  String get undo => 'Annulla';

  @override
  String needsExactly(int points) {
    return 'Servono esattamente $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Superato — si torna a $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name vince!';
  }

  @override
  String get comingSoon => 'In arrivo';
}
