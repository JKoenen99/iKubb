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

  @override
  String get resumeGame => 'Resume game';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get delete => 'Delete';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearHistoryConfirmBody => 'All games and stats will be deleted.';

  @override
  String get modeNumber => 'Number kubb';

  @override
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Match';

  @override
  String get bestOfSingle => 'Single game';

  @override
  String get bestOfThree => 'Best of 3';

  @override
  String get turnClockLabel => 'Turn clock';

  @override
  String get offLabel => 'Off';

  @override
  String get kingLabel => 'King';

  @override
  String get kingWarningTitle => 'Topple the king?';

  @override
  String get kingWarningBody =>
      'Not everything is down yet — hitting the king now loses the game.';

  @override
  String get advantageLine => 'Advantage line';

  @override
  String get throwInTitle => 'Throw the felled kubbs into the attacker\'s half';

  @override
  String get outTwice => 'Out of bounds twice';

  @override
  String get done => 'Done';

  @override
  String get nextGameLabel => 'Next game';

  @override
  String earlyKingBanner(String name) {
    return '$name toppled the king too early!';
  }

  @override
  String get catKubbSetup => 'Setup & teams';

  @override
  String get catKubbBatons => 'Throwing batons';

  @override
  String get catKubbFieldKubbs => 'Field kubbs';

  @override
  String get catKubbKing => 'The king';

  @override
  String get ruleKubbFieldTitle => 'The field';

  @override
  String get ruleKubbFieldBody =>
      'Two teams face each other across the field. Each lines up five kubbs on its baseline, and the king stands alone in the middle.';

  @override
  String get ruleKubbFieldDetail =>
      'Tournament fields measure 5 × 8 metres. In the park, two jackets and a good guess work fine — just keep the halves roughly equal.';

  @override
  String get ruleKubbTeamsTitle => 'One to six a side';

  @override
  String get ruleKubbTeamsBody =>
      'Kubb is a team game: one to six players per side. Teammates share the six batons and take turns throwing.';

  @override
  String get ruleKubbBatonsTitle => 'Six batons per turn';

  @override
  String get ruleKubbBatonsBody =>
      'The attacking team throws six batons at the other team\'s kubbs — underhand, spinning end over end.';

  @override
  String get ruleKubbBatonsDetail =>
      'No helicopter throws: the baton must spin vertically, never sideways. Kubbs felled by the batons stay down until the turn ends.';

  @override
  String get ruleKubbThrowInTitle => 'Felled kubbs come back';

  @override
  String get ruleKubbThrowInBody =>
      'After the batons, the defenders throw every felled kubb into the attackers\' half. Where a kubb lands, it is stood up as a field kubb.';

  @override
  String get ruleKubbThrowInDetail =>
      'The defenders choose where to aim — kubbs standing close together are far easier to clear with one baton.';

  @override
  String get ruleKubbFieldFirstTitle => 'Field kubbs first';

  @override
  String get ruleKubbFieldFirstBody =>
      'Attackers must fell every standing field kubb before any baseline kubb may be hit. A baseline kubb felled too early is raised again.';

  @override
  String get ruleKubbPenaltyTitle => 'Out twice = penalty';

  @override
  String get ruleKubbPenaltyBody =>
      'A kubb thrown out of bounds twice becomes a penalty kubb: the other team places it anywhere in their half — even right next to the king.';

  @override
  String get ruleKubbAdvantageTitle => 'The advantage line';

  @override
  String get ruleKubbAdvantageBody =>
      'If your opponents leave field kubbs standing in your half, your team may throw its batons from level with the one closest to the king.';

  @override
  String get ruleKubbKingTitle => 'The king decides it';

  @override
  String get ruleKubbKingBody =>
      'Only when every kubb in the defending half is down may you aim for the king. Topple it, and the game is yours.';

  @override
  String get ruleKubbEarlyKingTitle => 'Never too early';

  @override
  String get ruleKubbEarlyKingBody =>
      'Knock the king over before everything else is down — even by accident — and your team loses the game on the spot.';

  @override
  String get ruleKubbMatchTitle => 'Best of three';

  @override
  String get ruleKubbMatchBody =>
      'Tournaments play a match as best of three games. The teams alternate which side opens each game.';

  @override
  String get ruleKubbMatchDetail =>
      'With the turn clock on, a team has a fixed time to throw its six batons. The clock is a guide — the app never blocks a throw.';

  @override
  String get tourModePickTitle => 'Which game are you playing?';

  @override
  String get tourModePickBody =>
      'Both live in this app. Pick one to learn — you can switch any time.';

  @override
  String get tourModeNumberDesc => 'Twelve numbered pins. Race to exactly 50.';

  @override
  String get tourModeKubbDesc => 'Two teams, five kubbs each — and the king.';

  @override
  String get statKingsFelled => 'Kings toppled';

  @override
  String get statKubbsPerBaton => 'Kubbs per baton';

  @override
  String get statAdvantageTurns => 'Advantage turns';

  @override
  String get statEarlyKings => 'Early kings';

  @override
  String get filterAll => 'All';
}
