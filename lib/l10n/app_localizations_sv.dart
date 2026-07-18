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

  @override
  String get players => 'Spelare';

  @override
  String get addPlayer => 'Lägg till spelare';

  @override
  String get playerName => 'Namn';

  @override
  String get recentPlayers => 'Senaste spelare';

  @override
  String get teams => 'Lag';

  @override
  String get teamA => 'Lag A';

  @override
  String get teamB => 'Lag B';

  @override
  String get autoBalance => 'Fördela automatiskt';

  @override
  String get houseRules => 'Husregler';

  @override
  String get targetScore => 'Målpoäng';

  @override
  String get overshootRule => 'Över målet';

  @override
  String get policyReset => 'Återställ';

  @override
  String get policyHalf => 'Hälften av målet';

  @override
  String get policyNone => 'Ingen påföljd';

  @override
  String get eliminationRule => 'Utslagning';

  @override
  String get missLimit => 'Missar till utslagning';

  @override
  String get shuffleOrder => 'Blanda ordningen';

  @override
  String get startGame => 'Starta match';

  @override
  String get needTwoPlayers => 'Lägg till minst 2 spelare';

  @override
  String get needBothTeams => 'Båda lagen behöver en spelare';

  @override
  String get custom => 'Anpassad';
}
