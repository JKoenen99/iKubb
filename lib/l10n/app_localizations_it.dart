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
  String get tagline => 'Il segnapunti del kubb';

  @override
  String get startScoring => 'Conosco le regole, iniziamo';

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
  String policyReset(int score) {
    return 'Torna a $score';
  }

  @override
  String get policyHalf => 'Metà dell\'obiettivo';

  @override
  String get policyNone => 'Nessuna penalità';

  @override
  String get eliminationRule => 'Eliminazione';

  @override
  String get missLimit => 'Errori prima dell\'eliminazione';

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
  String get activeRulesLabel => 'Regole della casa in vigore';

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
      'I giocatori si alternano in un ordine fisso — un bastone per lancio.';

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
      'Un birillo appoggiato a un altro birillo o al bastone non conta come abbattuto.';

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
      'I punti sulla scheda del punteggio contano gli errori consecutivi.';

  @override
  String get ruleExactTitle => 'Centra l\'obiettivo esatto';

  @override
  String get ruleExactBody =>
      'Il primo giocatore o squadra a raggiungere esattamente il punteggio obiettivo vince la partita.';

  @override
  String get ruleLastStandingTitle => 'L\'ultimo rimasto';

  @override
  String get ruleLastStandingBody =>
      'Se tutti gli altri sono eliminati, vince l\'ultimo giocatore o l\'ultima squadra rimasta.';

  @override
  String get ruleTeamsTitle => 'Da soli o in squadra';

  @override
  String get ruleTeamsBody =>
      'Gioca uno contro uno o in due squadre — la squadra condivide un turno e i membri si alternano al lancio.';

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
  String get avgPerThrow => 'Punti per lancio';

  @override
  String get mostHitPin => 'Birillo più colpito';

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
  String get systemDefault => 'Sistema';

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
  String get newGameConfirmBody => 'Perderai la partita in corso.';

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
      'Questo cancella tutte le partite e le statistiche.';

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
      'Lancia i kubb abbattuti nella metà degli attaccanti.';

  @override
  String get outTwice => 'Kubb di penalità (fuori due volte)';

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
      'Il kubb è un gioco di squadra: da uno a sei giocatori per squadra. I compagni si dividono i sei bastoni e lanciano a turno.';

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
  String get ruleKubbEarlyKingTitle => 'Non prima che la linea sia a terra';

  @override
  String get ruleKubbEarlyKingBody =>
      'Abbatti il re prima che tutto il resto sia a terra — anche per sbaglio — e la tua squadra perde la partita all\'istante.';

  @override
  String get ruleKubbMatchTitle => 'Al meglio delle tre';

  @override
  String get ruleKubbMatchBody =>
      'Nei tornei un incontro si gioca al meglio delle tre partite. Le squadre si alternano a decidere quale squadra apre ogni partita.';

  @override
  String get ruleKubbMatchDetail =>
      'Con il timer del turno attivo, la squadra ha un tempo fisso per i suoi sei bastoni. Il timer è indicativo — l\'app non blocca mai un lancio.';

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
  String kubbStandingSemantics(int number) {
    return 'Kubb $number, in piedi';
  }

  @override
  String kubbSelectedSemantics(int number) {
    return 'Kubb $number, segnato come abbattuto';
  }

  @override
  String get kingSafeSemantics => 'Il re — abbattilo per vincere';

  @override
  String get kingRiskySemantics => 'Il re — colpirlo ora fa perdere la partita';

  @override
  String batonsLeftSemantics(int remaining, int total) {
    return '$remaining bastoni su $total rimasti';
  }

  @override
  String missesSemantics(int count, int limit) {
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
  String confirmThrowCount(int count) {
    return 'Conferma lancio (+$count)';
  }

  @override
  String resumeGameSummary(String summary) {
    return 'Riprendi la partita · $summary';
  }

  @override
  String matchScore(int a, int b) {
    return '$a – $b';
  }

  @override
  String get deleteGameConfirmBody =>
      'Questa partita sarà rimossa dalla cronologia.';

  @override
  String get newMatch => 'Nuovo incontro';

  @override
  String playerN(int n) {
    return 'Giocatore $n';
  }

  @override
  String secondsShort(int seconds) {
    return '$seconds s';
  }

  @override
  String removePlayer(String name) {
    return 'Rimuovi $name';
  }

  @override
  String get showDetails => 'Più dettagli';

  @override
  String get toppleKing => 'Abbatti il re';

  @override
  String turnClockSemantics(int seconds) {
    return '$seconds secondi rimasti sul timer del turno';
  }

  @override
  String baselineStandingSemantics(int count) {
    return '$count kubb di linea di fondo in piedi';
  }

  @override
  String get opensRuleHint => 'Apre la regola';

  @override
  String get clearSearch => 'Cancella ricerca';

  @override
  String scoredAnnouncement(String name, int points, int total) {
    return '$name segna $points, ora a $total';
  }

  @override
  String missAnnouncement(String name) {
    return '$name manca il tiro';
  }

  @override
  String overshootAnnouncement(String name, int total) {
    return '$name supera e scende a $total';
  }

  @override
  String eliminatedAnnouncement(String name) {
    return '$name è eliminato';
  }

  @override
  String get feedbackPromptGameTitle => 'Com’è andato segnare con iKubb?';

  @override
  String get feedbackPromptTourTitle => 'Il tour ti ha spiegato il gioco?';

  @override
  String get feedbackSheetTitle => 'Il tuo feedback';

  @override
  String get feedbackNotNow => 'Non ora';

  @override
  String feedbackStarsSemantics(int count) {
    return '$count stelle su 5';
  }

  @override
  String get feedbackWhatLiked => 'Cosa ha funzionato bene?';

  @override
  String get feedbackWhatImprove => 'Cosa potrebbe migliorare?';

  @override
  String get feedbackCommentHint => 'Altro? (facoltativo)';

  @override
  String get feedbackSubmit => 'Invia feedback';

  @override
  String get feedbackThanks => 'Grazie, ci aiuta a migliorare!';

  @override
  String get feedbackSection => 'Feedback';

  @override
  String get feedbackGive => 'Lascia un feedback';

  @override
  String get feedbackGiveSubtitle => 'Di’ allo sviluppatore cosa migliorare';

  @override
  String get feedbackPrivacyNote =>
      'Anonimo: salviamo solo valutazione, tag, commento e versione dell’app.';

  @override
  String get tagEasyScoring => 'Segnare è facile';

  @override
  String get tagRulesHelpful => 'Le regole hanno aiutato';

  @override
  String get tagLooksGreat => 'È bella';

  @override
  String get tagFast => 'Veloce';

  @override
  String get tagStatsFun => 'Le statistiche sono divertenti';

  @override
  String get tagShareCard => 'Card da condividere';

  @override
  String get tagConfusing => 'Confusa';

  @override
  String get tagMissingFeature => 'Manca una funzione';

  @override
  String get tagBug => 'Qualcosa si è rotto';

  @override
  String get tagTooManyTaps => 'Troppi tocchi';

  @override
  String get tagRulesUnclear => 'Regole poco chiare';

  @override
  String get tagTranslation => 'Problema di traduzione';

  @override
  String get tagOther => 'Altro';

  @override
  String get gameSection => 'Gioco';

  @override
  String get modeNumberDesc =>
      'Punti per birillo. Vince chi arriva per primo al traguardo.';

  @override
  String get modeKubbDesc => 'Regole classiche. Libera il campo, poi il re.';

  @override
  String modeNumberHint(int target) {
    return 'Punti per birillo. Vince chi arriva per primo a $target.';
  }

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giocatori',
      one: '1 giocatore',
    );
    return '$_temp0';
  }

  @override
  String get namesOptionalHint =>
      'I nomi sono facoltativi. Tocca un nome per cambiarlo.';

  @override
  String get recentLabel => 'Recenti';

  @override
  String get teamsOffDesc => 'Ognuno gioca per sé.';

  @override
  String get teamsOnDesc =>
      'Il punteggio conta per squadra. Tocca un’etichetta per spostare un giocatore.';

  @override
  String get swapTeams => 'Scambia squadre';

  @override
  String moveToTeam(String name, String team) {
    return 'Sposta $name in $team';
  }

  @override
  String get resetLabel => 'Ripristina';

  @override
  String get targetScoreDesc => 'Raggiungilo esattamente per vincere';

  @override
  String get backToLabel => 'Torna a';

  @override
  String get backToDesc => 'Punteggio se superi';

  @override
  String get eliminationDesc => 'Errori di fila prima di essere eliminato';

  @override
  String summaryFirstTo(int target) {
    return 'primo a $target';
  }

  @override
  String summaryBackTo(int reset) {
    return 'torna a $reset';
  }

  @override
  String summaryOutAfter(int misses) {
    return 'fuori dopo $misses errori';
  }

  @override
  String get summaryNoPenalty => 'nessuna penalità';

  @override
  String get summaryNoElimination => 'nessuna eliminazione';

  @override
  String get summaryInTeams => 'a squadre';

  @override
  String get editValueTitle => 'Inserisci un valore';

  @override
  String renamePlayer(String name) {
    return 'Rinomina $name';
  }
}
