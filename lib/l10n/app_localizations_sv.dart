// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Resultattavlan för nummerkubb';

  @override
  String get startScoring => 'Jag kan reglerna — börja räkna poäng';

  @override
  String get teachMe => 'Lär mig spelet';

  @override
  String get quickStart => 'Snabbstart';

  @override
  String get newGame => 'Ny match';

  @override
  String get rules => 'Regler';

  @override
  String get stats => 'Statistik';

  @override
  String get confirmThrow => 'Bekräfta kast';

  @override
  String get miss => 'Miss';

  @override
  String get undo => 'Ångra';

  @override
  String needsExactly(int points) {
    return 'Behöver exakt $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Över målet — tillbaka till $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name vinner!';
  }

  @override
  String get comingSoon => 'Kommer snart';
}
