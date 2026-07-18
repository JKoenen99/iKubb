// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Le tableau de score du kubb à numéros';

  @override
  String get startScoring => 'Je connais les règles — commencer à compter';

  @override
  String get teachMe => 'Apprends-moi le jeu';

  @override
  String get quickStart => 'Démarrage rapide';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get rules => 'Règles';

  @override
  String get stats => 'Statistiques';

  @override
  String get confirmThrow => 'Valider le lancer';

  @override
  String get miss => 'Raté';

  @override
  String get undo => 'Annuler';

  @override
  String needsExactly(int points) {
    return 'Il faut exactement $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Dépassement — retour à $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name gagne !';
  }

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get players => 'Joueurs';

  @override
  String get addPlayer => 'Ajouter un joueur';

  @override
  String get playerName => 'Nom';

  @override
  String get recentPlayers => 'Joueurs récents';

  @override
  String get teams => 'Équipes';

  @override
  String get teamA => 'Équipe A';

  @override
  String get teamB => 'Équipe B';

  @override
  String get autoBalance => 'Répartir automatiquement';

  @override
  String get houseRules => 'Règles maison';

  @override
  String get targetScore => 'Score cible';

  @override
  String get overshootRule => 'Dépassement';

  @override
  String get policyReset => 'Réinitialiser';

  @override
  String get policyHalf => 'Moitié de la cible';

  @override
  String get policyNone => 'Sans pénalité';

  @override
  String get eliminationRule => 'Élimination';

  @override
  String get missLimit => 'Ratés avant élimination';

  @override
  String get shuffleOrder => 'Mélanger l\'ordre';

  @override
  String get startGame => 'Commencer la partie';

  @override
  String get needTwoPlayers => 'Ajoutez au moins 2 joueurs';

  @override
  String get needBothTeams => 'Chaque équipe doit avoir un joueur';

  @override
  String get custom => 'Personnalisé';
}
