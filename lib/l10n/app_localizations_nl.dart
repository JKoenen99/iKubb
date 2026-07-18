// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Het nummerkubb-scorebord';

  @override
  String get startScoring => 'Ik ken de regels — begin met scoren';

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
  String get confirmThrow => 'Worp bevestigen';

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
  String get comingSoon => 'Binnenkort beschikbaar';

  @override
  String get players => 'Spelers';

  @override
  String get addPlayer => 'Speler toevoegen';

  @override
  String get playerName => 'Naam';

  @override
  String get recentPlayers => 'Recente spelers';

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
  String get overshootRule => 'Te veel gegooid';

  @override
  String get policyReset => 'Terugvallen';

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
  String get activeRulesLabel => 'Dit spel';

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
      'Elke partij gooit één stok per beurt, steeds in dezelfde volgorde.';

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
      'Een kegel die op een andere kegel of op de stok rust, telt niet als omgevallen.';

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
      'De stippen op je spelerskaart houden je misserreeks bij.';

  @override
  String get ruleExactTitle => 'Raak het doel precies';

  @override
  String get ruleExactBody =>
      'De eerste partij die precies de doelscore haalt, wint het spel.';

  @override
  String get ruleLastStandingTitle => 'De laatst overgeblevene';

  @override
  String get ruleLastStandingBody =>
      'Als alle andere partijen zijn uitgeschakeld, wint de overgebleven partij.';

  @override
  String get ruleTeamsTitle => 'Solo of in teams';

  @override
  String get ruleTeamsBody =>
      'Speel één tegen één of in twee teams — een team gooit als één partij, spelers wisselen elkaar af.';

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
  String get avgPerThrow => 'Gem. punten per worp';

  @override
  String get mostHitPin => 'Favoriete kegel';

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
  String get systemDefault => 'Systeemstandaard';

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
  String get newGameConfirmBody => 'Het huidige spel wordt gewist.';
}
