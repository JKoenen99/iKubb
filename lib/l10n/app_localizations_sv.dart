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

  @override
  String get rulesSearchHint => 'Sök bland reglerna';

  @override
  String get rulesNoResults => 'Inga regler matchar';

  @override
  String get activeRulesLabel => 'Denna match';

  @override
  String get catSetup => 'Uppställning & plan';

  @override
  String get catThrowing => 'Kast';

  @override
  String get catScoring => 'Poäng';

  @override
  String get catOvershoot => 'Över målet & återställning';

  @override
  String get catMisses => 'Missar & utslagning';

  @override
  String get catWinning => 'Vinna';

  @override
  String get catTeams => 'Lag';

  @override
  String get ruleFormationTitle => 'Uppställningen';

  @override
  String get ruleFormationBody =>
      'De 12 numrerade käglorna börjar i en tät romb, 3 till 4 meter från kastlinjen.';

  @override
  String get rulePinsStandTitle => 'Käglorna står där de faller';

  @override
  String get rulePinsStandBody =>
      'Efter varje kast ställs fallna käglor upp där de landade — planen sprider sig under spelets gång.';

  @override
  String get ruleTurnsTitle => 'Turas om';

  @override
  String get ruleTurnsBody =>
      'Varje sida kastar en pinne per tur, alltid i samma ordning.';

  @override
  String get ruleUnderhandTitle => 'Kasta underifrån';

  @override
  String get ruleUnderhandBody => 'Pinnen kastas alltid underifrån.';

  @override
  String get ruleOnePinTitle => 'En kägla faller';

  @override
  String get ruleOnePinBody =>
      'Fäll exakt en kägla och du får käglans nummer i poäng.';

  @override
  String get ruleManyPinsTitle => 'Flera käglor faller';

  @override
  String get ruleManyPinsBody =>
      'Fäll flera käglor och du får antalet käglor, inte summan.';

  @override
  String get ruleManyPinsDetail =>
      'Exempel: att fälla 7, 9 och 12 ger 3 poäng.';

  @override
  String get ruleLeaningTitle => 'Lutande käglor räknas inte';

  @override
  String get ruleLeaningBody =>
      'En kägla som vilar mot en annan kägla eller pinnen räknas inte som fälld.';

  @override
  String get ruleOvershootTitle => 'Gå inte över målet';

  @override
  String get ruleOvershootBody =>
      'Om din poäng skulle passera målet faller du tillbaka (klassiskt: över 50 sätter dig på 25).';

  @override
  String get ruleOvershootDetail =>
      'Husregler kan ändra detta: tillbaka till halva målet, eller ingen påföljd alls.';

  @override
  String get ruleMissesTitle => 'Tre missar och du åker ut';

  @override
  String get ruleMissesBody =>
      'Missa tre turer i rad och du är utslagen (när utslagning är på).';

  @override
  String get ruleMissesDetail =>
      'Prickarna på ditt spelarkort visar din missvit.';

  @override
  String get ruleExactTitle => 'Träffa målet exakt';

  @override
  String get ruleExactBody =>
      'Den första sidan som når exakt målpoängen vinner matchen.';

  @override
  String get ruleLastStandingTitle => 'Sist kvar vinner';

  @override
  String get ruleLastStandingBody =>
      'Om alla andra sidor slagits ut vinner den som är kvar.';

  @override
  String get ruleTeamsTitle => 'Solo eller i lag';

  @override
  String get ruleTeamsBody =>
      'Spela en mot en eller i två lag — ett lag kastar som en sida och medlemmarna turas om.';

  @override
  String get rematch => 'Returmatch';

  @override
  String get skip => 'Hoppa över';

  @override
  String get next => 'Nästa';

  @override
  String get tourTryIt => 'Prova — tryck på käglorna som föll';

  @override
  String get historyTitle => 'Historik';

  @override
  String get noGamesYet => 'Inga matcher än — planen väntar!';

  @override
  String get gamesPlayed => 'Matcher';

  @override
  String get wins => 'Segrar';

  @override
  String get winRate => 'Vinstandel';

  @override
  String get avgPerThrow => 'Snittpoäng per kast';

  @override
  String get mostHitPin => 'Favoritkägla';

  @override
  String get statMisses => 'Missar';

  @override
  String get statOvershoots => 'Över målet';

  @override
  String get statEliminations => 'Utslagningar';

  @override
  String get numberPad => 'Sifferknappar';

  @override
  String get tapPins => 'Tryck på käglor';

  @override
  String get scoreboardMode => 'Resultattavla';

  @override
  String get share => 'Dela';

  @override
  String get settings => 'Inställningar';

  @override
  String get language => 'Språk';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get haptics => 'Haptik';

  @override
  String get keepAwake => 'Håll skärmen tänd';

  @override
  String get homeLabel => 'Hem';

  @override
  String pinSemantics(int number) {
    return 'Kägla $number';
  }

  @override
  String get cancel => 'Avbryt';

  @override
  String get newGameConfirmTitle => 'Starta en ny match?';

  @override
  String get newGameConfirmBody => 'Den pågående matchen kastas.';

  @override
  String get resumeGame => 'Fortsätt matchen';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get delete => 'Radera';

  @override
  String get clearHistory => 'Rensa historik';

  @override
  String get clearHistoryConfirmBody =>
      'Alla matcher och all statistik raderas.';

  @override
  String get modeNumber => 'Nummerkubb';

  @override
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Match';

  @override
  String get bestOfSingle => 'Ett parti';

  @override
  String get bestOfThree => 'Bäst av 3';

  @override
  String get turnClockLabel => 'Kastklocka';

  @override
  String get offLabel => 'Av';

  @override
  String get kingLabel => 'Kungen';

  @override
  String get kingWarningTitle => 'Fälla kungen?';

  @override
  String get kingWarningBody =>
      'Allt är inte nere än — att träffa kungen nu förlorar partiet.';

  @override
  String get advantageLine => 'Fördelslinje';

  @override
  String get throwInTitle => 'Kasta in de fällda kubbarna i anfallarens halva';

  @override
  String get outTwice => 'Ut två gånger';

  @override
  String get done => 'Klar';

  @override
  String get nextGameLabel => 'Nästa parti';

  @override
  String earlyKingBanner(String name) {
    return '$name fällde kungen för tidigt!';
  }

  @override
  String get catKubbSetup => 'Uppställning & lag';

  @override
  String get catKubbBatons => 'Kastpinnar';

  @override
  String get catKubbFieldKubbs => 'Fältkubbar';

  @override
  String get catKubbKing => 'Kungen';

  @override
  String get ruleKubbFieldTitle => 'Planen';

  @override
  String get ruleKubbFieldBody =>
      'Två lag står mitt emot varandra på planen. Varje lag ställer fem kubbar på sin baslinje, och kungen står ensam i mitten.';

  @override
  String get ruleKubbFieldDetail =>
      'Turneringsplaner mäter 5 × 8 meter. I parken räcker två jackor och ögonmått — håll bara halvorna ungefär lika stora.';

  @override
  String get ruleKubbTeamsTitle => 'En till sex per lag';

  @override
  String get ruleKubbTeamsBody =>
      'Kubb är ett lagspel: en till sex spelare per sida. Lagkamraterna delar på de sex kastpinnarna och turas om att kasta.';

  @override
  String get ruleKubbBatonsTitle => 'Sex pinnar per omgång';

  @override
  String get ruleKubbBatonsBody =>
      'Det anfallande laget kastar sex pinnar mot motståndarnas kubbar — underifrån, roterande ände över ände.';

  @override
  String get ruleKubbBatonsDetail =>
      'Inga helikopterkast: pinnen måste rotera vertikalt, aldrig i sidled. Fällda kubbar ligger kvar tills omgången är slut.';

  @override
  String get ruleKubbThrowInTitle => 'Fällda kubbar kommer tillbaka';

  @override
  String get ruleKubbThrowInBody =>
      'Efter pinnarna kastar försvararna varje fälld kubb in i anfallarnas halva. Där en kubb landar reses den som fältkubb.';

  @override
  String get ruleKubbThrowInDetail =>
      'Försvararna väljer var de siktar — kubbar som står tätt ihop är mycket lättare att fälla med en enda pinne.';

  @override
  String get ruleKubbFieldFirstTitle => 'Fältkubbar först';

  @override
  String get ruleKubbFieldFirstBody =>
      'Anfallarna måste fälla alla stående fältkubbar innan någon baslinjekubb får träffas. En baslinjekubb som fälls för tidigt reses igen.';

  @override
  String get ruleKubbPenaltyTitle => 'Ut två gånger = straffkubb';

  @override
  String get ruleKubbPenaltyBody =>
      'En kubb som kastas utanför planen två gånger blir en straffkubb: motståndarlaget ställer den var som helst i sin halva — till och med alldeles intill kungen.';

  @override
  String get ruleKubbAdvantageTitle => 'Fördelslinjen';

  @override
  String get ruleKubbAdvantageBody =>
      'Om motståndarna lämnar fältkubbar stående i er halva får ert lag kasta pinnarna i höjd med den kubb som står närmast kungen.';

  @override
  String get ruleKubbKingTitle => 'Kungen avgör';

  @override
  String get ruleKubbKingBody =>
      'Först när varje kubb i den försvarande halvan ligger ner får du sikta på kungen. Fäller du honom är spelet ert.';

  @override
  String get ruleKubbEarlyKingTitle => 'Aldrig för tidigt';

  @override
  String get ruleKubbEarlyKingBody =>
      'Välter du kungen innan allt annat ligger ner — även av misstag — förlorar ert lag spelet på fläcken.';

  @override
  String get ruleKubbMatchTitle => 'Bäst av tre';

  @override
  String get ruleKubbMatchBody =>
      'I turneringar spelas en match i bäst av tre. Lagen turas om att öppna varje spel.';

  @override
  String get ruleKubbMatchDetail =>
      'Med omgångsklockan på har laget en bestämd tid för sina sex pinnar. Klockan är en riktlinje — appen stoppar aldrig ett kast.';

  @override
  String get tourModePickTitle => 'Vilket spel spelar ni?';

  @override
  String get tourModePickBody =>
      'Båda finns i den här appen. Välj ett att lära dig — du kan byta när som helst.';

  @override
  String get tourModeNumberDesc =>
      'Tolv numrerade käglor. Först till exakt 50.';

  @override
  String get tourModeKubbDesc => 'Två lag, fem kubbar var — och kungen.';

  @override
  String get statKingsFelled => 'Fällda kungar';

  @override
  String get statKubbsPerBaton => 'Kubbar per pinne';

  @override
  String get statAdvantageTurns => 'Fördelsomgångar';

  @override
  String get statEarlyKings => 'För tidiga kungar';

  @override
  String get filterAll => 'Alla';
}
