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
  /// **'The number kubb scoreboard'**
  String get tagline;

  /// No description provided for @startScoring.
  ///
  /// In en, this message translates to:
  /// **'I know the rules — start scoring'**
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

  /// No description provided for @needsExactly.
  ///
  /// In en, this message translates to:
  /// **'Needs exactly {points}'**
  String needsExactly(int points);

  /// No description provided for @overshootWarning.
  ///
  /// In en, this message translates to:
  /// **'Overshoot — back to {resetScore}'**
  String overshootWarning(int resetScore);

  /// No description provided for @winnerBanner.
  ///
  /// In en, this message translates to:
  /// **'{name} wins!'**
  String winnerBanner(String name);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

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

  /// No description provided for @policyReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get policyReset;

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
  /// **'Misses to eliminate'**
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
  /// **'This game'**
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
  /// **'The 12 numbered pins start in a tight diamond formation, 3 to 4 metres from the throwing line.'**
  String get ruleFormationBody;

  /// No description provided for @rulePinsStandTitle.
  ///
  /// In en, this message translates to:
  /// **'Pins stand where they fall'**
  String get rulePinsStandTitle;

  /// No description provided for @rulePinsStandBody.
  ///
  /// In en, this message translates to:
  /// **'After each throw, knocked pins are stood upright on the spot where they landed — the field spreads out as the game goes on.'**
  String get rulePinsStandBody;

  /// No description provided for @ruleTurnsTitle.
  ///
  /// In en, this message translates to:
  /// **'Take turns'**
  String get ruleTurnsTitle;

  /// No description provided for @ruleTurnsBody.
  ///
  /// In en, this message translates to:
  /// **'Sides throw one stick per turn, always in the same order.'**
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
  /// **'A pin resting on another pin or on the stick doesn\'t count as fallen.'**
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
  /// **'The dots on your player card track your miss streak.'**
  String get ruleMissesDetail;

  /// No description provided for @ruleExactTitle.
  ///
  /// In en, this message translates to:
  /// **'Hit the target exactly'**
  String get ruleExactTitle;

  /// No description provided for @ruleExactBody.
  ///
  /// In en, this message translates to:
  /// **'The first side to reach exactly the target score wins the game.'**
  String get ruleExactBody;

  /// No description provided for @ruleLastStandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Last one standing'**
  String get ruleLastStandingTitle;

  /// No description provided for @ruleLastStandingBody.
  ///
  /// In en, this message translates to:
  /// **'If every other side is eliminated, the remaining side wins.'**
  String get ruleLastStandingBody;

  /// No description provided for @ruleTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Solo or in teams'**
  String get ruleTeamsTitle;

  /// No description provided for @ruleTeamsBody.
  ///
  /// In en, this message translates to:
  /// **'Play one against one, or in two teams — a team throws as one side, with members taking turns.'**
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
  /// **'Avg points per throw'**
  String get avgPerThrow;

  /// No description provided for @mostHitPin.
  ///
  /// In en, this message translates to:
  /// **'Favorite pin'**
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
  /// **'System default'**
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

  /// No description provided for @pinSemantics.
  ///
  /// In en, this message translates to:
  /// **'Pin {number}'**
  String pinSemantics(int number);
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
