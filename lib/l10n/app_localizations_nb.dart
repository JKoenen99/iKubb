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
  String get tagline => 'Kubb-resultattavlen';

  @override
  String get startScoring => 'Jeg kan reglene, start poengføringen';

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
  String policyReset(Object score) {
    return 'Tilbake til $score';
  }

  @override
  String get policyHalf => 'Halvparten av målet';

  @override
  String get policyNone => 'Ingen straff';

  @override
  String get eliminationRule => 'Utslagning';

  @override
  String get missLimit => 'Bom før eliminering';

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
  String get activeRulesLabel => 'Gjeldende husregler';

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
      'Spillerne bytter på i fast rekkefølge — én pinne per kast.';

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
      'En kjegle som hviler på en annen kjegle eller på pinnen, teller ikke som veltet.';

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
      'Prikkene på poengkortet teller bommene på rad.';

  @override
  String get ruleExactTitle => 'Treff målet nøyaktig';

  @override
  String get ruleExactBody =>
      'Den spilleren eller det laget som først når målpoengsummen nøyaktig, vinner spillet.';

  @override
  String get ruleLastStandingTitle => 'Sistemann igjen';

  @override
  String get ruleLastStandingBody =>
      'Hvis alle andre er slått ut, vinner den siste spilleren eller det siste laget.';

  @override
  String get ruleTeamsTitle => 'Alene eller i lag';

  @override
  String get ruleTeamsBody =>
      'Spill én mot én eller i to lag — laget deler én tur, og medlemmene bytter på å kaste.';

  @override
  String get rematch => 'Omkamp';

  @override
  String get skip => 'Hopp over';

  @override
  String get next => 'Neste';

  @override
  String get tourTryIt => 'Prøv selv — trykk på kjeglene som veltet';

  @override
  String get historyTitle => 'Historikk';

  @override
  String get noGamesYet => 'Ingen spill ennå — banen venter!';

  @override
  String get gamesPlayed => 'Spill';

  @override
  String get wins => 'Seire';

  @override
  String get winRate => 'Seiersrate';

  @override
  String get avgPerThrow => 'Poeng per kast';

  @override
  String get mostHitPin => 'Oftest trufne kjegle';

  @override
  String get statMisses => 'Bom';

  @override
  String get statOvershoots => 'Over målet';

  @override
  String get statEliminations => 'Utslagninger';

  @override
  String get numberPad => 'Talltastatur';

  @override
  String get tapPins => 'Trykk på kjegler';

  @override
  String get scoreboardMode => 'Resultattavle';

  @override
  String get share => 'Del';

  @override
  String get settings => 'Innstillinger';

  @override
  String get language => 'Språk';

  @override
  String get systemDefault => 'System';

  @override
  String get haptics => 'Haptikk';

  @override
  String get keepAwake => 'Hold skjermen på';

  @override
  String get homeLabel => 'Hjem';

  @override
  String pinSemantics(int number) {
    return 'Kjegle $number';
  }

  @override
  String get cancel => 'Avbryt';

  @override
  String get newGameConfirmTitle => 'Starte et nytt spill?';

  @override
  String get newGameConfirmBody => 'Du mister spillet som pågår.';

  @override
  String get resumeGame => 'Fortsett spillet';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Lyst';

  @override
  String get themeDark => 'Mørkt';

  @override
  String get delete => 'Slett';

  @override
  String get clearHistory => 'Tøm historikk';

  @override
  String get clearHistoryConfirmBody =>
      'Dette fjerner alle spill og all statistikk.';

  @override
  String get modeNumber => 'Nummerkubb';

  @override
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Match';

  @override
  String get bestOfSingle => 'Ett parti';

  @override
  String get bestOfThree => 'Best av 3';

  @override
  String get turnClockLabel => 'Kasteklokke';

  @override
  String get offLabel => 'Av';

  @override
  String get kingLabel => 'Kongen';

  @override
  String get kingWarningTitle => 'Velte kongen?';

  @override
  String get kingWarningBody =>
      'Alt er ikke nede ennå — å treffe kongen nå taper partiet.';

  @override
  String get advantageLine => 'Fordelslinje';

  @override
  String get throwInTitle =>
      'Kast de veltede kubbene inn i angripernes halvdel.';

  @override
  String get outTwice => 'Straffekubber (ute to ganger)';

  @override
  String get done => 'Ferdig';

  @override
  String get nextGameLabel => 'Neste parti';

  @override
  String earlyKingBanner(String name) {
    return '$name veltet kongen for tidlig!';
  }

  @override
  String get catKubbSetup => 'Oppstilling & lag';

  @override
  String get catKubbBatons => 'Kastepinner';

  @override
  String get catKubbFieldKubbs => 'Feltkubber';

  @override
  String get catKubbKing => 'Kongen';

  @override
  String get ruleKubbFieldTitle => 'Banen';

  @override
  String get ruleKubbFieldBody =>
      'To lag står overfor hverandre på banen. Hvert lag setter fem kubber på sin baklinje, og kongen står alene i midten.';

  @override
  String get ruleKubbFieldDetail =>
      'Turneringsbaner måler 5 × 8 meter. I parken holder det med to jakker og godt øyemål — bare hold halvdelene omtrent like store.';

  @override
  String get ruleKubbTeamsTitle => 'Én til seks per lag';

  @override
  String get ruleKubbTeamsBody =>
      'Kubb er et lagspill: én til seks spillere per side. Lagkameratene deler de seks kastepinnene og kaster etter tur.';

  @override
  String get ruleKubbBatonsTitle => 'Seks pinner per tur';

  @override
  String get ruleKubbBatonsBody =>
      'Det angripende laget kaster seks pinner mot motstandernes kubber — underarms, roterende rundt kortaksen.';

  @override
  String get ruleKubbBatonsDetail =>
      'Ingen helikopterkast: pinnen må rotere vertikalt, aldri sidelengs. Veltede kubber blir liggende til turen er over.';

  @override
  String get ruleKubbThrowInTitle => 'Veltede kubber kommer tilbake';

  @override
  String get ruleKubbThrowInBody =>
      'Etter pinnene kaster forsvarerne hver veltede kubb inn i angripernes halvdel. Der en kubb lander, reises den som feltkubb.';

  @override
  String get ruleKubbThrowInDetail =>
      'Forsvarerne velger hvor de sikter — kubber som står tett sammen, er mye lettere å rydde med én pinne.';

  @override
  String get ruleKubbFieldFirstTitle => 'Feltkubber først';

  @override
  String get ruleKubbFieldFirstBody =>
      'Angriperne må velte alle stående feltkubber før en baklinjekubb kan treffes. En baklinjekubb som veltes for tidlig, reises igjen.';

  @override
  String get ruleKubbPenaltyTitle => 'Ute to ganger = straffekubb';

  @override
  String get ruleKubbPenaltyBody =>
      'En kubb som kastes utenfor banen to ganger, blir en straffekubb: det andre laget plasserer den fritt i sin halvdel — til og med rett ved kongen.';

  @override
  String get ruleKubbAdvantageTitle => 'Fordelslinjen';

  @override
  String get ruleKubbAdvantageBody =>
      'Lar motstanderne feltkubber stå i deres halvdel, kan laget deres kaste pinnene fra høyde med kubben som står nærmest kongen.';

  @override
  String get ruleKubbKingTitle => 'Kongen avgjør';

  @override
  String get ruleKubbKingBody =>
      'Først når hver kubb i den forsvarende halvdelen ligger nede, kan du sikte på kongen. Velter du ham, er spillet deres.';

  @override
  String get ruleKubbEarlyKingTitle => 'Ikke før linjen ligger nede';

  @override
  String get ruleKubbEarlyKingBody =>
      'Velter du kongen før alt annet ligger nede — også ved et uhell — taper laget ditt spillet på stedet.';

  @override
  String get ruleKubbMatchTitle => 'Best av tre';

  @override
  String get ruleKubbMatchBody =>
      'I turneringer spilles en kamp best av tre. Lagene bytter på hvem som åpner hvert spill.';

  @override
  String get ruleKubbMatchDetail =>
      'Med turklokken på har laget en fast tid på sine seks pinner. Klokken er veiledende — appen blokkerer aldri et kast.';

  @override
  String get tourModePickTitle => 'Hvilket spill spiller dere?';

  @override
  String get tourModePickBody =>
      'Begge finnes i denne appen. Velg ett å lære — du kan bytte når som helst.';

  @override
  String get tourModeNumberDesc =>
      'Tolv nummererte kjegler. Kappløp til nøyaktig 50.';

  @override
  String get tourModeKubbDesc => 'To lag, fem kubber hver — og kongen.';

  @override
  String get statKingsFelled => 'Konger veltet';

  @override
  String get statKubbsPerBaton => 'Kubber per pinne';

  @override
  String get statAdvantageTurns => 'Fordelsturer';

  @override
  String get statEarlyKings => 'For tidlige konger';

  @override
  String get filterAll => 'Alle';

  @override
  String get closeLabel => 'Lukk';

  @override
  String get increaseLabel => 'Mer';

  @override
  String get decreaseLabel => 'Mindre';

  @override
  String kubbStandingSemantics(Object number) {
    return 'Kubb $number, står';
  }

  @override
  String kubbSelectedSemantics(Object number) {
    return 'Kubb $number, merket som veltet';
  }

  @override
  String kubbFelledSemantics(Object number) {
    return 'Kubb $number, nede';
  }

  @override
  String get kingSafeSemantics => 'Kongen — velt ham og vinn';

  @override
  String get kingRiskySemantics => 'Kongen — å treffe ham nå taper spillet';

  @override
  String batonsLeftSemantics(Object remaining, Object total) {
    return '$remaining av $total pinner igjen';
  }

  @override
  String missesSemantics(Object count, Object limit) {
    return '$count av $limit bom';
  }

  @override
  String get statsErrorBody => 'Statistikken din kunne ikke lastes.';

  @override
  String get retryLabel => 'Prøv igjen';

  @override
  String get deleteGameLabel => 'Slett spill';

  @override
  String get newMatchConfirmTitle => 'Starte en ny kamp?';

  @override
  String get newMatchConfirmBody => 'Du mister kampen som pågår.';

  @override
  String get settingsAppearance => 'Utseende';

  @override
  String get settingsDuringPlay => 'Under spill';

  @override
  String get settingsLearn => 'Lær';

  @override
  String get settingsAbout => 'Om';

  @override
  String get designSystemLabel => 'Designsystem';

  @override
  String get licensesLabel => 'Åpen kildekode-lisenser';

  @override
  String confirmThrowCount(Object count) {
    return 'Bekreft kast (+$count)';
  }

  @override
  String resumeGameSummary(Object summary) {
    return 'Fortsett spillet · $summary';
  }

  @override
  String matchScore(Object a, Object b) {
    return '$a – $b';
  }

  @override
  String get deleteGameConfirmBody =>
      'Dette spillet fjernes fra historikken din.';
}
