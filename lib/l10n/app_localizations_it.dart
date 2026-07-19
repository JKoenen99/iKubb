// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Il segnapunti del kubb numerato';

  @override
  String get startScoring => 'Conosco le regole — inizia a segnare';

  @override
  String get teachMe => 'Insegnami il gioco';

  @override
  String get quickStart => 'Avvio rapido';

  @override
  String get newGame => 'Nuova partita';

  @override
  String get rules => 'Regole';

  @override
  String get stats => 'Statistiche';

  @override
  String get confirmThrow => 'Conferma il lancio';

  @override
  String get miss => 'Mancato';

  @override
  String get undo => 'Annulla';

  @override
  String needsExactly(int points) {
    return 'Servono esattamente $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Superato — si torna a $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name vince!';
  }

  @override
  String get comingSoon => 'In arrivo';

  @override
  String get players => 'Giocatori';

  @override
  String get addPlayer => 'Aggiungi giocatore';

  @override
  String get playerName => 'Nome';

  @override
  String get recentPlayers => 'Giocatori recenti';

  @override
  String get teams => 'Squadre';

  @override
  String get teamA => 'Squadra A';

  @override
  String get teamB => 'Squadra B';

  @override
  String get autoBalance => 'Bilancia automaticamente';

  @override
  String get houseRules => 'Regole della casa';

  @override
  String get targetScore => 'Punteggio obiettivo';

  @override
  String get overshootRule => 'Superamento';

  @override
  String get policyReset => 'Azzeramento';

  @override
  String get policyHalf => 'Metà dell\'obiettivo';

  @override
  String get policyNone => 'Nessuna penalità';

  @override
  String get eliminationRule => 'Eliminazione';

  @override
  String get missLimit => 'Lanci mancati per l\'eliminazione';

  @override
  String get shuffleOrder => 'Mescola l\'ordine';

  @override
  String get startGame => 'Inizia la partita';

  @override
  String get needTwoPlayers => 'Aggiungi almeno 2 giocatori';

  @override
  String get needBothTeams => 'Ogni squadra ha bisogno di un giocatore';

  @override
  String get custom => 'Personalizzato';

  @override
  String get rulesSearchHint => 'Cerca nelle regole';

  @override
  String get rulesNoResults => 'Nessuna regola corrisponde';

  @override
  String get activeRulesLabel => 'Questa partita';

  @override
  String get catSetup => 'Preparazione & campo';

  @override
  String get catThrowing => 'Il lancio';

  @override
  String get catScoring => 'I punti';

  @override
  String get catOvershoot => 'Superamento & azzeramento';

  @override
  String get catMisses => 'Lanci mancati & eliminazione';

  @override
  String get catWinning => 'Vincere';

  @override
  String get catTeams => 'Squadre';

  @override
  String get ruleFormationTitle => 'La formazione';

  @override
  String get ruleFormationBody =>
      'I 12 birilli numerati partono in un rombo compatto, a 3–4 metri dalla linea di lancio.';

  @override
  String get rulePinsStandTitle => 'I birilli restano dove cadono';

  @override
  String get rulePinsStandBody =>
      'Dopo ogni lancio i birilli caduti vengono rialzati dove sono atterrati — il campo si allarga durante la partita.';

  @override
  String get ruleTurnsTitle => 'A turno';

  @override
  String get ruleTurnsBody =>
      'Ogni parte lancia un bastone per turno, sempre nello stesso ordine.';

  @override
  String get ruleUnderhandTitle => 'Lancio dal basso';

  @override
  String get ruleUnderhandBody => 'Il bastone si lancia sempre dal basso.';

  @override
  String get ruleOnePinTitle => 'Un birillo a terra';

  @override
  String get ruleOnePinBody =>
      'Abbatti esattamente un birillo e segni il suo numero.';

  @override
  String get ruleManyPinsTitle => 'Più birilli a terra';

  @override
  String get ruleManyPinsBody =>
      'Abbatti più birilli e segni il numero dei birilli, non la loro somma.';

  @override
  String get ruleManyPinsDetail =>
      'Esempio: abbattere i birilli 7, 9 e 12 vale 3 punti.';

  @override
  String get ruleLeaningTitle => 'I birilli appoggiati non contano';

  @override
  String get ruleLeaningBody =>
      'Un birillo appoggiato a un altro birillo o al bastone non conta come caduto.';

  @override
  String get ruleOvershootTitle => 'Non superare l\'obiettivo';

  @override
  String get ruleOvershootBody =>
      'Se il tuo punteggio superasse l\'obiettivo, ricadi indietro (classico: superare 50 ti riporta a 25).';

  @override
  String get ruleOvershootDetail =>
      'Le regole della casa possono cambiarlo: ritorno a metà dell\'obiettivo o nessuna penalità.';

  @override
  String get ruleMissesTitle => 'Tre errori e sei fuori';

  @override
  String get ruleMissesBody =>
      'Non segnare nulla per tre turni di fila ed è eliminazione (quando è attiva).';

  @override
  String get ruleMissesDetail =>
      'I puntini sulla tua carta giocatore seguono la tua serie di errori.';

  @override
  String get ruleExactTitle => 'Centra l\'obiettivo esatto';

  @override
  String get ruleExactBody =>
      'La prima parte che raggiunge esattamente il punteggio obiettivo vince la partita.';

  @override
  String get ruleLastStandingTitle => 'L\'ultimo rimasto';

  @override
  String get ruleLastStandingBody =>
      'Se tutte le altre parti sono eliminate, vince quella rimasta.';

  @override
  String get ruleTeamsTitle => 'Da soli o in squadra';

  @override
  String get ruleTeamsBody =>
      'Gioca uno contro uno o in due squadre — una squadra lancia come un\'unica parte e i membri si alternano.';

  @override
  String get rematch => 'Rivincita';

  @override
  String get skip => 'Salta';

  @override
  String get next => 'Avanti';

  @override
  String get tourTryIt => 'Provaci — tocca i birilli caduti';

  @override
  String get historyTitle => 'Cronologia';

  @override
  String get noGamesYet => 'Ancora nessuna partita — il campo aspetta!';

  @override
  String get gamesPlayed => 'Partite';

  @override
  String get wins => 'Vittorie';

  @override
  String get winRate => 'Percentuale di vittorie';

  @override
  String get avgPerThrow => 'Punti medi per lancio';

  @override
  String get mostHitPin => 'Birillo preferito';

  @override
  String get statMisses => 'Lanci mancati';

  @override
  String get statOvershoots => 'Superamenti';

  @override
  String get statEliminations => 'Eliminazioni';

  @override
  String get numberPad => 'Tastierino';

  @override
  String get tapPins => 'Tocca i birilli';

  @override
  String get scoreboardMode => 'Tabellone';

  @override
  String get share => 'Condividi';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get haptics => 'Vibrazione';

  @override
  String get keepAwake => 'Mantieni lo schermo acceso';

  @override
  String get homeLabel => 'Home';

  @override
  String pinSemantics(int number) {
    return 'Birillo $number';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get newGameConfirmTitle => 'Iniziare una nuova partita?';

  @override
  String get newGameConfirmBody => 'La partita in corso verrà scartata.';

  @override
  String get resumeGame => 'Riprendi la partita';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get delete => 'Elimina';

  @override
  String get clearHistory => 'Cancella cronologia';

  @override
  String get clearHistoryConfirmBody =>
      'Tutte le partite e le statistiche saranno eliminate.';
}
