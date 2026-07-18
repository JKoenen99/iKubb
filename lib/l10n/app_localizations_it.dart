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
}
