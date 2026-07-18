// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Numerokubbin tulostaulu';

  @override
  String get startScoring => 'Osaan säännöt — aloita pisteytys';

  @override
  String get teachMe => 'Opeta minulle peli';

  @override
  String get quickStart => 'Pikastartti';

  @override
  String get newGame => 'Uusi peli';

  @override
  String get rules => 'Säännöt';

  @override
  String get stats => 'Tilastot';

  @override
  String get confirmThrow => 'Vahvista heitto';

  @override
  String get miss => 'Ohi';

  @override
  String get undo => 'Kumoa';

  @override
  String needsExactly(int points) {
    return 'Tarvitsee tasan $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Yli meni — takaisin pisteisiin $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name voittaa!';
  }

  @override
  String get comingSoon => 'Tulossa pian';
}
