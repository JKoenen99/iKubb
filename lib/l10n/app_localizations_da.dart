// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Kaato';

  @override
  String get tagline => 'Nummerkubb-resultattavlen';

  @override
  String get startScoring => 'Jeg kender reglerne, start med at score';

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
  String get players => 'Spillere';

  @override
  String get addPlayer => 'Tilføj spiller';

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
  String policyReset(int score) {
    return 'Tilbage til $score';
  }

  @override
  String get policyHalf => 'Halvdelen af målet';

  @override
  String get policyNone => 'Ingen straf';

  @override
  String get eliminationRule => 'Udelukkelse';

  @override
  String get missLimit => 'Forbiere før eliminering';

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
  String get activeRulesLabel => 'Gældende husregler';

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
      'Spillerne skiftes i fast rækkefølge — én pind pr. kast.';

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
      'Prikkerne på pointkortet tæller forbierne i træk.';

  @override
  String get ruleExactTitle => 'Ram målet præcist';

  @override
  String get ruleExactBody =>
      'Den spiller eller det hold, der først rammer målscoren præcist, vinder spillet.';

  @override
  String get ruleLastStandingTitle => 'Sidste side tilbage';

  @override
  String get ruleLastStandingBody =>
      'Hvis alle andre er elimineret, vinder den sidste spiller eller det sidste hold.';

  @override
  String get ruleTeamsTitle => 'Solo eller i hold';

  @override
  String get ruleTeamsBody =>
      'Spil en mod en eller i to hold — holdet deler én tur, og medlemmerne skiftes til at kaste.';

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
  String get avgPerThrow => 'Point pr. kast';

  @override
  String get mostHitPin => 'Oftest ramte kegle';

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
  String get systemDefault => 'System';

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

  @override
  String get cancel => 'Annuller';

  @override
  String get newGameConfirmTitle => 'Start et nyt spil?';

  @override
  String get newGameConfirmBody => 'Du mister det igangværende spil.';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Lyst';

  @override
  String get themeDark => 'Mørkt';

  @override
  String get delete => 'Slet';

  @override
  String get clearHistory => 'Ryd historik';

  @override
  String get clearHistoryConfirmBody =>
      'Dette rydder alle spil og al statistik.';

  @override
  String get modeNumber => 'Nummerkubb';

  @override
  String get offLabel => 'Fra';

  @override
  String get done => 'Færdig';

  @override
  String get closeLabel => 'Luk';

  @override
  String get increaseLabel => 'Mere';

  @override
  String get decreaseLabel => 'Mindre';

  @override
  String missesSemantics(int count, int limit) {
    return '$count af $limit forbiere';
  }

  @override
  String get statsErrorBody => 'Din statistik kunne ikke indlæses.';

  @override
  String get retryLabel => 'Prøv igen';

  @override
  String get deleteGameLabel => 'Slet spil';

  @override
  String get settingsAppearance => 'Udseende';

  @override
  String get settingsDuringPlay => 'Under spil';

  @override
  String get settingsLearn => 'Lær';

  @override
  String get settingsAbout => 'Om';

  @override
  String get designSystemLabel => 'Designsystem';

  @override
  String get licensesLabel => 'Open source-licenser';

  @override
  String confirmThrowCount(int count) {
    return 'Bekræft kast (+$count)';
  }

  @override
  String resumeGameSummary(String summary) {
    return 'Genoptag spillet · $summary';
  }

  @override
  String get deleteGameConfirmBody => 'Dette spil fjernes fra din historik.';

  @override
  String playerN(int n) {
    return 'Spiller $n';
  }

  @override
  String removePlayer(String name) {
    return 'Fjern $name';
  }

  @override
  String get showDetails => 'Flere detaljer';

  @override
  String get opensRuleHint => 'Åbner reglen';

  @override
  String get clearSearch => 'Ryd søgning';

  @override
  String scoredAnnouncement(String name, int points, int total) {
    return '$name scorer $points, nu på $total';
  }

  @override
  String missAnnouncement(String name) {
    return '$name rammer forbi';
  }

  @override
  String overshootAnnouncement(String name, int total) {
    return '$name skyder over og falder til $total';
  }

  @override
  String eliminatedAnnouncement(String name) {
    return '$name er ude';
  }

  @override
  String get feedbackPromptGameTitle => 'Hvordan var det at score med Kaato?';

  @override
  String get feedbackPromptTourTitle => 'Forklarede rundturen spillet?';

  @override
  String get feedbackSheetTitle => 'Din feedback';

  @override
  String get feedbackNotNow => 'Ikke nu';

  @override
  String feedbackStarsSemantics(int count) {
    return '$count af 5 stjerner';
  }

  @override
  String get feedbackWhatLiked => 'Hvad fungerede godt?';

  @override
  String get feedbackWhatImprove => 'Hvad kunne være bedre?';

  @override
  String get feedbackCommentHint => 'Andet? (valgfrit)';

  @override
  String get feedbackSubmit => 'Send feedback';

  @override
  String get feedbackThanks => 'Tak, det hjælper os videre!';

  @override
  String get feedbackSection => 'Feedback';

  @override
  String get feedbackGive => 'Giv feedback';

  @override
  String get feedbackGiveSubtitle =>
      'Fortæl udvikleren, hvad der kan blive bedre';

  @override
  String get feedbackPrivacyNote =>
      'Anonymt: vi gemmer kun din vurdering, tags, kommentar og appversionen.';

  @override
  String get tagEasyScoring => 'Nem scoring';

  @override
  String get tagRulesHelpful => 'Reglerne hjalp';

  @override
  String get tagLooksGreat => 'Ser godt ud';

  @override
  String get tagFast => 'Hurtig';

  @override
  String get tagStatsFun => 'Statistik er sjovt';

  @override
  String get tagShareCard => 'Delekort';

  @override
  String get tagConfusing => 'Forvirrende';

  @override
  String get tagMissingFeature => 'Mangler en funktion';

  @override
  String get tagBug => 'Noget gik i stykker';

  @override
  String get tagTooManyTaps => 'For mange tryk';

  @override
  String get tagRulesUnclear => 'Regler uklare';

  @override
  String get tagTranslation => 'Oversættelsesfejl';

  @override
  String get tagOther => 'Andet';

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
      'Navne er valgfrie. Tryk på et navn for at ændre det.';

  @override
  String get recentLabel => 'Seneste';

  @override
  String get teamsOffDesc => 'Alle spiller for sig selv.';

  @override
  String get teamsOnDesc =>
      'Point tæller pr. hold. Tryk på en pille for at flytte en spiller.';

  @override
  String get swapTeams => 'Byt hold';

  @override
  String moveToTeam(String name, String team) {
    return 'Flyt $name til $team';
  }

  @override
  String get resetLabel => 'Nulstil';

  @override
  String get targetScoreDesc => 'Ram det præcist for at vinde';

  @override
  String get backToLabel => 'Tilbage til';

  @override
  String get backToDesc => 'Score, når du skyder over';

  @override
  String get eliminationDesc => 'Forbiere i træk, før du er ude';

  @override
  String summaryFirstTo(int target) {
    return 'først til $target';
  }

  @override
  String summaryBackTo(int reset) {
    return 'tilbage til $reset';
  }

  @override
  String summaryOutAfter(int misses) {
    return 'ude efter $misses forbiere';
  }

  @override
  String get summaryNoPenalty => 'ingen straf';

  @override
  String get summaryNoElimination => 'ingen eliminering';

  @override
  String get summaryInTeams => 'i hold';

  @override
  String get editValueTitle => 'Indtast en værdi';

  @override
  String renamePlayer(String name) {
    return 'Omdøb $name';
  }

  @override
  String appVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String appVersionWithCommit(String version, String commit) {
    return 'Version $version, commit $commit';
  }
}
