// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Die Anzeigetafel für Nummern-Kubb';

  @override
  String get startScoring => 'Ich kenne die Regeln — Punkte zählen';

  @override
  String get teachMe => 'Bring mir das Spiel bei';

  @override
  String get quickStart => 'Schnellstart';

  @override
  String get newGame => 'Neues Spiel';

  @override
  String get rules => 'Regeln';

  @override
  String get stats => 'Statistiken';

  @override
  String get confirmThrow => 'Wurf bestätigen';

  @override
  String get miss => 'Fehlwurf';

  @override
  String get undo => 'Rückgängig';

  @override
  String needsExactly(int points) {
    return 'Braucht genau $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Überworfen — zurück auf $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name gewinnt!';
  }

  @override
  String get comingSoon => 'Bald verfügbar';
}
