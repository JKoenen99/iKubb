// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Kaato';

  @override
  String get tagline => 'Het nummerkubb-scorebord';

  @override
  String get startScoring => 'Ik ken de regels, start met scoren';

  @override
  String get teachMe => 'Leer mij het spel';

  @override
  String get quickStart => 'Snel starten';

  @override
  String get newGame => 'Nieuw spel';

  @override
  String get rules => 'Regels';

  @override
  String get stats => 'Statistieken';

  @override
  String get miss => 'Mis';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String needsExactly(int points) {
    return 'Heeft precies $points nodig';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Te veel — terug naar $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name wint!';
  }

  @override
  String get players => 'Spelers';

  @override
  String get addPlayer => 'Speler toevoegen';

  @override
  String get teams => 'Teams';

  @override
  String get teamA => 'Team A';

  @override
  String get teamB => 'Team B';

  @override
  String get autoBalance => 'Automatisch verdelen';

  @override
  String get houseRules => 'Huisregels';

  @override
  String get targetScore => 'Doelscore';

  @override
  String policyReset(int score) {
    return 'Terug naar $score';
  }

  @override
  String get policyHalf => 'Helft van doel';

  @override
  String get policyNone => 'Geen straf';

  @override
  String get eliminationRule => 'Uitschakeling';

  @override
  String get missLimit => 'Missers tot uitschakeling';

  @override
  String get shuffleOrder => 'Volgorde schudden';

  @override
  String get startGame => 'Start spel';

  @override
  String get needTwoPlayers => 'Voeg minstens 2 spelers toe';

  @override
  String get needBothTeams => 'Beide teams hebben een speler nodig';

  @override
  String get custom => 'Aangepast';

  @override
  String get rulesSearchHint => 'Zoek in de regels';

  @override
  String get rulesNoResults => 'Geen regels gevonden';

  @override
  String get activeRulesLabel => 'Actieve huisregels';

  @override
  String get catSetup => 'Opstelling & veld';

  @override
  String get catThrowing => 'Werpen';

  @override
  String get catScoring => 'Scoren';

  @override
  String get catOvershoot => 'Te veel & terugvallen';

  @override
  String get catMisses => 'Missers & uitschakeling';

  @override
  String get catWinning => 'Winnen';

  @override
  String get catTeams => 'Teams';

  @override
  String get ruleFormationTitle => 'De opstelling';

  @override
  String get ruleFormationBody =>
      'De 12 genummerde kegels beginnen in een dichte ruitopstelling, op 3 tot 4 meter van de werplijn.';

  @override
  String get rulePinsStandTitle => 'Kegels blijven waar ze vallen';

  @override
  String get rulePinsStandBody =>
      'Na elke worp worden omgevallen kegels rechtop gezet op de plek waar ze terechtkwamen — het veld verspreidt zich tijdens het spel.';

  @override
  String get ruleTurnsTitle => 'Om de beurt';

  @override
  String get ruleTurnsBody =>
      'Spelers gooien om de beurt in vaste volgorde — één stok per worp.';

  @override
  String get ruleUnderhandTitle => 'Onderhands werpen';

  @override
  String get ruleUnderhandBody => 'De stok wordt altijd onderhands gegooid.';

  @override
  String get ruleOnePinTitle => 'Eén kegel om';

  @override
  String get ruleOnePinBody =>
      'Gooi precies één kegel om en je scoort het nummer van die kegel.';

  @override
  String get ruleManyPinsTitle => 'Meerdere kegels om';

  @override
  String get ruleManyPinsBody =>
      'Gooi meerdere kegels om en je scoort het aantal kegels, niet de som.';

  @override
  String get ruleManyPinsDetail =>
      'Voorbeeld: kegels 7, 9 en 12 omgooien levert 3 punten op.';

  @override
  String get ruleLeaningTitle => 'Leunende kegels tellen niet';

  @override
  String get ruleLeaningBody =>
      'Een kegel die op een andere kegel of op de stok leunt, telt niet als omgegooid.';

  @override
  String get ruleOvershootTitle => 'Niet te veel gooien';

  @override
  String get ruleOvershootBody =>
      'Zou je score boven het doel uitkomen, dan val je terug (klassiek: boven de 50 gooien zet je op 25).';

  @override
  String get ruleOvershootDetail =>
      'Huisregels kunnen dit aanpassen: terug naar de helft van het doel, of helemaal geen straf.';

  @override
  String get ruleMissesTitle => 'Drie keer mis en je ligt eruit';

  @override
  String get ruleMissesBody =>
      'Scoor drie beurten op rij niets en je bent uitgeschakeld (als uitschakeling aanstaat).';

  @override
  String get ruleMissesDetail =>
      'De stippen op de scorekaart tellen de missers op rij.';

  @override
  String get ruleExactTitle => 'Raak het doel precies';

  @override
  String get ruleExactBody =>
      'De eerste speler of het eerste team dat precies de doelscore haalt, wint het spel.';

  @override
  String get ruleLastStandingTitle => 'De laatst overgeblevene';

  @override
  String get ruleLastStandingBody =>
      'Als alle anderen zijn uitgeschakeld, wint de laatste speler of het laatste team dat overblijft.';

  @override
  String get ruleTeamsTitle => 'Solo of in teams';

  @override
  String get ruleTeamsBody =>
      'Speel één tegen één of in twee teams — een team deelt één beurt en de leden gooien om en om.';

  @override
  String get rematch => 'Revanche';

  @override
  String get skip => 'Overslaan';

  @override
  String get next => 'Volgende';

  @override
  String get tourTryIt => 'Probeer het — tik op de omgevallen kegels';

  @override
  String get historyTitle => 'Geschiedenis';

  @override
  String get noGamesYet => 'Nog geen spellen — het veld wacht!';

  @override
  String get gamesPlayed => 'Partijen';

  @override
  String get wins => 'Overwinningen';

  @override
  String get winRate => 'Winstpercentage';

  @override
  String get avgPerThrow => 'Punten per worp';

  @override
  String get mostHitPin => 'Vaakst geraakte kegel';

  @override
  String get statMisses => 'Missers';

  @override
  String get statOvershoots => 'Keer te veel';

  @override
  String get statEliminations => 'Uitschakelingen';

  @override
  String get numberPad => 'Cijfertoetsen';

  @override
  String get tapPins => 'Tik op kegels';

  @override
  String get scoreboardMode => 'Scorebord';

  @override
  String get share => 'Delen';

  @override
  String get settings => 'Instellingen';

  @override
  String get language => 'Taal';

  @override
  String get systemDefault => 'Systeem';

  @override
  String get haptics => 'Trillingen';

  @override
  String get keepAwake => 'Scherm aan houden';

  @override
  String get homeLabel => 'Start';

  @override
  String pinSemantics(int number) {
    return 'Kegel $number';
  }

  @override
  String get cancel => 'Annuleren';

  @override
  String get newGameConfirmTitle => 'Nieuw spel starten?';

  @override
  String get newGameConfirmBody => 'Je verliest het spel dat bezig is.';

  @override
  String get theme => 'Thema';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get delete => 'Verwijderen';

  @override
  String get clearHistory => 'Geschiedenis wissen';

  @override
  String get clearHistoryConfirmBody =>
      'Dit wist elk spel en alle statistieken.';

  @override
  String get modeNumber => 'Nummerkubb';

  @override
  String get offLabel => 'Uit';

  @override
  String get done => 'Klaar';

  @override
  String get closeLabel => 'Sluiten';

  @override
  String get increaseLabel => 'Meer';

  @override
  String get decreaseLabel => 'Minder';

  @override
  String missesSemantics(int count, int limit) {
    return '$count van $limit missers';
  }

  @override
  String get statsErrorBody => 'Je statistieken konden niet worden geladen.';

  @override
  String get retryLabel => 'Opnieuw proberen';

  @override
  String get deleteGameLabel => 'Spel verwijderen';

  @override
  String get settingsAppearance => 'Weergave';

  @override
  String get settingsDuringPlay => 'Tijdens het spelen';

  @override
  String get settingsLearn => 'Leren';

  @override
  String get settingsAbout => 'Over';

  @override
  String get designSystemLabel => 'Design system';

  @override
  String get licensesLabel => 'Opensourcelicenties';

  @override
  String confirmThrowCount(int count) {
    return 'Worp bevestigen (+$count)';
  }

  @override
  String resumeGameSummary(String summary) {
    return 'Spel hervatten · $summary';
  }

  @override
  String get deleteGameConfirmBody =>
      'Dit spel wordt uit je geschiedenis verwijderd.';

  @override
  String playerN(int n) {
    return 'Speler $n';
  }

  @override
  String removePlayer(String name) {
    return '$name verwijderen';
  }

  @override
  String get showDetails => 'Meer details';

  @override
  String get opensRuleHint => 'Opent de regel';

  @override
  String get clearSearch => 'Zoekopdracht wissen';

  @override
  String scoredAnnouncement(String name, int points, int total) {
    return '$name scoort $points, nu op $total';
  }

  @override
  String missAnnouncement(String name) {
    return '$name mist';
  }

  @override
  String overshootAnnouncement(String name, int total) {
    return '$name gooit te veel en valt terug naar $total';
  }

  @override
  String eliminatedAnnouncement(String name) {
    return '$name ligt eruit';
  }

  @override
  String get feedbackPromptGameTitle => 'Hoe was het scoren met Kaato?';

  @override
  String get feedbackPromptTourTitle => 'Legde de uitleg het spel goed uit?';

  @override
  String get feedbackSheetTitle => 'Jouw feedback';

  @override
  String get feedbackNotNow => 'Niet nu';

  @override
  String feedbackStarsSemantics(int count) {
    return '$count van 5 sterren';
  }

  @override
  String get feedbackWhatLiked => 'Wat werkte goed?';

  @override
  String get feedbackWhatImprove => 'Wat kan beter?';

  @override
  String get feedbackCommentHint => 'Nog iets? (optioneel)';

  @override
  String get feedbackSubmit => 'Feedback versturen';

  @override
  String get feedbackThanks => 'Dankjewel, hier worden we beter van!';

  @override
  String get feedbackSection => 'Feedback';

  @override
  String get feedbackGive => 'Feedback geven';

  @override
  String get feedbackGiveSubtitle => 'Vertel de maker wat beter kan';

  @override
  String get feedbackPrivacyNote =>
      'Anoniem: we bewaren alleen je beoordeling, tags, opmerking en de appversie.';

  @override
  String get tagEasyScoring => 'Makkelijk scoren';

  @override
  String get tagRulesHelpful => 'Regels hielpen';

  @override
  String get tagLooksGreat => 'Ziet er goed uit';

  @override
  String get tagFast => 'Snel';

  @override
  String get tagStatsFun => 'Statistieken zijn leuk';

  @override
  String get tagShareCard => 'Deelkaart';

  @override
  String get tagConfusing => 'Verwarrend';

  @override
  String get tagMissingFeature => 'Mist een functie';

  @override
  String get tagBug => 'Er ging iets kapot';

  @override
  String get tagTooManyTaps => 'Te veel tikken';

  @override
  String get tagRulesUnclear => 'Regels onduidelijk';

  @override
  String get tagTranslation => 'Vertaalfout';

  @override
  String get tagOther => 'Anders';

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelers',
      one: '1 speler',
    );
    return '$_temp0';
  }

  @override
  String get namesOptionalHint =>
      'Namen zijn optioneel. Tik op een naam om die te wijzigen.';

  @override
  String get recentLabel => 'Recent';

  @override
  String get teamsOffDesc => 'Iedereen speelt voor zichzelf.';

  @override
  String get teamsOnDesc =>
      'De score telt per team. Tik op een pil om een speler te verplaatsen.';

  @override
  String get swapTeams => 'Teams wisselen';

  @override
  String moveToTeam(String name, String team) {
    return '$name naar $team verplaatsen';
  }

  @override
  String get resetLabel => 'Herstellen';

  @override
  String get targetScoreDesc => 'Precies raken om te winnen';

  @override
  String get backToLabel => 'Terug naar';

  @override
  String get backToDesc => 'Score als je te veel gooit';

  @override
  String get eliminationDesc => 'Missers op rij voor je eruit ligt';

  @override
  String summaryFirstTo(int target) {
    return 'eerst naar $target';
  }

  @override
  String summaryBackTo(int reset) {
    return 'terug naar $reset';
  }

  @override
  String summaryOutAfter(int misses) {
    return 'eruit na $misses missers';
  }

  @override
  String get summaryNoPenalty => 'geen straf';

  @override
  String get summaryNoElimination => 'geen uitschakeling';

  @override
  String get summaryInTeams => 'in teams';

  @override
  String get editValueTitle => 'Voer een waarde in';

  @override
  String renamePlayer(String name) {
    return '$name hernoemen';
  }

  @override
  String appVersionLabel(String version) {
    return 'Versie $version';
  }

  @override
  String appVersionWithCommit(String version, String commit) {
    return 'Versie $version, commit $commit';
  }
}
