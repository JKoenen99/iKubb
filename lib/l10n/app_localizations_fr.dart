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
}
