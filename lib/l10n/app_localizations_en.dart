// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'The number kubb scoreboard';

  @override
  String get startScoring => 'I know the rules — start scoring';

  @override
  String get teachMe => 'Teach me the game';

  @override
  String get quickStart => 'Quick start';

  @override
  String get newGame => 'New game';

  @override
  String get rules => 'Rules';

  @override
  String get stats => 'Stats';

  @override
  String get confirmThrow => 'Confirm throw';

  @override
  String get miss => 'Miss';

  @override
  String get undo => 'Undo';

  @override
  String needsExactly(int points) {
    return 'Needs exactly $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Overshoot — back to $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name wins!';
  }

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get players => 'Players';

  @override
  String get addPlayer => 'Add player';

  @override
  String get playerName => 'Name';

  @override
  String get recentPlayers => 'Recent players';

  @override
  String get teams => 'Teams';

  @override
  String get teamA => 'Team A';

  @override
  String get teamB => 'Team B';

  @override
  String get autoBalance => 'Auto-balance';

  @override
  String get houseRules => 'House rules';

  @override
  String get targetScore => 'Target score';

  @override
  String get overshootRule => 'Overshoot';

  @override
  String get policyReset => 'Reset';

  @override
  String get policyHalf => 'Half of target';

  @override
  String get policyNone => 'No penalty';

  @override
  String get eliminationRule => 'Elimination';

  @override
  String get missLimit => 'Misses to eliminate';

  @override
  String get shuffleOrder => 'Shuffle order';

  @override
  String get startGame => 'Start game';

  @override
  String get needTwoPlayers => 'Add at least 2 players';

  @override
  String get needBothTeams => 'Both teams need a player';

  @override
  String get custom => 'Custom';
}
