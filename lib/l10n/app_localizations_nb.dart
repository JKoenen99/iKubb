// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Resultattavlen for nummerkubb';

  @override
  String get startScoring => 'Jeg kan reglene — begynn å score';

  @override
  String get teachMe => 'Lær meg spillet';

  @override
  String get quickStart => 'Hurtigstart';

  @override
  String get newGame => 'Nytt spill';

  @override
  String get rules => 'Regler';

  @override
  String get stats => 'Statistikk';

  @override
  String get confirmThrow => 'Bekreft kast';

  @override
  String get miss => 'Bom';

  @override
  String get undo => 'Angre';

  @override
  String needsExactly(int points) {
    return 'Trenger nøyaktig $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Over målet — tilbake til $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name vinner!';
  }

  @override
  String get comingSoon => 'Kommer snart';
}
