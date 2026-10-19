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
  String policyReset(int score) {
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
      'Kubb er et lagspill: én til seks spillere per lag. Lagkameratene deler de seks kastepinnene og kaster etter tur.';

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
      'I turneringer spilles en kamp best av tre. Lagene bytter på hvilket lag som åpner hvert spill.';

  @override
  String get ruleKubbMatchDetail =>
      'Med kasteklokken på har laget en fast tid på sine seks pinner. Klokken er veiledende — appen blokkerer aldri et kast.';

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
  String kubbStandingSemantics(int number) {
    return 'Kubb $number, står';
  }

  @override
  String kubbSelectedSemantics(int number) {
    return 'Kubb $number, merket som veltet';
  }

  @override
  String get kingSafeSemantics => 'Kongen — velt ham og vinn';

  @override
  String get kingRiskySemantics => 'Kongen — å treffe ham nå taper spillet';

  @override
  String batonsLeftSemantics(int remaining, int total) {
    return '$remaining av $total pinner igjen';
  }

  @override
  String missesSemantics(int count, int limit) {
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
  String confirmThrowCount(int count) {
    return 'Bekreft kast (+$count)';
  }

  @override
  String resumeGameSummary(String summary) {
    return 'Fortsett spillet · $summary';
  }

  @override
  String matchScore(int a, int b) {
    return '$a – $b';
  }

  @override
  String get deleteGameConfirmBody =>
      'Dette spillet fjernes fra historikken din.';

  @override
  String get newMatch => 'Ny kamp';

  @override
  String playerN(int n) {
    return 'Spiller $n';
  }

  @override
  String secondsShort(int seconds) {
    return '$seconds s';
  }

  @override
  String removePlayer(String name) {
    return 'Fjern $name';
  }

  @override
  String get showDetails => 'Flere detaljer';

  @override
  String get toppleKing => 'Velt kongen';

  @override
  String turnClockSemantics(int seconds) {
    return '$seconds sekunder igjen på kasteklokken';
  }

  @override
  String baselineStandingSemantics(int count) {
    return '$count grunnlinjekubber står';
  }

  @override
  String get opensRuleHint => 'Åpner regelen';

  @override
  String get clearSearch => 'Tøm søk';

  @override
  String scoredAnnouncement(String name, int points, int total) {
    return '$name scorer $points, nå på $total';
  }

  @override
  String missAnnouncement(String name) {
    return '$name bommer';
  }

  @override
  String overshootAnnouncement(String name, int total) {
    return '$name bommer over og faller til $total';
  }

  @override
  String eliminatedAnnouncement(String name) {
    return '$name er ute';
  }

  @override
  String get feedbackPromptGameTitle => 'Hvordan var det å telle med iKubb?';

  @override
  String get feedbackPromptTourTitle => 'Forklarte omvisningen spillet?';

  @override
  String get feedbackSheetTitle => 'Din tilbakemelding';

  @override
  String get feedbackNotNow => 'Ikke nå';

  @override
  String feedbackStarsSemantics(int count) {
    return '$count av 5 stjerner';
  }

  @override
  String get feedbackWhatLiked => 'Hva fungerte bra?';

  @override
  String get feedbackWhatImprove => 'Hva kunne vært bedre?';

  @override
  String get feedbackCommentHint => 'Noe annet? (valgfritt)';

  @override
  String get feedbackSubmit => 'Send tilbakemelding';

  @override
  String get feedbackThanks => 'Takk, det hjelper oss videre!';

  @override
  String get feedbackSection => 'Tilbakemelding';

  @override
  String get feedbackGive => 'Gi tilbakemelding';

  @override
  String get feedbackGiveSubtitle => 'Fortell utvikleren hva som kan bli bedre';

  @override
  String get feedbackPrivacyNote =>
      'Anonymt: vi lagrer bare vurderingen, taggene, kommentaren og appversjonen.';

  @override
  String get tagEasyScoring => 'Enkel telling';

  @override
  String get tagRulesHelpful => 'Reglene hjalp';

  @override
  String get tagLooksGreat => 'Ser bra ut';

  @override
  String get tagFast => 'Rask';

  @override
  String get tagStatsFun => 'Statistikken er gøy';

  @override
  String get tagShareCard => 'Delekort';

  @override
  String get tagConfusing => 'Forvirrende';

  @override
  String get tagMissingFeature => 'Mangler en funksjon';

  @override
  String get tagBug => 'Noe gikk galt';

  @override
  String get tagTooManyTaps => 'For mange trykk';

  @override
  String get tagRulesUnclear => 'Reglene er uklare';

  @override
  String get tagTranslation => 'Oversettelsesfeil';

  @override
  String get tagOther => 'Annet';

  @override
  String get gameSection => 'Spill';

  @override
  String get modeNumberDesc => 'Poeng per kjegle. Først til målet vinner.';

  @override
  String get modeKubbDesc => 'Klassiske regler. Rydd banen, så kongen.';

  @override
  String modeNumberHint(int target) {
    return 'Poeng per kjegle. Først til $target vinner.';
  }

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillere',
      one: '1 spiller',
    );
    return '$_temp0';
  }

  @override
  String get namesOptionalHint =>
      'Navn er valgfritt. Trykk på et navn for å endre det.';

  @override
  String get recentLabel => 'Nylige';

  @override
  String get teamsOffDesc => 'Alle spiller for seg selv.';

  @override
  String get teamsOnDesc =>
      'Poeng telles per lag. Trykk på en pille for å flytte en spiller.';

  @override
  String get swapTeams => 'Bytt lag';

  @override
  String moveToTeam(String name, String team) {
    return 'Flytt $name til $team';
  }

  @override
  String get resetLabel => 'Tilbakestill';

  @override
  String get targetScoreDesc => 'Treff nøyaktig for å vinne';

  @override
  String get backToLabel => 'Tilbake til';

  @override
  String get backToDesc => 'Poeng når du bommer over';

  @override
  String get eliminationDesc => 'Bom på rad før du er ute';

  @override
  String summaryFirstTo(int target) {
    return 'først til $target';
  }

  @override
  String summaryBackTo(int reset) {
    return 'tilbake til $reset';
  }

  @override
  String summaryOutAfter(int misses) {
    return 'ute etter $misses bom';
  }

  @override
  String get summaryNoPenalty => 'ingen straff';

  @override
  String get summaryNoElimination => 'ingen eliminering';

  @override
  String get summaryInTeams => 'i lag';

  @override
  String get editValueTitle => 'Skriv inn en verdi';

  @override
  String renamePlayer(String name) {
    return 'Gi $name nytt navn';
  }
}
