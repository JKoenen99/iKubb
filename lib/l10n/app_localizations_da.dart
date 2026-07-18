// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Resultattavlen til nummerkubb';

  @override
  String get startScoring => 'Jeg kender reglerne — begynd at score';

  @override
  String get teachMe => 'Lær mig spillet';

  @override
  String get quickStart => 'Hurtig start';

  @override
  String get newGame => 'Nyt spil';

  @override
  String get rules => 'Regler';

  @override
  String get stats => 'Statistik';

  @override
  String get confirmThrow => 'Bekræft kast';

  @override
  String get miss => 'Forbier';

  @override
  String get undo => 'Fortryd';

  @override
  String needsExactly(int points) {
    return 'Skal bruge præcis $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Over målet — tilbage til $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name vinder!';
  }

  @override
  String get comingSoon => 'Kommer snart';
}
