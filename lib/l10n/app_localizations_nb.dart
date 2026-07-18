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

  @override
  String get rulesSearchHint => 'Søk i reglene';

  @override
  String get rulesNoResults => 'Ingen regler samsvarer';

  @override
  String get activeRulesLabel => 'Dette spillet';

  @override
  String get catSetup => 'Oppsett & bane';

  @override
  String get catThrowing => 'Kasting';

  @override
  String get catScoring => 'Poeng';

  @override
  String get catOvershoot => 'Over målet & tilbakestilling';

  @override
  String get catMisses => 'Bom & utslagning';

  @override
  String get catWinning => 'Å vinne';

  @override
  String get catTeams => 'Lag';

  @override
  String get ruleFormationTitle => 'Oppstillingen';

  @override
  String get ruleFormationBody =>
      'De 12 nummererte kjeglene starter i en tett rombe, 3 til 4 meter fra kastelinjen.';

  @override
  String get rulePinsStandTitle => 'Kjeglene står der de faller';

  @override
  String get rulePinsStandBody =>
      'Etter hvert kast reises veltede kjegler opp der de landet — banen sprer seg utover i spillet.';

  @override
  String get ruleTurnsTitle => 'Kast etter tur';

  @override
  String get ruleTurnsBody =>
      'Hver side kaster én pinne per tur, alltid i samme rekkefølge.';

  @override
  String get ruleUnderhandTitle => 'Kast under hånden';

  @override
  String get ruleUnderhandBody => 'Pinnen kastes alltid under hånden.';

  @override
  String get ruleOnePinTitle => 'Én kjegle velter';

  @override
  String get ruleOnePinBody =>
      'Velt nøyaktig én kjegle og du scorer kjeglens nummer.';

  @override
  String get ruleManyPinsTitle => 'Flere kjegler velter';

  @override
  String get ruleManyPinsBody =>
      'Velt flere kjegler og du scorer antallet kjegler, ikke summen.';

  @override
  String get ruleManyPinsDetail =>
      'Eksempel: å velte kjegle 7, 9 og 12 gir 3 poeng.';

  @override
  String get ruleLeaningTitle => 'Lente kjegler teller ikke';

  @override
  String get ruleLeaningBody =>
      'En kjegle som hviler på en annen kjegle eller på pinnen, regnes ikke som veltet.';

  @override
  String get ruleOvershootTitle => 'Ikke gå over målet';

  @override
  String get ruleOvershootBody =>
      'Hvis poengsummen din ville passere målet, faller du tilbake (klassisk: over 50 setter deg på 25).';

  @override
  String get ruleOvershootDetail =>
      'Husregler kan endre dette: tilbake til halvparten av målet, eller ingen straff i det hele tatt.';

  @override
  String get ruleMissesTitle => 'Tre bom og du er ute';

  @override
  String get ruleMissesBody =>
      'Scorer du ingenting tre turer på rad, er du slått ut (når utslagning er på).';

  @override
  String get ruleMissesDetail =>
      'Prikkene på spillerkortet viser bomrekken din.';

  @override
  String get ruleExactTitle => 'Treff målet nøyaktig';

  @override
  String get ruleExactBody =>
      'Den første siden som når nøyaktig målpoengene, vinner spillet.';

  @override
  String get ruleLastStandingTitle => 'Sistemann igjen';

  @override
  String get ruleLastStandingBody =>
      'Hvis alle andre sider er slått ut, vinner siden som er igjen.';

  @override
  String get ruleTeamsTitle => 'Alene eller i lag';

  @override
  String get ruleTeamsBody =>
      'Spill én mot én eller i to lag — et lag kaster som én side, og medlemmene bytter på.';
}
