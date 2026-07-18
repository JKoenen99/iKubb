// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Het nummerkubb-scorebord';

  @override
  String get startScoring => 'Ik ken de regels — begin met scoren';

  @override
  String get teachMe => 'Leer mij het spel';

  @override
  String get quickStart => 'Snel starten';

  @override
  String get newGame => 'Nieuw spel';

  @override
  String get rules => 'Regels';

  @override
  String get stats => 'Statistieken';

  @override
  String get confirmThrow => 'Worp bevestigen';

  @override
  String get miss => 'Mis';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String needsExactly(int points) {
    return 'Heeft precies $points nodig';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Te veel — terug naar $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name wint!';
  }

  @override
  String get comingSoon => 'Binnenkort beschikbaar';
}
