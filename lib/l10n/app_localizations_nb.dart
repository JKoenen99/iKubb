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

  @override
  String get players => 'Spillere';

  @override
  String get addPlayer => 'Legg til spiller';

  @override
  String get playerName => 'Navn';

  @override
  String get recentPlayers => 'Nylige spillere';

  @override
  String get teams => 'Lag';

  @override
  String get teamA => 'Lag A';

  @override
  String get teamB => 'Lag B';

  @override
  String get autoBalance => 'Fordel automatisk';

  @override
  String get houseRules => 'Husregler';

  @override
  String get targetScore => 'Målpoeng';

  @override
  String get overshootRule => 'Over målet';

  @override
  String get policyReset => 'Tilbakestill';

  @override
  String get policyHalf => 'Halvparten av målet';

  @override
  String get policyNone => 'Ingen straff';

  @override
  String get eliminationRule => 'Utslagning';

  @override
  String get missLimit => 'Bom før utslagning';

  @override
  String get shuffleOrder => 'Stokk rekkefølgen';

  @override
  String get startGame => 'Start spill';

  @override
  String get needTwoPlayers => 'Legg til minst 2 spillere';

  @override
  String get needBothTeams => 'Begge lag trenger en spiller';

  @override
  String get custom => 'Egendefinert';
}
