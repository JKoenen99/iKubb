// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Resultattavlen til nummerkubb';

  @override
  String get startScoring => 'Jeg kender reglerne — begynd at score';

  @override
  String get teachMe => 'Lær mig spillet';

  @override
  String get quickStart => 'Hurtig start';

  @override
  String get newGame => 'Nyt spil';

  @override
  String get rules => 'Regler';

  @override
  String get stats => 'Statistik';

  @override
  String get confirmThrow => 'Bekræft kast';

  @override
  String get miss => 'Forbier';

  @override
  String get undo => 'Fortryd';

  @override
  String needsExactly(int points) {
    return 'Skal bruge præcis $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Over målet — tilbage til $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name vinder!';
  }

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get players => 'Spillere';

  @override
  String get addPlayer => 'Tilføj spiller';

  @override
  String get playerName => 'Navn';

  @override
  String get recentPlayers => 'Seneste spillere';

  @override
  String get teams => 'Hold';

  @override
  String get teamA => 'Hold A';

  @override
  String get teamB => 'Hold B';

  @override
  String get autoBalance => 'Fordel automatisk';

  @override
  String get houseRules => 'Husregler';

  @override
  String get targetScore => 'Målscore';

  @override
  String get overshootRule => 'Over målet';

  @override
  String get policyReset => 'Nulstil';

  @override
  String get policyHalf => 'Halvdelen af målet';

  @override
  String get policyNone => 'Ingen straf';

  @override
  String get eliminationRule => 'Udelukkelse';

  @override
  String get missLimit => 'Forbiere før udelukkelse';

  @override
  String get shuffleOrder => 'Bland rækkefølgen';

  @override
  String get startGame => 'Start spil';

  @override
  String get needTwoPlayers => 'Tilføj mindst 2 spillere';

  @override
  String get needBothTeams => 'Begge hold skal have en spiller';

  @override
  String get custom => 'Tilpasset';
}
