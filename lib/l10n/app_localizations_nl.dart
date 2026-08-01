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

  @override
  String get resumeGame => 'Spel hervatten';

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
      'Alle partijen en statistieken worden verwijderd.';

  @override
  String get modeNumber => 'Nummerkubb';

  @override
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Match';

  @override
  String get bestOfSingle => 'Eén partij';

  @override
  String get bestOfThree => 'Best of 3';

  @override
  String get turnClockLabel => 'Beurtklok';

  @override
  String get offLabel => 'Uit';

  @override
  String get kingLabel => 'Koning';

  @override
  String get kingWarningTitle => 'Koning omgooien?';

  @override
  String get kingWarningBody =>
      'Nog niet alles ligt om — de koning nu raken verliest de partij.';

  @override
  String get advantageLine => 'Voordeellijn';

  @override
  String get throwInTitle =>
      'Gooi de gevelde kubbs in de helft van de aanvaller';

  @override
  String get outTwice => 'Twee keer uit';

  @override
  String get done => 'Klaar';

  @override
  String get nextGameLabel => 'Volgende partij';

  @override
  String earlyKingBanner(String name) {
    return '$name gooide de koning te vroeg om!';
  }

  @override
  String get catKubbSetup => 'Opstelling & teams';

  @override
  String get catKubbBatons => 'Werphoutjes';

  @override
  String get catKubbFieldKubbs => 'Veldkubbs';

  @override
  String get catKubbKing => 'De koning';

  @override
  String get ruleKubbFieldTitle => 'Het veld';

  @override
  String get ruleKubbFieldBody =>
      'Twee teams staan tegenover elkaar op het veld. Elk team zet vijf kubbs op zijn achterlijn; de koning staat alleen in het midden.';

  @override
  String get ruleKubbFieldDetail =>
      'Toernooivelden meten 5 × 8 meter. In het park volstaan twee jassen en een goede schatting — houd de helften ongeveer gelijk.';

  @override
  String get ruleKubbTeamsTitle => 'Eén tot zes per team';

  @override
  String get ruleKubbTeamsBody =>
      'Kubb is een teamspel: één tot zes spelers per kant. Teamgenoten verdelen de zes werphoutjes en gooien om de beurt.';

  @override
  String get ruleKubbBatonsTitle => 'Zes houtjes per beurt';

  @override
  String get ruleKubbBatonsBody =>
      'Het aanvallende team gooit zes houtjes naar de kubbs van de tegenstander — onderhands, over de kop draaiend.';

  @override
  String get ruleKubbBatonsDetail =>
      'Geen helikopterworpen: het houtje moet verticaal draaien, nooit zijwaarts. Gevelde kubbs blijven liggen tot de beurt voorbij is.';

  @override
  String get ruleKubbThrowInTitle => 'Gevelde kubbs komen terug';

  @override
  String get ruleKubbThrowInBody =>
      'Na de houtjes gooien de verdedigers elke gevelde kubb in de helft van de aanvallers. Waar een kubb landt, wordt hij rechtop gezet als veldkubb.';

  @override
  String get ruleKubbThrowInDetail =>
      'De verdedigers kiezen waar ze mikken — kubbs die dicht bij elkaar staan, zijn met één houtje veel makkelijker weg te spelen.';

  @override
  String get ruleKubbFieldFirstTitle => 'Veldkubbs eerst';

  @override
  String get ruleKubbFieldFirstBody =>
      'Aanvallers moeten eerst alle staande veldkubbs vellen voordat een achterlijnkubb geraakt mag worden. Een te vroeg gevelde achterlijnkubb wordt weer rechtop gezet.';

  @override
  String get ruleKubbPenaltyTitle => 'Twee keer uit = strafkubb';

  @override
  String get ruleKubbPenaltyBody =>
      'Een kubb die twee keer buiten het veld belandt, wordt een strafkubb: het andere team zet hem waar het wil in zijn helft — zelfs pal naast de koning.';

  @override
  String get ruleKubbAdvantageTitle => 'De voordeellijn';

  @override
  String get ruleKubbAdvantageBody =>
      'Laten je tegenstanders veldkubbs in jouw helft staan, dan mag jouw team de houtjes gooien vanaf de kubb die het dichtst bij de koning staat.';

  @override
  String get ruleKubbKingTitle => 'De koning beslist';

  @override
  String get ruleKubbKingBody =>
      'Pas als elke kubb in de verdedigende helft ligt, mag je op de koning mikken. Vel hem, en het spel is van jou.';

  @override
  String get ruleKubbEarlyKingTitle => 'Nooit te vroeg';

  @override
  String get ruleKubbEarlyKingBody =>
      'Gooi je de koning om voordat al het andere ligt — ook per ongeluk — dan verliest je team het spel op slag.';

  @override
  String get ruleKubbMatchTitle => 'Best of three';

  @override
  String get ruleKubbMatchBody =>
      'Op toernooien is een wedstrijd best of three. De teams wisselen af wie elk spel opent.';

  @override
  String get ruleKubbMatchDetail =>
      'Met de beurtklok aan heeft een team een vaste tijd om zijn zes houtjes te gooien. De klok is een richtlijn — de app blokkeert nooit een worp.';

  @override
  String get tourModePickTitle => 'Welk spel speel je?';

  @override
  String get tourModePickBody =>
      'Beide zitten in deze app. Kies er één om te leren — wisselen kan altijd.';

  @override
  String get tourModeNumberDesc =>
      'Twaalf genummerde kegels. Race naar precies 50.';

  @override
  String get tourModeKubbDesc => 'Twee teams, elk vijf kubbs — en de koning.';

  @override
  String get statKingsFelled => 'Koningen geveld';

  @override
  String get statKubbsPerBaton => 'Kubbs per houtje';

  @override
  String get statAdvantageTurns => 'Voordeelbeurten';

  @override
  String get statEarlyKings => 'Vroege koningen';

  @override
  String get filterAll => 'Alles';

  @override
  String get closeLabel => 'Sluiten';

  @override
  String get increaseLabel => 'Meer';

  @override
  String get decreaseLabel => 'Minder';

  @override
  String kubbStandingSemantics(Object number) {
    return 'Kubb $number, staat';
  }

  @override
  String kubbSelectedSemantics(Object number) {
    return 'Kubb $number, gemarkeerd als omgegooid';
  }

  @override
  String kubbFelledSemantics(Object number) {
    return 'Kubb $number, ligt om';
  }

  @override
  String get kingSafeSemantics => 'De koning — vel hem en win';

  @override
  String get kingRiskySemantics => 'De koning — hem nu raken verliest het spel';

  @override
  String batonsLeftSemantics(Object remaining, Object total) {
    return '$remaining van $total houtjes over';
  }

  @override
  String missesSemantics(Object count, Object limit) {
    return '$count van $limit missers';
  }

  @override
  String get statsErrorBody => 'Je statistieken konden niet worden geladen.';

  @override
  String get retryLabel => 'Opnieuw proberen';

  @override
  String get deleteGameLabel => 'Spel verwijderen';

  @override
  String get newMatchConfirmTitle => 'Nieuwe wedstrijd starten?';

  @override
  String get newMatchConfirmBody => 'Je verliest de wedstrijd die bezig is.';

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
  String confirmThrowCount(Object count) {
    return 'Worp bevestigen (+$count)';
  }

  @override
  String resumeGameSummary(Object summary) {
    return 'Spel hervatten · $summary';
  }

  @override
  String matchScore(Object a, Object b) {
    return '$a – $b';
  }
}
