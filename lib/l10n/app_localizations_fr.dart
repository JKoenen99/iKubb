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

  @override
  String get rulesSearchHint => 'Rechercher dans les règles';

  @override
  String get rulesNoResults => 'Aucune règle ne correspond';

  @override
  String get activeRulesLabel => 'Cette partie';

  @override
  String get catSetup => 'Mise en place & terrain';

  @override
  String get catThrowing => 'Le lancer';

  @override
  String get catScoring => 'Les points';

  @override
  String get catOvershoot => 'Dépassement & retour';

  @override
  String get catMisses => 'Ratés & élimination';

  @override
  String get catWinning => 'Gagner';

  @override
  String get catTeams => 'Équipes';

  @override
  String get ruleFormationTitle => 'La formation';

  @override
  String get ruleFormationBody =>
      'Les 12 quilles numérotées démarrent en losange serré, à 3 ou 4 mètres de la ligne de lancer.';

  @override
  String get rulePinsStandTitle => 'Les quilles restent où elles tombent';

  @override
  String get rulePinsStandBody =>
      'Après chaque lancer, les quilles tombées sont redressées là où elles ont atterri — le terrain s\'étale au fil de la partie.';

  @override
  String get ruleTurnsTitle => 'Chacun son tour';

  @override
  String get ruleTurnsBody =>
      'Chaque camp lance un bâton par tour, toujours dans le même ordre.';

  @override
  String get ruleUnderhandTitle => 'Lancer par en dessous';

  @override
  String get ruleUnderhandBody => 'Le bâton se lance toujours par en dessous.';

  @override
  String get ruleOnePinTitle => 'Une quille tombée';

  @override
  String get ruleOnePinBody =>
      'Renversez exactement une quille et vous marquez son numéro.';

  @override
  String get ruleManyPinsTitle => 'Plusieurs quilles tombées';

  @override
  String get ruleManyPinsBody =>
      'Renversez plusieurs quilles et vous marquez le nombre de quilles, pas leur somme.';

  @override
  String get ruleManyPinsDetail =>
      'Exemple : renverser les quilles 7, 9 et 12 rapporte 3 points.';

  @override
  String get ruleLeaningTitle => 'Les quilles penchées ne comptent pas';

  @override
  String get ruleLeaningBody =>
      'Une quille appuyée sur une autre quille ou sur le bâton n\'est pas considérée comme tombée.';

  @override
  String get ruleOvershootTitle => 'Ne dépassez pas la cible';

  @override
  String get ruleOvershootBody =>
      'Si votre score dépasse la cible, vous retombez (classique : dépasser 50 vous ramène à 25).';

  @override
  String get ruleOvershootDetail =>
      'Les règles maison peuvent changer cela : retour à la moitié de la cible, ou aucune pénalité.';

  @override
  String get ruleMissesTitle => 'Trois ratés et c\'est fini';

  @override
  String get ruleMissesBody =>
      'Ne marquez rien trois tours de suite et vous êtes éliminé (quand l\'élimination est activée).';

  @override
  String get ruleMissesDetail =>
      'Les points sur votre carte de joueur suivent votre série de ratés.';

  @override
  String get ruleExactTitle => 'Atteignez la cible exactement';

  @override
  String get ruleExactBody =>
      'Le premier camp à atteindre exactement le score cible gagne la partie.';

  @override
  String get ruleLastStandingTitle => 'Le dernier en lice';

  @override
  String get ruleLastStandingBody =>
      'Si tous les autres camps sont éliminés, le camp restant gagne.';

  @override
  String get ruleTeamsTitle => 'En solo ou en équipe';

  @override
  String get ruleTeamsBody =>
      'Jouez en un contre un ou en deux équipes — une équipe lance comme un seul camp, ses membres alternent.';
}
