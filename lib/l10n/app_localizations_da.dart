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

  @override
  String get rulesSearchHint => 'Søg i reglerne';

  @override
  String get rulesNoResults => 'Ingen regler matcher';

  @override
  String get activeRulesLabel => 'Dette spil';

  @override
  String get catSetup => 'Opstilling & bane';

  @override
  String get catThrowing => 'Kast';

  @override
  String get catScoring => 'Point';

  @override
  String get catOvershoot => 'Over målet & nulstilling';

  @override
  String get catMisses => 'Forbiere & udelukkelse';

  @override
  String get catWinning => 'At vinde';

  @override
  String get catTeams => 'Hold';

  @override
  String get ruleFormationTitle => 'Opstillingen';

  @override
  String get ruleFormationBody =>
      'De 12 nummererede kegler starter i en tæt rombe, 3 til 4 meter fra kastelinjen.';

  @override
  String get rulePinsStandTitle => 'Keglerne står, hvor de falder';

  @override
  String get rulePinsStandBody =>
      'Efter hvert kast rejses væltede kegler op, hvor de landede — banen spreder sig i løbet af spillet.';

  @override
  String get ruleTurnsTitle => 'Skiftes til at kaste';

  @override
  String get ruleTurnsBody =>
      'Hver side kaster én pind pr. tur, altid i samme rækkefølge.';

  @override
  String get ruleUnderhandTitle => 'Kast underhånds';

  @override
  String get ruleUnderhandBody => 'Pinden kastes altid underhånds.';

  @override
  String get ruleOnePinTitle => 'Én kegle vælter';

  @override
  String get ruleOnePinBody =>
      'Vælt præcis én kegle, og du scorer keglens nummer.';

  @override
  String get ruleManyPinsTitle => 'Flere kegler vælter';

  @override
  String get ruleManyPinsBody =>
      'Vælt flere kegler, og du scorer antallet af kegler, ikke summen.';

  @override
  String get ruleManyPinsDetail =>
      'Eksempel: at vælte kegle 7, 9 og 12 giver 3 point.';

  @override
  String get ruleLeaningTitle => 'Skæve kegler tæller ikke';

  @override
  String get ruleLeaningBody =>
      'En kegle, der hviler på en anden kegle eller på pinden, tæller ikke som væltet.';

  @override
  String get ruleOvershootTitle => 'Gå ikke over målet';

  @override
  String get ruleOvershootBody =>
      'Hvis din score ville passere målet, falder du tilbage (klassisk: over 50 sætter dig på 25).';

  @override
  String get ruleOvershootDetail =>
      'Husregler kan ændre dette: tilbage til halvdelen af målet eller slet ingen straf.';

  @override
  String get ruleMissesTitle => 'Tre forbiere, og du er ude';

  @override
  String get ruleMissesBody =>
      'Scorer du intet tre ture i træk, er du ude (når udelukkelse er slået til).';

  @override
  String get ruleMissesDetail =>
      'Prikkerne på dit spillerkort viser din forbierstribe.';

  @override
  String get ruleExactTitle => 'Ram målet præcist';

  @override
  String get ruleExactBody =>
      'Den første side, der når præcis målscoren, vinder spillet.';

  @override
  String get ruleLastStandingTitle => 'Sidste side tilbage';

  @override
  String get ruleLastStandingBody =>
      'Hvis alle andre sider er ude, vinder den tilbageværende side.';

  @override
  String get ruleTeamsTitle => 'Solo eller i hold';

  @override
  String get ruleTeamsBody =>
      'Spil en mod en eller i to hold — et hold kaster som én side, og medlemmerne skiftes.';

  @override
  String get rematch => 'Omkamp';

  @override
  String get skip => 'Spring over';

  @override
  String get next => 'Næste';

  @override
  String get tourTryIt => 'Prøv det — tryk på de væltede kegler';

  @override
  String get historyTitle => 'Historik';

  @override
  String get noGamesYet => 'Ingen spil endnu — banen venter!';

  @override
  String get gamesPlayed => 'Spil';

  @override
  String get wins => 'Sejre';

  @override
  String get winRate => 'Sejrsrate';

  @override
  String get avgPerThrow => 'Gns. point pr. kast';

  @override
  String get mostHitPin => 'Favoritkegle';

  @override
  String get statMisses => 'Forbiere';

  @override
  String get statOvershoots => 'Over målet';

  @override
  String get statEliminations => 'Udelukkelser';

  @override
  String get numberPad => 'Taltastatur';

  @override
  String get tapPins => 'Tryk på kegler';

  @override
  String get scoreboardMode => 'Resultattavle';

  @override
  String get share => 'Del';

  @override
  String get settings => 'Indstillinger';

  @override
  String get language => 'Sprog';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get haptics => 'Haptik';

  @override
  String get keepAwake => 'Hold skærmen tændt';

  @override
  String get homeLabel => 'Hjem';

  @override
  String pinSemantics(int number) {
    return 'Kegle $number';
  }
}
