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
  String get tagline => 'Le tableau des scores du kubb';

  @override
  String get startScoring => 'Je connais les règles, on compte';

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
  String policyReset(Object score) {
    return 'Retour à $score';
  }

  @override
  String get policyHalf => 'Moitié de la cible';

  @override
  String get policyNone => 'Sans pénalité';

  @override
  String get eliminationRule => 'Élimination';

  @override
  String get missLimit => 'Échecs avant élimination';

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
  String get activeRulesLabel => 'Règles maison en vigueur';

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
      'Les joueurs lancent à tour de rôle, dans un ordre fixe — un bâton par lancer.';

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
      'Une quille appuyée sur une autre quille ou sur le bâton ne compte pas comme renversée.';

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
      'Les points sur la carte de score suivent la série d\'échecs.';

  @override
  String get ruleExactTitle => 'Atteignez la cible exactement';

  @override
  String get ruleExactBody =>
      'Le premier joueur ou la première équipe à atteindre exactement le score cible gagne la partie.';

  @override
  String get ruleLastStandingTitle => 'Le dernier en lice';

  @override
  String get ruleLastStandingBody =>
      'Si tous les autres sont éliminés, le dernier joueur ou la dernière équipe en lice gagne.';

  @override
  String get ruleTeamsTitle => 'En solo ou en équipe';

  @override
  String get ruleTeamsBody =>
      'Jouez en un contre un ou en deux équipes — l\'équipe partage un tour et ses membres alternent les lancers.';

  @override
  String get rematch => 'Revanche';

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get tourTryIt => 'Essayez — touchez les quilles tombées';

  @override
  String get historyTitle => 'Historique';

  @override
  String get noGamesYet => 'Pas encore de parties — le terrain vous attend !';

  @override
  String get gamesPlayed => 'Parties';

  @override
  String get wins => 'Victoires';

  @override
  String get winRate => 'Taux de victoire';

  @override
  String get avgPerThrow => 'Points par lancer';

  @override
  String get mostHitPin => 'Quille la plus touchée';

  @override
  String get statMisses => 'Ratés';

  @override
  String get statOvershoots => 'Dépassements';

  @override
  String get statEliminations => 'Éliminations';

  @override
  String get numberPad => 'Pavé numérique';

  @override
  String get tapPins => 'Toucher les quilles';

  @override
  String get scoreboardMode => 'Tableau des scores';

  @override
  String get share => 'Partager';

  @override
  String get settings => 'Réglages';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Système';

  @override
  String get haptics => 'Vibrations';

  @override
  String get keepAwake => 'Garder l’écran allumé';

  @override
  String get homeLabel => 'Accueil';

  @override
  String pinSemantics(int number) {
    return 'Quille $number';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get newGameConfirmTitle => 'Commencer une nouvelle partie ?';

  @override
  String get newGameConfirmBody => 'Vous perdrez la partie en cours.';

  @override
  String get resumeGame => 'Reprendre la partie';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get delete => 'Supprimer';

  @override
  String get clearHistory => 'Effacer l’historique';

  @override
  String get clearHistoryConfirmBody =>
      'Cela efface toutes les parties et toutes les statistiques.';

  @override
  String get modeNumber => 'Kubb à numéros';

  @override
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Match';

  @override
  String get bestOfSingle => 'Une manche';

  @override
  String get bestOfThree => 'Au meilleur des 3';

  @override
  String get turnClockLabel => 'Horloge de tour';

  @override
  String get offLabel => 'Désactivée';

  @override
  String get kingLabel => 'Le roi';

  @override
  String get kingWarningTitle => 'Renverser le roi ?';

  @override
  String get kingWarningBody =>
      'Tout n\'est pas encore tombé — toucher le roi maintenant fait perdre la manche.';

  @override
  String get advantageLine => 'Ligne d\'avantage';

  @override
  String get throwInTitle =>
      'Lancez les kubbs renversés dans la moitié des attaquants.';

  @override
  String get outTwice => 'Kubbs de pénalité (deux fois dehors)';

  @override
  String get done => 'Terminé';

  @override
  String get nextGameLabel => 'Manche suivante';

  @override
  String earlyKingBanner(String name) {
    return '$name a renversé le roi trop tôt !';
  }

  @override
  String get catKubbSetup => 'Mise en place & équipes';

  @override
  String get catKubbBatons => 'Bâtons de lancer';

  @override
  String get catKubbFieldKubbs => 'Kubbs de terrain';

  @override
  String get catKubbKing => 'Le roi';

  @override
  String get ruleKubbFieldTitle => 'Le terrain';

  @override
  String get ruleKubbFieldBody =>
      'Deux équipes se font face sur le terrain. Chacune aligne cinq kubbs sur sa ligne de fond ; le roi trône seul au centre.';

  @override
  String get ruleKubbFieldDetail =>
      'Les terrains de tournoi mesurent 5 × 8 mètres. Au parc, deux vestes et un bon œil suffisent — gardez simplement des moitiés à peu près égales.';

  @override
  String get ruleKubbTeamsTitle => 'De un à six par équipe';

  @override
  String get ruleKubbTeamsBody =>
      'Le kubb est un jeu d\'équipe : de un à six joueurs par camp. Les coéquipiers se partagent les six bâtons et lancent à tour de rôle.';

  @override
  String get ruleKubbBatonsTitle => 'Six bâtons par tour';

  @override
  String get ruleKubbBatonsBody =>
      'L\'équipe attaquante lance six bâtons sur les kubbs adverses — par en dessous, en rotation verticale.';

  @override
  String get ruleKubbBatonsDetail =>
      'Pas de lancer hélicoptère : le bâton doit tourner verticalement, jamais de côté. Les kubbs tombés restent au sol jusqu\'à la fin du tour.';

  @override
  String get ruleKubbThrowInTitle => 'Les kubbs tombés reviennent';

  @override
  String get ruleKubbThrowInBody =>
      'Après les bâtons, les défenseurs lancent chaque kubb tombé dans la moitié des attaquants. Là où il atterrit, le kubb est redressé en kubb de terrain.';

  @override
  String get ruleKubbThrowInDetail =>
      'Les défenseurs choisissent où viser — des kubbs regroupés sont bien plus faciles à abattre d\'un seul bâton.';

  @override
  String get ruleKubbFieldFirstTitle => 'Les kubbs de terrain d\'abord';

  @override
  String get ruleKubbFieldFirstBody =>
      'Les attaquants doivent abattre tous les kubbs de terrain debout avant de pouvoir toucher un kubb de fond. Un kubb de fond tombé trop tôt est redressé.';

  @override
  String get ruleKubbPenaltyTitle => 'Deux fois dehors = pénalité';

  @override
  String get ruleKubbPenaltyBody =>
      'Un kubb lancé deux fois hors du terrain devient un kubb de pénalité : l\'autre équipe le place où elle veut dans sa moitié — même juste à côté du roi.';

  @override
  String get ruleKubbAdvantageTitle => 'La ligne d\'avantage';

  @override
  String get ruleKubbAdvantageBody =>
      'Si vos adversaires laissent des kubbs de terrain debout dans votre moitié, votre équipe peut lancer depuis le kubb le plus proche du roi.';

  @override
  String get ruleKubbKingTitle => 'Le roi décide';

  @override
  String get ruleKubbKingBody =>
      'Ce n\'est que lorsque tous les kubbs de la moitié adverse sont tombés que vous pouvez viser le roi. Renversez-le, et la partie est à vous.';

  @override
  String get ruleKubbEarlyKingTitle => 'Pas avant que la ligne soit tombée';

  @override
  String get ruleKubbEarlyKingBody =>
      'Renversez le roi avant que tout le reste ne soit tombé — même par accident — et votre équipe perd la partie sur-le-champ.';

  @override
  String get ruleKubbMatchTitle => 'Au meilleur des trois';

  @override
  String get ruleKubbMatchBody =>
      'En tournoi, un match se joue au meilleur des trois manches. Les équipes alternent l\'entame de chaque manche.';

  @override
  String get ruleKubbMatchDetail =>
      'Avec l\'horloge de tour activée, l\'équipe dispose d\'un temps fixe pour ses six bâtons. C\'est un repère — l\'appli ne bloque jamais un lancer.';

  @override
  String get tourModePickTitle => 'À quel jeu jouez-vous ?';

  @override
  String get tourModePickBody =>
      'Les deux sont dans cette appli. Choisissez-en un à apprendre — vous pourrez changer à tout moment.';

  @override
  String get tourModeNumberDesc =>
      'Douze quilles numérotées. Premier à 50 pile.';

  @override
  String get tourModeKubbDesc =>
      'Deux équipes, cinq kubbs chacune — et le roi.';

  @override
  String get statKingsFelled => 'Rois renversés';

  @override
  String get statKubbsPerBaton => 'Kubbs par bâton';

  @override
  String get statAdvantageTurns => 'Tours avec avantage';

  @override
  String get statEarlyKings => 'Rois prématurés';

  @override
  String get filterAll => 'Tout';

  @override
  String get closeLabel => 'Fermer';

  @override
  String get increaseLabel => 'Augmenter';

  @override
  String get decreaseLabel => 'Diminuer';

  @override
  String kubbStandingSemantics(Object number) {
    return 'Kubb $number, debout';
  }

  @override
  String kubbSelectedSemantics(Object number) {
    return 'Kubb $number, marqué comme renversé';
  }

  @override
  String kubbFelledSemantics(Object number) {
    return 'Kubb $number, à terre';
  }

  @override
  String get kingSafeSemantics => 'Le roi — renversez-le pour gagner';

  @override
  String get kingRiskySemantics =>
      'Le roi — le toucher maintenant fait perdre la partie';

  @override
  String batonsLeftSemantics(Object remaining, Object total) {
    return '$remaining bâtons sur $total restants';
  }

  @override
  String missesSemantics(Object count, Object limit) {
    return '$count échecs sur $limit';
  }

  @override
  String get statsErrorBody => 'Impossible de charger vos statistiques.';

  @override
  String get retryLabel => 'Réessayer';

  @override
  String get deleteGameLabel => 'Supprimer la partie';

  @override
  String get newMatchConfirmTitle => 'Commencer un nouveau match ?';

  @override
  String get newMatchConfirmBody => 'Vous perdrez le match en cours.';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsDuringPlay => 'Pendant le jeu';

  @override
  String get settingsLearn => 'Apprendre';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get designSystemLabel => 'Design system';

  @override
  String get licensesLabel => 'Licences open source';

  @override
  String confirmThrowCount(Object count) {
    return 'Confirmer le lancer (+$count)';
  }

  @override
  String resumeGameSummary(Object summary) {
    return 'Reprendre la partie · $summary';
  }

  @override
  String matchScore(Object a, Object b) {
    return '$a – $b';
  }

  @override
  String get deleteGameConfirmBody =>
      'Cette partie sera retirée de votre historique.';
}
