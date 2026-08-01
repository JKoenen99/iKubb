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

  @override
  String get modeNumber => 'Kubb numerato';

  @override
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Match';

  @override
  String get bestOfSingle => 'Partita secca';

  @override
  String get bestOfThree => 'Al meglio di 3';

  @override
  String get turnClockLabel => 'Timer del turno';

  @override
  String get offLabel => 'Spento';

  @override
  String get kingLabel => 'Il re';

  @override
  String get kingWarningTitle => 'Abbattere il re?';

  @override
  String get kingWarningBody =>
      'Non è ancora caduto tutto — colpire il re ora fa perdere la partita.';

  @override
  String get advantageLine => 'Linea di vantaggio';

  @override
  String get throwInTitle =>
      'Lancia i kubb abbattuti nella metà dell’attaccante';

  @override
  String get outTwice => 'Fuori due volte';

  @override
  String get done => 'Fatto';

  @override
  String get nextGameLabel => 'Prossima partita';

  @override
  String earlyKingBanner(String name) {
    return '$name ha abbattuto il re troppo presto!';
  }

  @override
  String get catKubbSetup => 'Preparazione e squadre';

  @override
  String get catKubbBatons => 'Bastoni da lancio';

  @override
  String get catKubbFieldKubbs => 'Kubb di campo';

  @override
  String get catKubbKing => 'Il re';

  @override
  String get ruleKubbFieldTitle => 'Il campo';

  @override
  String get ruleKubbFieldBody =>
      'Due squadre si fronteggiano sul campo. Ognuna schiera cinque kubb sulla propria linea di fondo; il re sta da solo al centro.';

  @override
  String get ruleKubbFieldDetail =>
      'I campi da torneo misurano 5 × 8 metri. Al parco bastano due giacche e un buon occhio — l\'importante è che le metà siano circa uguali.';

  @override
  String get ruleKubbTeamsTitle => 'Da uno a sei per squadra';

  @override
  String get ruleKubbTeamsBody =>
      'Il kubb è un gioco di squadra: da uno a sei giocatori per lato. I compagni si dividono i sei bastoni e lanciano a turno.';

  @override
  String get ruleKubbBatonsTitle => 'Sei bastoni a turno';

  @override
  String get ruleKubbBatonsBody =>
      'La squadra attaccante lancia sei bastoni contro i kubb avversari — dal basso, con rotazione verticale.';

  @override
  String get ruleKubbBatonsDetail =>
      'Niente lanci a elicottero: il bastone deve ruotare in verticale, mai di lato. I kubb abbattuti restano a terra fino a fine turno.';

  @override
  String get ruleKubbThrowInTitle => 'I kubb abbattuti tornano';

  @override
  String get ruleKubbThrowInBody =>
      'Dopo i bastoni, i difensori lanciano ogni kubb abbattuto nella metà degli attaccanti. Dove atterra, il kubb viene rialzato come kubb di campo.';

  @override
  String get ruleKubbThrowInDetail =>
      'I difensori scelgono dove mirare — i kubb vicini tra loro sono molto più facili da abbattere con un solo bastone.';

  @override
  String get ruleKubbFieldFirstTitle => 'Prima i kubb di campo';

  @override
  String get ruleKubbFieldFirstBody =>
      'Gli attaccanti devono abbattere tutti i kubb di campo in piedi prima di poter colpire un kubb di fondo. Un kubb di fondo abbattuto troppo presto viene rialzato.';

  @override
  String get ruleKubbPenaltyTitle => 'Fuori due volte = penalità';

  @override
  String get ruleKubbPenaltyBody =>
      'Un kubb lanciato fuori campo due volte diventa un kubb di penalità: l\'altra squadra lo piazza dove vuole nella propria metà — anche proprio accanto al re.';

  @override
  String get ruleKubbAdvantageTitle => 'La linea di vantaggio';

  @override
  String get ruleKubbAdvantageBody =>
      'Se gli avversari lasciano kubb di campo in piedi nella vostra metà, la vostra squadra può lanciare i bastoni dall\'altezza del kubb più vicino al re.';

  @override
  String get ruleKubbKingTitle => 'Il re decide';

  @override
  String get ruleKubbKingBody =>
      'Solo quando ogni kubb nella metà difensiva è a terra puoi mirare al re. Abbattilo, e la partita è vostra.';

  @override
  String get ruleKubbEarlyKingTitle => 'Mai troppo presto';

  @override
  String get ruleKubbEarlyKingBody =>
      'Abbatti il re prima che tutto il resto sia a terra — anche per sbaglio — e la tua squadra perde la partita all\'istante.';

  @override
  String get ruleKubbMatchTitle => 'Al meglio delle tre';

  @override
  String get ruleKubbMatchBody =>
      'Nei tornei un incontro si gioca al meglio delle tre partite. Le squadre si alternano ad aprire ogni partita.';

  @override
  String get ruleKubbMatchDetail =>
      'Con l\'orologio di turno attivo, la squadra ha un tempo fisso per i suoi sei bastoni. L\'orologio è indicativo — l\'app non blocca mai un lancio.';

  @override
  String get tourModePickTitle => 'A quale gioco giocate?';

  @override
  String get tourModePickBody =>
      'Sono entrambi in questa app. Scegline uno da imparare — puoi cambiare quando vuoi.';

  @override
  String get tourModeNumberDesc =>
      'Dodici birilli numerati. Corsa a 50 esatti.';

  @override
  String get tourModeKubbDesc => 'Due squadre, cinque kubb ciascuna — e il re.';

  @override
  String get statKingsFelled => 'Re abbattuti';

  @override
  String get statKubbsPerBaton => 'Kubb per bastone';

  @override
  String get statAdvantageTurns => 'Turni in vantaggio';

  @override
  String get statEarlyKings => 'Re anticipati';

  @override
  String get filterAll => 'Tutti';

  @override
  String get closeLabel => 'Chiudi';

  @override
  String get increaseLabel => 'Aumenta';

  @override
  String get decreaseLabel => 'Riduci';

  @override
  String kubbStandingSemantics(Object number) {
    return 'Kubb $number, in piedi';
  }

  @override
  String kubbSelectedSemantics(Object number) {
    return 'Kubb $number, segnato come abbattuto';
  }

  @override
  String kubbFelledSemantics(Object number) {
    return 'Kubb $number, a terra';
  }

  @override
  String get kingSafeSemantics => 'Il re — abbattilo per vincere';

  @override
  String get kingRiskySemantics => 'Il re — colpirlo ora fa perdere la partita';

  @override
  String batonsLeftSemantics(Object remaining, Object total) {
    return '$remaining bastoni su $total rimasti';
  }

  @override
  String missesSemantics(Object count, Object limit) {
    return '$count errori su $limit';
  }

  @override
  String get statsErrorBody => 'Impossibile caricare le tue statistiche.';

  @override
  String get retryLabel => 'Riprova';

  @override
  String get deleteGameLabel => 'Elimina partita';

  @override
  String get newMatchConfirmTitle => 'Iniziare un nuovo incontro?';

  @override
  String get newMatchConfirmBody => 'Perderai l\'incontro in corso.';

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsDuringPlay => 'Durante il gioco';

  @override
  String get settingsLearn => 'Impara';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get designSystemLabel => 'Design system';

  @override
  String get licensesLabel => 'Licenze open source';

  @override
  String confirmThrowCount(Object count) {
    return 'Conferma lancio (+$count)';
  }

  @override
  String resumeGameSummary(Object summary) {
    return 'Riprendi la partita · $summary';
  }

  @override
  String matchScore(Object a, Object b) {
    return '$a – $b';
  }
}
