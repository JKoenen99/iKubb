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

  @override
  String get rulesSearchHint => 'Search the rules';

  @override
  String get rulesNoResults => 'No rules match your search';

  @override
  String get activeRulesLabel => 'This game';

  @override
  String get catSetup => 'Setup & field';

  @override
  String get catThrowing => 'Throwing';

  @override
  String get catScoring => 'Scoring';

  @override
  String get catOvershoot => 'Overshoot & reset';

  @override
  String get catMisses => 'Misses & elimination';

  @override
  String get catWinning => 'Winning';

  @override
  String get catTeams => 'Teams';

  @override
  String get ruleFormationTitle => 'The formation';

  @override
  String get ruleFormationBody =>
      'The 12 numbered pins start in a tight diamond formation, 3 to 4 metres from the throwing line.';

  @override
  String get rulePinsStandTitle => 'Pins stand where they fall';

  @override
  String get rulePinsStandBody =>
      'After each throw, knocked pins are stood upright on the spot where they landed — the field spreads out as the game goes on.';

  @override
  String get ruleTurnsTitle => 'Take turns';

  @override
  String get ruleTurnsBody =>
      'Sides throw one stick per turn, always in the same order.';

  @override
  String get ruleUnderhandTitle => 'Throw underhand';

  @override
  String get ruleUnderhandBody => 'The stick is always thrown underhand.';

  @override
  String get ruleOnePinTitle => 'One pin down';

  @override
  String get ruleOnePinBody =>
      'Knock over exactly one pin and you score that pin\'s number.';

  @override
  String get ruleManyPinsTitle => 'Several pins down';

  @override
  String get ruleManyPinsBody =>
      'Knock over several pins and you score the number of pins, not their sum.';

  @override
  String get ruleManyPinsDetail =>
      'Example: knocking over pins 7, 9 and 12 scores 3 points.';

  @override
  String get ruleLeaningTitle => 'Leaning pins don\'t count';

  @override
  String get ruleLeaningBody =>
      'A pin resting on another pin or on the stick doesn\'t count as fallen.';

  @override
  String get ruleOvershootTitle => 'Don\'t overshoot';

  @override
  String get ruleOvershootBody =>
      'If your score would pass the target, it drops back down instead (classic: overshooting 50 puts you on 25).';

  @override
  String get ruleOvershootDetail =>
      'House rules can change this: reset to half of the target, or no penalty at all.';

  @override
  String get ruleMissesTitle => 'Three misses and you\'re out';

  @override
  String get ruleMissesBody =>
      'Score nothing three turns in a row and you\'re eliminated (when elimination is enabled).';

  @override
  String get ruleMissesDetail =>
      'The dots on your player card track your miss streak.';

  @override
  String get ruleExactTitle => 'Hit the target exactly';

  @override
  String get ruleExactBody =>
      'The first side to reach exactly the target score wins the game.';

  @override
  String get ruleLastStandingTitle => 'Last one standing';

  @override
  String get ruleLastStandingBody =>
      'If every other side is eliminated, the remaining side wins.';

  @override
  String get ruleTeamsTitle => 'Solo or in teams';

  @override
  String get ruleTeamsBody =>
      'Play one against one, or in two teams — a team throws as one side, with members taking turns.';

  @override
  String get rematch => 'Rematch';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get tourTryIt => 'Try it — tap the pins that fell';

  @override
  String get historyTitle => 'History';

  @override
  String get noGamesYet => 'No games yet — the field awaits!';

  @override
  String get gamesPlayed => 'Games';

  @override
  String get wins => 'Wins';

  @override
  String get winRate => 'Win rate';

  @override
  String get avgPerThrow => 'Avg points per throw';

  @override
  String get mostHitPin => 'Favorite pin';

  @override
  String get statMisses => 'Misses';

  @override
  String get statOvershoots => 'Overshoots';

  @override
  String get statEliminations => 'Eliminations';

  @override
  String get numberPad => 'Number pad';

  @override
  String get tapPins => 'Tap the pins';

  @override
  String get scoreboardMode => 'Scoreboard';

  @override
  String get share => 'Share';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get haptics => 'Haptics';

  @override
  String get keepAwake => 'Keep screen awake';

  @override
  String get homeLabel => 'Home';

  @override
  String pinSemantics(int number) {
    return 'Pin $number';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get newGameConfirmTitle => 'Start a new game?';

  @override
  String get newGameConfirmBody => 'The current game will be discarded.';
}
