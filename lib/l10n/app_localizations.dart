import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('it'),
    Locale('nb'),
    Locale('nl'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'iKubb'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'The kubb scoreboard'**
  String get tagline;

  /// No description provided for @startScoring.
  ///
  /// In en, this message translates to:
  /// **'I know the rules, start scoring'**
  String get startScoring;

  /// No description provided for @teachMe.
  ///
  /// In en, this message translates to:
  /// **'Teach me the game'**
  String get teachMe;

  /// No description provided for @quickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick start'**
  String get quickStart;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @confirmThrow.
  ///
  /// In en, this message translates to:
  /// **'Confirm throw'**
  String get confirmThrow;

  /// No description provided for @miss.
  ///
  /// In en, this message translates to:
  /// **'Miss'**
  String get miss;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Helper line under the active side: points still needed
  ///
  /// In en, this message translates to:
  /// **'Needs exactly {points}'**
  String needsExactly(int points);

  /// Confirm-button label when the selection would bust; value is the reset score
  ///
  /// In en, this message translates to:
  /// **'Overshoot — back to {resetScore}'**
  String overshootWarning(int resetScore);

  /// Celebration banner with the winning side name
  ///
  /// In en, this message translates to:
  /// **'{name} wins!'**
  String winnerBanner(String name);

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add player'**
  String get addPlayer;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get playerName;

  /// No description provided for @recentPlayers.
  ///
  /// In en, this message translates to:
  /// **'Recent players'**
  String get recentPlayers;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @teamA.
  ///
  /// In en, this message translates to:
  /// **'Team A'**
  String get teamA;

  /// No description provided for @teamB.
  ///
  /// In en, this message translates to:
  /// **'Team B'**
  String get teamB;

  /// No description provided for @autoBalance.
  ///
  /// In en, this message translates to:
  /// **'Auto-balance'**
  String get autoBalance;

  /// No description provided for @houseRules.
  ///
  /// In en, this message translates to:
  /// **'House rules'**
  String get houseRules;

  /// No description provided for @targetScore.
  ///
  /// In en, this message translates to:
  /// **'Target score'**
  String get targetScore;

  /// No description provided for @overshootRule.
  ///
  /// In en, this message translates to:
  /// **'Overshoot'**
  String get overshootRule;

  /// Overshoot policy label; value is the score a side drops to
  ///
  /// In en, this message translates to:
  /// **'Back to {score}'**
  String policyReset(int score);

  /// No description provided for @policyHalf.
  ///
  /// In en, this message translates to:
  /// **'Half of target'**
  String get policyHalf;

  /// No description provided for @policyNone.
  ///
  /// In en, this message translates to:
  /// **'No penalty'**
  String get policyNone;

  /// No description provided for @eliminationRule.
  ///
  /// In en, this message translates to:
  /// **'Elimination'**
  String get eliminationRule;

  /// No description provided for @missLimit.
  ///
  /// In en, this message translates to:
  /// **'Misses before elimination'**
  String get missLimit;

  /// No description provided for @shuffleOrder.
  ///
  /// In en, this message translates to:
  /// **'Shuffle order'**
  String get shuffleOrder;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get startGame;

  /// No description provided for @needTwoPlayers.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 players'**
  String get needTwoPlayers;

  /// No description provided for @needBothTeams.
  ///
  /// In en, this message translates to:
  /// **'Both teams need a player'**
  String get needBothTeams;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @rulesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search the rules'**
  String get rulesSearchHint;

  /// No description provided for @rulesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No rules match your search'**
  String get rulesNoResults;

  /// No description provided for @activeRulesLabel.
  ///
  /// In en, this message translates to:
  /// **'House rules in play'**
  String get activeRulesLabel;

  /// No description provided for @catSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup & field'**
  String get catSetup;

  /// No description provided for @catThrowing.
  ///
  /// In en, this message translates to:
  /// **'Throwing'**
  String get catThrowing;

  /// No description provided for @catScoring.
  ///
  /// In en, this message translates to:
  /// **'Scoring'**
  String get catScoring;

  /// No description provided for @catOvershoot.
  ///
  /// In en, this message translates to:
  /// **'Overshoot & reset'**
  String get catOvershoot;

  /// No description provided for @catMisses.
  ///
  /// In en, this message translates to:
  /// **'Misses & elimination'**
  String get catMisses;

  /// No description provided for @catWinning.
  ///
  /// In en, this message translates to:
  /// **'Winning'**
  String get catWinning;

  /// No description provided for @catTeams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get catTeams;

  /// No description provided for @ruleFormationTitle.
  ///
  /// In en, this message translates to:
  /// **'The formation'**
  String get ruleFormationTitle;

  /// No description provided for @ruleFormationBody.
  ///
  /// In en, this message translates to:
  /// **'The 12 numbered pins start in a tight diamond formation, 3 to 4 meters from the throwing line.'**
  String get ruleFormationBody;

  /// No description provided for @rulePinsStandTitle.
  ///
  /// In en, this message translates to:
  /// **'Pins stand where they fall'**
  String get rulePinsStandTitle;

  /// No description provided for @rulePinsStandBody.
  ///
  /// In en, this message translates to:
  /// **'After each throw, knocked-over pins are stood upright on the spot where they landed — the field spreads out as the game goes on.'**
  String get rulePinsStandBody;

  /// No description provided for @ruleTurnsTitle.
  ///
  /// In en, this message translates to:
  /// **'Take turns'**
  String get ruleTurnsTitle;

  /// No description provided for @ruleTurnsBody.
  ///
  /// In en, this message translates to:
  /// **'Players take turns in a fixed order — one stick per throw.'**
  String get ruleTurnsBody;

  /// No description provided for @ruleUnderhandTitle.
  ///
  /// In en, this message translates to:
  /// **'Throw underhand'**
  String get ruleUnderhandTitle;

  /// No description provided for @ruleUnderhandBody.
  ///
  /// In en, this message translates to:
  /// **'The stick is always thrown underhand.'**
  String get ruleUnderhandBody;

  /// No description provided for @ruleOnePinTitle.
  ///
  /// In en, this message translates to:
  /// **'One pin down'**
  String get ruleOnePinTitle;

  /// No description provided for @ruleOnePinBody.
  ///
  /// In en, this message translates to:
  /// **'Knock over exactly one pin and you score that pin\'s number.'**
  String get ruleOnePinBody;

  /// No description provided for @ruleManyPinsTitle.
  ///
  /// In en, this message translates to:
  /// **'Several pins down'**
  String get ruleManyPinsTitle;

  /// No description provided for @ruleManyPinsBody.
  ///
  /// In en, this message translates to:
  /// **'Knock over several pins and you score the number of pins, not their sum.'**
  String get ruleManyPinsBody;

  /// No description provided for @ruleManyPinsDetail.
  ///
  /// In en, this message translates to:
  /// **'Example: knocking over pins 7, 9 and 12 scores 3 points.'**
  String get ruleManyPinsDetail;

  /// No description provided for @ruleLeaningTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaning pins don\'t count'**
  String get ruleLeaningTitle;

  /// No description provided for @ruleLeaningBody.
  ///
  /// In en, this message translates to:
  /// **'A pin resting on another pin or on the stick doesn\'t count as knocked over.'**
  String get ruleLeaningBody;

  /// No description provided for @ruleOvershootTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t overshoot'**
  String get ruleOvershootTitle;

  /// No description provided for @ruleOvershootBody.
  ///
  /// In en, this message translates to:
  /// **'If your score would pass the target, it drops back down instead (classic: overshooting 50 puts you on 25).'**
  String get ruleOvershootBody;

  /// No description provided for @ruleOvershootDetail.
  ///
  /// In en, this message translates to:
  /// **'House rules can change this: reset to half of the target, or no penalty at all.'**
  String get ruleOvershootDetail;

  /// No description provided for @ruleMissesTitle.
  ///
  /// In en, this message translates to:
  /// **'Three misses and you\'re out'**
  String get ruleMissesTitle;

  /// No description provided for @ruleMissesBody.
  ///
  /// In en, this message translates to:
  /// **'Score nothing three turns in a row and you\'re eliminated (when elimination is enabled).'**
  String get ruleMissesBody;

  /// No description provided for @ruleMissesDetail.
  ///
  /// In en, this message translates to:
  /// **'The dots on the score card track the miss streak.'**
  String get ruleMissesDetail;

  /// No description provided for @ruleExactTitle.
  ///
  /// In en, this message translates to:
  /// **'Hit the target exactly'**
  String get ruleExactTitle;

  /// No description provided for @ruleExactBody.
  ///
  /// In en, this message translates to:
  /// **'The first player or team to reach exactly the target score wins the game.'**
  String get ruleExactBody;

  /// No description provided for @ruleLastStandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Last one standing'**
  String get ruleLastStandingTitle;

  /// No description provided for @ruleLastStandingBody.
  ///
  /// In en, this message translates to:
  /// **'If everyone else is eliminated, the last player or team standing wins.'**
  String get ruleLastStandingBody;

  /// No description provided for @ruleTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Solo or in teams'**
  String get ruleTeamsTitle;

  /// No description provided for @ruleTeamsBody.
  ///
  /// In en, this message translates to:
  /// **'Play one against one, or in two teams — a team shares one turn, with members alternating throws.'**
  String get ruleTeamsBody;

  /// No description provided for @rematch.
  ///
  /// In en, this message translates to:
  /// **'Rematch'**
  String get rematch;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @tourTryIt.
  ///
  /// In en, this message translates to:
  /// **'Try it — tap the pins that fell'**
  String get tourTryIt;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @noGamesYet.
  ///
  /// In en, this message translates to:
  /// **'No games yet — the field awaits!'**
  String get noGamesYet;

  /// No description provided for @gamesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get gamesPlayed;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get winRate;

  /// No description provided for @avgPerThrow.
  ///
  /// In en, this message translates to:
  /// **'Points per throw'**
  String get avgPerThrow;

  /// No description provided for @mostHitPin.
  ///
  /// In en, this message translates to:
  /// **'Most-hit pin'**
  String get mostHitPin;

  /// No description provided for @statMisses.
  ///
  /// In en, this message translates to:
  /// **'Misses'**
  String get statMisses;

  /// No description provided for @statOvershoots.
  ///
  /// In en, this message translates to:
  /// **'Overshoots'**
  String get statOvershoots;

  /// No description provided for @statEliminations.
  ///
  /// In en, this message translates to:
  /// **'Eliminations'**
  String get statEliminations;

  /// No description provided for @numberPad.
  ///
  /// In en, this message translates to:
  /// **'Number pad'**
  String get numberPad;

  /// No description provided for @tapPins.
  ///
  /// In en, this message translates to:
  /// **'Tap the pins'**
  String get tapPins;

  /// No description provided for @scoreboardMode.
  ///
  /// In en, this message translates to:
  /// **'Scoreboard'**
  String get scoreboardMode;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemDefault;

  /// No description provided for @haptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get haptics;

  /// No description provided for @keepAwake.
  ///
  /// In en, this message translates to:
  /// **'Keep screen awake'**
  String get keepAwake;

  /// No description provided for @homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// VoiceOver label of one pin in the diagram
  ///
  /// In en, this message translates to:
  /// **'Pin {number}'**
  String pinSemantics(int number);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @newGameConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new game?'**
  String get newGameConfirmTitle;

  /// No description provided for @newGameConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose the game that\'s underway.'**
  String get newGameConfirmBody;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This clears every game and all stats.'**
  String get clearHistoryConfirmBody;

  /// No description provided for @modeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number kubb'**
  String get modeNumber;

  /// No description provided for @modeKubb.
  ///
  /// In en, this message translates to:
  /// **'Kubb'**
  String get modeKubb;

  /// No description provided for @matchLabel.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get matchLabel;

  /// No description provided for @bestOfSingle.
  ///
  /// In en, this message translates to:
  /// **'Single game'**
  String get bestOfSingle;

  /// No description provided for @bestOfThree.
  ///
  /// In en, this message translates to:
  /// **'Best of three'**
  String get bestOfThree;

  /// No description provided for @turnClockLabel.
  ///
  /// In en, this message translates to:
  /// **'Turn clock'**
  String get turnClockLabel;

  /// No description provided for @offLabel.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get offLabel;

  /// No description provided for @kingLabel.
  ///
  /// In en, this message translates to:
  /// **'King'**
  String get kingLabel;

  /// No description provided for @kingWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Topple the king?'**
  String get kingWarningTitle;

  /// No description provided for @kingWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Not everything is down yet — toppling the king now loses the game.'**
  String get kingWarningBody;

  /// No description provided for @advantageLine.
  ///
  /// In en, this message translates to:
  /// **'Advantage line'**
  String get advantageLine;

  /// No description provided for @throwInTitle.
  ///
  /// In en, this message translates to:
  /// **'Throw the knocked-over kubbs into the attackers\' half.'**
  String get throwInTitle;

  /// No description provided for @outTwice.
  ///
  /// In en, this message translates to:
  /// **'Penalty kubbs (out twice)'**
  String get outTwice;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @nextGameLabel.
  ///
  /// In en, this message translates to:
  /// **'Next game'**
  String get nextGameLabel;

  /// Shown when a team loses by toppling the king too early
  ///
  /// In en, this message translates to:
  /// **'{name} toppled the king too early!'**
  String earlyKingBanner(String name);

  /// No description provided for @catKubbSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup & teams'**
  String get catKubbSetup;

  /// No description provided for @catKubbBatons.
  ///
  /// In en, this message translates to:
  /// **'Throwing batons'**
  String get catKubbBatons;

  /// No description provided for @catKubbFieldKubbs.
  ///
  /// In en, this message translates to:
  /// **'Field kubbs'**
  String get catKubbFieldKubbs;

  /// No description provided for @catKubbKing.
  ///
  /// In en, this message translates to:
  /// **'The king'**
  String get catKubbKing;

  /// No description provided for @ruleKubbFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'The field'**
  String get ruleKubbFieldTitle;

  /// No description provided for @ruleKubbFieldBody.
  ///
  /// In en, this message translates to:
  /// **'Two teams face each other across the field. Each lines up five kubbs on its baseline, and the king stands alone in the middle.'**
  String get ruleKubbFieldBody;

  /// No description provided for @ruleKubbFieldDetail.
  ///
  /// In en, this message translates to:
  /// **'Tournament fields measure 5 × 8 meters. In the park, two jackets and a good guess work fine — just keep the halves roughly equal.'**
  String get ruleKubbFieldDetail;

  /// No description provided for @ruleKubbTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'One to six per team'**
  String get ruleKubbTeamsTitle;

  /// No description provided for @ruleKubbTeamsBody.
  ///
  /// In en, this message translates to:
  /// **'Kubb is a team game: one to six players per team. Teammates share the six batons and take turns throwing.'**
  String get ruleKubbTeamsBody;

  /// No description provided for @ruleKubbBatonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Six batons per turn'**
  String get ruleKubbBatonsTitle;

  /// No description provided for @ruleKubbBatonsBody.
  ///
  /// In en, this message translates to:
  /// **'The attacking team throws six batons at the other team\'s kubbs — underhand, spinning end over end.'**
  String get ruleKubbBatonsBody;

  /// No description provided for @ruleKubbBatonsDetail.
  ///
  /// In en, this message translates to:
  /// **'No helicopter throws: the baton must spin vertically, never sideways. Kubbs felled by the batons stay down until the turn ends.'**
  String get ruleKubbBatonsDetail;

  /// No description provided for @ruleKubbThrowInTitle.
  ///
  /// In en, this message translates to:
  /// **'Felled kubbs come back'**
  String get ruleKubbThrowInTitle;

  /// No description provided for @ruleKubbThrowInBody.
  ///
  /// In en, this message translates to:
  /// **'After the batons, the defenders throw every felled kubb into the attackers\' half. Where a kubb lands, it is stood up as a field kubb.'**
  String get ruleKubbThrowInBody;

  /// No description provided for @ruleKubbThrowInDetail.
  ///
  /// In en, this message translates to:
  /// **'The defenders choose where to aim — kubbs standing close together are far easier to clear with one baton.'**
  String get ruleKubbThrowInDetail;

  /// No description provided for @ruleKubbFieldFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Field kubbs first'**
  String get ruleKubbFieldFirstTitle;

  /// No description provided for @ruleKubbFieldFirstBody.
  ///
  /// In en, this message translates to:
  /// **'Attackers must fell every standing field kubb before any baseline kubb may be hit. A baseline kubb felled too early is raised again.'**
  String get ruleKubbFieldFirstBody;

  /// No description provided for @ruleKubbPenaltyTitle.
  ///
  /// In en, this message translates to:
  /// **'Out twice = penalty'**
  String get ruleKubbPenaltyTitle;

  /// No description provided for @ruleKubbPenaltyBody.
  ///
  /// In en, this message translates to:
  /// **'A kubb thrown out of bounds twice becomes a penalty kubb: the other team places it anywhere in their half — even right next to the king.'**
  String get ruleKubbPenaltyBody;

  /// No description provided for @ruleKubbAdvantageTitle.
  ///
  /// In en, this message translates to:
  /// **'The advantage line'**
  String get ruleKubbAdvantageTitle;

  /// No description provided for @ruleKubbAdvantageBody.
  ///
  /// In en, this message translates to:
  /// **'If your opponents leave field kubbs standing in your half, your team may throw its batons from level with the one closest to the king.'**
  String get ruleKubbAdvantageBody;

  /// No description provided for @ruleKubbKingTitle.
  ///
  /// In en, this message translates to:
  /// **'The king decides it'**
  String get ruleKubbKingTitle;

  /// No description provided for @ruleKubbKingBody.
  ///
  /// In en, this message translates to:
  /// **'Only when every kubb in the defending half is down may you aim for the king. Topple it, and the game is yours.'**
  String get ruleKubbKingBody;

  /// No description provided for @ruleKubbEarlyKingTitle.
  ///
  /// In en, this message translates to:
  /// **'Not before the line is down'**
  String get ruleKubbEarlyKingTitle;

  /// No description provided for @ruleKubbEarlyKingBody.
  ///
  /// In en, this message translates to:
  /// **'Topple the king before everything else is down — even by accident — and your team loses the game on the spot.'**
  String get ruleKubbEarlyKingBody;

  /// No description provided for @ruleKubbMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Best of three'**
  String get ruleKubbMatchTitle;

  /// No description provided for @ruleKubbMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Tournaments play a match as best of three games. The teams alternate which team opens each game.'**
  String get ruleKubbMatchBody;

  /// No description provided for @ruleKubbMatchDetail.
  ///
  /// In en, this message translates to:
  /// **'With the turn clock on, a team has a fixed time to throw its six batons. The clock is a guide — the app never blocks a throw.'**
  String get ruleKubbMatchDetail;

  /// No description provided for @tourModePickTitle.
  ///
  /// In en, this message translates to:
  /// **'Which game are you playing?'**
  String get tourModePickTitle;

  /// No description provided for @tourModePickBody.
  ///
  /// In en, this message translates to:
  /// **'Both live in this app. Pick one to learn — you can switch any time.'**
  String get tourModePickBody;

  /// No description provided for @tourModeNumberDesc.
  ///
  /// In en, this message translates to:
  /// **'Twelve numbered pins. Race to exactly 50.'**
  String get tourModeNumberDesc;

  /// No description provided for @tourModeKubbDesc.
  ///
  /// In en, this message translates to:
  /// **'Two teams, five kubbs each — and the king.'**
  String get tourModeKubbDesc;

  /// No description provided for @statKingsFelled.
  ///
  /// In en, this message translates to:
  /// **'Kings toppled'**
  String get statKingsFelled;

  /// No description provided for @statKubbsPerBaton.
  ///
  /// In en, this message translates to:
  /// **'Kubbs per baton'**
  String get statKubbsPerBaton;

  /// No description provided for @statAdvantageTurns.
  ///
  /// In en, this message translates to:
  /// **'Advantage turns'**
  String get statAdvantageTurns;

  /// No description provided for @statEarlyKings.
  ///
  /// In en, this message translates to:
  /// **'Early kings'**
  String get statEarlyKings;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// No description provided for @increaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increaseLabel;

  /// No description provided for @decreaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decreaseLabel;

  /// VoiceOver label of a standing kubb block (1-based index)
  ///
  /// In en, this message translates to:
  /// **'Kubb {number}, standing'**
  String kubbStandingSemantics(int number);

  /// VoiceOver label of a kubb marked as felled this baton
  ///
  /// In en, this message translates to:
  /// **'Kubb {number}, marked as knocked over'**
  String kubbSelectedSemantics(int number);

  /// No description provided for @kingSafeSemantics.
  ///
  /// In en, this message translates to:
  /// **'The king — topple it to win'**
  String get kingSafeSemantics;

  /// No description provided for @kingRiskySemantics.
  ///
  /// In en, this message translates to:
  /// **'The king — toppling it now loses the game'**
  String get kingRiskySemantics;

  /// VoiceOver summary of the batons-left dot row
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {total} batons left'**
  String batonsLeftSemantics(int remaining, int total);

  /// VoiceOver summary of the miss-streak dot row
  ///
  /// In en, this message translates to:
  /// **'{count} of {limit} misses'**
  String missesSemantics(int count, int limit);

  /// No description provided for @statsErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Your stats couldn\'t be loaded.'**
  String get statsErrorBody;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryLabel;

  /// No description provided for @deleteGameLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete game'**
  String get deleteGameLabel;

  /// No description provided for @newMatchConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new match?'**
  String get newMatchConfirmTitle;

  /// No description provided for @newMatchConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose the match that\'s underway.'**
  String get newMatchConfirmBody;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsDuringPlay.
  ///
  /// In en, this message translates to:
  /// **'During play'**
  String get settingsDuringPlay;

  /// No description provided for @settingsLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get settingsLearn;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @designSystemLabel.
  ///
  /// In en, this message translates to:
  /// **'Design system'**
  String get designSystemLabel;

  /// No description provided for @licensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licensesLabel;

  /// Confirm button with the points (or kubbs) the throw adds
  ///
  /// In en, this message translates to:
  /// **'Confirm throw (+{count})'**
  String confirmThrowCount(int count);

  /// Home primary action for an interrupted game; summary lists sides and scores
  ///
  /// In en, this message translates to:
  /// **'Resume game · {summary}'**
  String resumeGameSummary(String summary);

  /// Games won in a best-of match, side A first
  ///
  /// In en, this message translates to:
  /// **'{a} – {b}'**
  String matchScore(int a, int b);

  /// No description provided for @deleteGameConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This game will be removed from your history.'**
  String get deleteGameConfirmBody;

  /// No description provided for @newMatch.
  ///
  /// In en, this message translates to:
  /// **'New match'**
  String get newMatch;

  /// Default name for an unnamed quick-start player; n is 1-based
  ///
  /// In en, this message translates to:
  /// **'Player {n}'**
  String playerN(int n);

  /// Compact seconds value, e.g. in the active-rules chips
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String secondsShort(int seconds);

  /// Accessibility label of the remove button in a setup player row
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String removePlayer(String name);

  /// No description provided for @showDetails.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get showDetails;

  /// No description provided for @toppleKing.
  ///
  /// In en, this message translates to:
  /// **'Topple the king'**
  String get toppleKing;

  /// VoiceOver label of the kubb turn clock
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds left on the turn clock'**
  String turnClockSemantics(int seconds);

  /// VoiceOver label of the per-team kubbs-remaining number
  ///
  /// In en, this message translates to:
  /// **'{count} baseline kubbs standing'**
  String baselineStandingSemantics(int count);

  /// No description provided for @opensRuleHint.
  ///
  /// In en, this message translates to:
  /// **'Opens the rule'**
  String get opensRuleHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// Announced to assistive tech after a scoring throw
  ///
  /// In en, this message translates to:
  /// **'{name} scores {points}, now at {total}'**
  String scoredAnnouncement(String name, int points, int total);

  /// Announced to assistive tech after a miss
  ///
  /// In en, this message translates to:
  /// **'{name} misses'**
  String missAnnouncement(String name);

  /// Announced to assistive tech after an overshoot
  ///
  /// In en, this message translates to:
  /// **'{name} overshoots and drops to {total}'**
  String overshootAnnouncement(String name, int total);

  /// Announced to assistive tech when a side is eliminated
  ///
  /// In en, this message translates to:
  /// **'{name} is out'**
  String eliminatedAnnouncement(String name);

  /// No description provided for @feedbackPromptGameTitle.
  ///
  /// In en, this message translates to:
  /// **'How was scoring with iKubb?'**
  String get feedbackPromptGameTitle;

  /// No description provided for @feedbackPromptTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Did the tour explain the game?'**
  String get feedbackPromptTourTitle;

  /// No description provided for @feedbackSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get feedbackSheetTitle;

  /// No description provided for @feedbackNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get feedbackNotNow;

  /// VoiceOver label of one star button in the rating row
  ///
  /// In en, this message translates to:
  /// **'{count} of 5 stars'**
  String feedbackStarsSemantics(int count);

  /// No description provided for @feedbackWhatLiked.
  ///
  /// In en, this message translates to:
  /// **'What worked well?'**
  String get feedbackWhatLiked;

  /// No description provided for @feedbackWhatImprove.
  ///
  /// In en, this message translates to:
  /// **'What could be better?'**
  String get feedbackWhatImprove;

  /// No description provided for @feedbackCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Anything else? (optional)'**
  String get feedbackCommentHint;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackSubmit;

  /// No description provided for @feedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks, that helps us improve!'**
  String get feedbackThanks;

  /// No description provided for @feedbackSection.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackSection;

  /// No description provided for @feedbackGive.
  ///
  /// In en, this message translates to:
  /// **'Give feedback'**
  String get feedbackGive;

  /// No description provided for @feedbackGiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell the maker what to improve'**
  String get feedbackGiveSubtitle;

  /// No description provided for @feedbackPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Anonymous: we store only your rating, tags, comment, and the app version.'**
  String get feedbackPrivacyNote;

  /// No description provided for @tagEasyScoring.
  ///
  /// In en, this message translates to:
  /// **'Easy scoring'**
  String get tagEasyScoring;

  /// No description provided for @tagRulesHelpful.
  ///
  /// In en, this message translates to:
  /// **'Rules helped'**
  String get tagRulesHelpful;

  /// No description provided for @tagLooksGreat.
  ///
  /// In en, this message translates to:
  /// **'Looks great'**
  String get tagLooksGreat;

  /// No description provided for @tagFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get tagFast;

  /// No description provided for @tagStatsFun.
  ///
  /// In en, this message translates to:
  /// **'Stats are fun'**
  String get tagStatsFun;

  /// No description provided for @tagShareCard.
  ///
  /// In en, this message translates to:
  /// **'Share card'**
  String get tagShareCard;

  /// No description provided for @tagConfusing.
  ///
  /// In en, this message translates to:
  /// **'Confusing'**
  String get tagConfusing;

  /// No description provided for @tagMissingFeature.
  ///
  /// In en, this message translates to:
  /// **'Missing a feature'**
  String get tagMissingFeature;

  /// No description provided for @tagBug.
  ///
  /// In en, this message translates to:
  /// **'Something broke'**
  String get tagBug;

  /// No description provided for @tagTooManyTaps.
  ///
  /// In en, this message translates to:
  /// **'Too many taps'**
  String get tagTooManyTaps;

  /// No description provided for @tagRulesUnclear.
  ///
  /// In en, this message translates to:
  /// **'Rules unclear'**
  String get tagRulesUnclear;

  /// No description provided for @tagTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation issue'**
  String get tagTranslation;

  /// No description provided for @tagOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get tagOther;

  /// No description provided for @gameSection.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameSection;

  /// No description provided for @modeNumberDesc.
  ///
  /// In en, this message translates to:
  /// **'Score points per kubb. First to the target wins.'**
  String get modeNumberDesc;

  /// No description provided for @modeKubbDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic rules. Clear the field, then the king.'**
  String get modeKubbDesc;

  /// Phone-layout helper line under the mode picker
  ///
  /// In en, this message translates to:
  /// **'Score points per kubb. First to {target} wins.'**
  String modeNumberHint(int target);

  /// Player count after the Players header and in the summary bar
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 player} other{{count} players}}'**
  String playersCount(int count);

  /// No description provided for @namesOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Names are optional. Tap a name to change it.'**
  String get namesOptionalHint;

  /// No description provided for @recentLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentLabel;

  /// No description provided for @teamsOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Everyone plays for themselves.'**
  String get teamsOffDesc;

  /// No description provided for @teamsOnDesc.
  ///
  /// In en, this message translates to:
  /// **'Score counts per team. Tap a pill to move a player.'**
  String get teamsOnDesc;

  /// No description provided for @swapTeams.
  ///
  /// In en, this message translates to:
  /// **'Swap teams'**
  String get swapTeams;

  /// VoiceOver label of the team pill on a player row
  ///
  /// In en, this message translates to:
  /// **'Move {name} to {team}'**
  String moveToTeam(String name, String team);

  /// No description provided for @resetLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetLabel;

  /// No description provided for @targetScoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Hit it exactly to win'**
  String get targetScoreDesc;

  /// No description provided for @backToLabel.
  ///
  /// In en, this message translates to:
  /// **'Back to'**
  String get backToLabel;

  /// No description provided for @backToDesc.
  ///
  /// In en, this message translates to:
  /// **'Score when you overshoot'**
  String get backToDesc;

  /// No description provided for @eliminationDesc.
  ///
  /// In en, this message translates to:
  /// **'Misses in a row before you are out'**
  String get eliminationDesc;

  /// House-rules summary fragment
  ///
  /// In en, this message translates to:
  /// **'first to {target}'**
  String summaryFirstTo(int target);

  /// House-rules summary fragment
  ///
  /// In en, this message translates to:
  /// **'back to {reset}'**
  String summaryBackTo(int reset);

  /// House-rules summary fragment
  ///
  /// In en, this message translates to:
  /// **'out after {misses} misses'**
  String summaryOutAfter(int misses);

  /// No description provided for @summaryNoPenalty.
  ///
  /// In en, this message translates to:
  /// **'no penalty'**
  String get summaryNoPenalty;

  /// No description provided for @summaryNoElimination.
  ///
  /// In en, this message translates to:
  /// **'no elimination'**
  String get summaryNoElimination;

  /// No description provided for @summaryInTeams.
  ///
  /// In en, this message translates to:
  /// **'in teams'**
  String get summaryInTeams;

  /// No description provided for @editValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a value'**
  String get editValueTitle;

  /// VoiceOver label of a tappable player name
  ///
  /// In en, this message translates to:
  /// **'Rename {name}'**
  String renamePlayer(String name);

  /// Settings footer: the installed version, e.g. "0.2.0 (2)".
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersionLabel(String version);

  /// Settings footer with the short git commit the build was made from.
  ///
  /// In en, this message translates to:
  /// **'Version {version}, commit {commit}'**
  String appVersionWithCommit(String version, String commit);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'da',
    'de',
    'en',
    'es',
    'fi',
    'fr',
    'it',
    'nb',
    'nl',
    'sv',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
