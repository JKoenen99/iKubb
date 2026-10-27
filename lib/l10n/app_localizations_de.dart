// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Kaato';

  @override
  String get tagline => 'Das Nummern-Kubb-Scoreboard';

  @override
  String get startScoring => 'Ich kenne die Regeln, los geht\'s';

  @override
  String get teachMe => 'Bring mir das Spiel bei';

  @override
  String get quickStart => 'Schnellstart';

  @override
  String get newGame => 'Neues Spiel';

  @override
  String get rules => 'Regeln';

  @override
  String get stats => 'Statistiken';

  @override
  String get miss => 'Fehlwurf';

  @override
  String get undo => 'Rückgängig';

  @override
  String needsExactly(int points) {
    return 'Braucht genau $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Überworfen — zurück auf $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '$name gewinnt!';
  }

  @override
  String get players => 'Spieler';

  @override
  String get addPlayer => 'Spieler hinzufügen';

  @override
  String get teams => 'Teams';

  @override
  String get teamA => 'Team A';

  @override
  String get teamB => 'Team B';

  @override
  String get autoBalance => 'Automatisch aufteilen';

  @override
  String get houseRules => 'Hausregeln';

  @override
  String get targetScore => 'Zielpunktzahl';

  @override
  String policyReset(int score) {
    return 'Zurück auf $score';
  }

  @override
  String get policyHalf => 'Hälfte des Ziels';

  @override
  String get policyNone => 'Keine Strafe';

  @override
  String get eliminationRule => 'Ausscheiden';

  @override
  String get missLimit => 'Fehlwürfe bis zum Ausscheiden';

  @override
  String get shuffleOrder => 'Reihenfolge mischen';

  @override
  String get startGame => 'Spiel starten';

  @override
  String get needTwoPlayers => 'Mindestens 2 Spieler hinzufügen';

  @override
  String get needBothTeams => 'Beide Teams brauchen einen Spieler';

  @override
  String get custom => 'Eigener Wert';

  @override
  String get rulesSearchHint => 'Regeln durchsuchen';

  @override
  String get rulesNoResults => 'Keine passenden Regeln gefunden';

  @override
  String get activeRulesLabel => 'Geltende Hausregeln';

  @override
  String get catSetup => 'Aufbau & Feld';

  @override
  String get catThrowing => 'Werfen';

  @override
  String get catScoring => 'Punkte';

  @override
  String get catOvershoot => 'Überwerfen & Zurückfallen';

  @override
  String get catMisses => 'Fehlwürfe & Ausscheiden';

  @override
  String get catWinning => 'Gewinnen';

  @override
  String get catTeams => 'Teams';

  @override
  String get ruleFormationTitle => 'Die Aufstellung';

  @override
  String get ruleFormationBody =>
      'Die 12 nummerierten Kegel starten in einer engen Rautenformation, 3 bis 4 Meter von der Wurflinie entfernt.';

  @override
  String get rulePinsStandTitle => 'Kegel bleiben, wo sie fallen';

  @override
  String get rulePinsStandBody =>
      'Nach jedem Wurf werden umgefallene Kegel dort aufgestellt, wo sie gelandet sind — das Feld verteilt sich im Laufe des Spiels.';

  @override
  String get ruleTurnsTitle => 'Abwechselnd werfen';

  @override
  String get ruleTurnsBody =>
      'Alle werfen abwechselnd in fester Reihenfolge — ein Wurfholz pro Wurf.';

  @override
  String get ruleUnderhandTitle => 'Von unten werfen';

  @override
  String get ruleUnderhandBody => 'Der Stock wird immer von unten geworfen.';

  @override
  String get ruleOnePinTitle => 'Ein Kegel fällt';

  @override
  String get ruleOnePinBody =>
      'Wirf genau einen Kegel um und du erhältst dessen Nummer als Punkte.';

  @override
  String get ruleManyPinsTitle => 'Mehrere Kegel fallen';

  @override
  String get ruleManyPinsBody =>
      'Wirf mehrere Kegel um und du erhältst die Anzahl der Kegel, nicht ihre Summe.';

  @override
  String get ruleManyPinsDetail =>
      'Beispiel: Kegel 7, 9 und 12 umzuwerfen ergibt 3 Punkte.';

  @override
  String get ruleLeaningTitle => 'Angelehnte Kegel zählen nicht';

  @override
  String get ruleLeaningBody =>
      'Ein Kegel, der auf einem anderen Kegel oder dem Wurfholz liegt, zählt nicht als umgeworfen.';

  @override
  String get ruleOvershootTitle => 'Nicht überwerfen';

  @override
  String get ruleOvershootBody =>
      'Würde deine Punktzahl das Ziel überschreiten, fällst du zurück (klassisch: über 50 wirft dich auf 25 zurück).';

  @override
  String get ruleOvershootDetail =>
      'Hausregeln können das ändern: zurück auf die Hälfte des Ziels oder ganz ohne Strafe.';

  @override
  String get ruleMissesTitle => 'Dreimal daneben und du bist raus';

  @override
  String get ruleMissesBody =>
      'Wer drei Runden in Folge nichts trifft, scheidet aus (wenn Ausscheiden aktiviert ist).';

  @override
  String get ruleMissesDetail =>
      'Die Punkte auf der Scorekarte zählen die Fehlwurfserie.';

  @override
  String get ruleExactTitle => 'Triff das Ziel genau';

  @override
  String get ruleExactBody =>
      'Wer als Erster genau die Zielpunktzahl erreicht — Spieler oder Team — gewinnt das Spiel.';

  @override
  String get ruleLastStandingTitle => 'Wer übrig bleibt, gewinnt';

  @override
  String get ruleLastStandingBody =>
      'Sind alle anderen ausgeschieden, gewinnt der letzte verbleibende Spieler oder das letzte Team.';

  @override
  String get ruleTeamsTitle => 'Allein oder im Team';

  @override
  String get ruleTeamsBody =>
      'Spielt eins gegen eins oder in zwei Teams — ein Team teilt sich einen Zug, die Mitglieder werfen abwechselnd.';

  @override
  String get rematch => 'Revanche';

  @override
  String get skip => 'Überspringen';

  @override
  String get next => 'Weiter';

  @override
  String get tourTryIt => 'Probier es aus — tippe auf die umgefallenen Kegel';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get noGamesYet => 'Noch keine Spiele — das Feld wartet!';

  @override
  String get gamesPlayed => 'Spiele';

  @override
  String get wins => 'Siege';

  @override
  String get winRate => 'Siegquote';

  @override
  String get avgPerThrow => 'Punkte pro Wurf';

  @override
  String get mostHitPin => 'Meistgetroffener Kegel';

  @override
  String get statMisses => 'Fehlwürfe';

  @override
  String get statOvershoots => 'Überwürfe';

  @override
  String get statEliminations => 'Ausscheidungen';

  @override
  String get numberPad => 'Zahlenfeld';

  @override
  String get tapPins => 'Kegel antippen';

  @override
  String get scoreboardMode => 'Anzeigetafel';

  @override
  String get share => 'Teilen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get systemDefault => 'System';

  @override
  String get haptics => 'Haptik';

  @override
  String get keepAwake => 'Bildschirm anlassen';

  @override
  String get homeLabel => 'Start';

  @override
  String pinSemantics(int number) {
    return 'Kegel $number';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get newGameConfirmTitle => 'Neues Spiel starten?';

  @override
  String get newGameConfirmBody => 'Das laufende Spiel geht verloren.';

  @override
  String get theme => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get delete => 'Löschen';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get clearHistoryConfirmBody =>
      'Das löscht jedes Spiel und alle Statistiken.';

  @override
  String get modeNumber => 'Nummern-Kubb';

  @override
  String get offLabel => 'Aus';

  @override
  String get done => 'Fertig';

  @override
  String get closeLabel => 'Schließen';

  @override
  String get increaseLabel => 'Mehr';

  @override
  String get decreaseLabel => 'Weniger';

  @override
  String missesSemantics(int count, int limit) {
    return '$count von $limit Fehlwürfen';
  }

  @override
  String get statsErrorBody =>
      'Deine Statistiken konnten nicht geladen werden.';

  @override
  String get retryLabel => 'Erneut versuchen';

  @override
  String get deleteGameLabel => 'Spiel löschen';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsDuringPlay => 'Beim Spielen';

  @override
  String get settingsLearn => 'Lernen';

  @override
  String get settingsAbout => 'Über';

  @override
  String get designSystemLabel => 'Designsystem';

  @override
  String get licensesLabel => 'Open-Source-Lizenzen';

  @override
  String confirmThrowCount(int count) {
    return 'Wurf bestätigen (+$count)';
  }

  @override
  String resumeGameSummary(String summary) {
    return 'Spiel fortsetzen · $summary';
  }

  @override
  String get deleteGameConfirmBody =>
      'Dieses Spiel wird aus deinem Verlauf entfernt.';

  @override
  String playerN(int n) {
    return 'Spieler $n';
  }

  @override
  String removePlayer(String name) {
    return '$name entfernen';
  }

  @override
  String get showDetails => 'Mehr Details';

  @override
  String get opensRuleHint => 'Öffnet die Regel';

  @override
  String get clearSearch => 'Suche löschen';

  @override
  String scoredAnnouncement(String name, int points, int total) {
    return '$name wirft $points, jetzt bei $total';
  }

  @override
  String missAnnouncement(String name) {
    return '$name wirft daneben';
  }

  @override
  String overshootAnnouncement(String name, int total) {
    return '$name überwirft und fällt auf $total';
  }

  @override
  String eliminatedAnnouncement(String name) {
    return '$name ist ausgeschieden';
  }

  @override
  String get feedbackPromptGameTitle => 'Wie war das Zählen mit Kaato?';

  @override
  String get feedbackPromptTourTitle => 'Hat die Tour das Spiel erklärt?';

  @override
  String get feedbackSheetTitle => 'Dein Feedback';

  @override
  String get feedbackNotNow => 'Nicht jetzt';

  @override
  String feedbackStarsSemantics(int count) {
    return '$count von 5 Sternen';
  }

  @override
  String get feedbackWhatLiked => 'Was hat gut funktioniert?';

  @override
  String get feedbackWhatImprove => 'Was könnte besser sein?';

  @override
  String get feedbackCommentHint => 'Noch etwas? (optional)';

  @override
  String get feedbackSubmit => 'Feedback senden';

  @override
  String get feedbackThanks => 'Danke, das hilft uns weiter!';

  @override
  String get feedbackSection => 'Feedback';

  @override
  String get feedbackGive => 'Feedback geben';

  @override
  String get feedbackGiveSubtitle =>
      'Sag dem Entwickler, was besser werden soll';

  @override
  String get feedbackPrivacyNote =>
      'Anonym: Wir speichern nur Bewertung, Tags, Kommentar und App-Version.';

  @override
  String get tagEasyScoring => 'Einfaches Zählen';

  @override
  String get tagRulesHelpful => 'Regeln haben geholfen';

  @override
  String get tagLooksGreat => 'Sieht toll aus';

  @override
  String get tagFast => 'Schnell';

  @override
  String get tagStatsFun => 'Statistiken machen Spaß';

  @override
  String get tagShareCard => 'Teilen-Karte';

  @override
  String get tagConfusing => 'Verwirrend';

  @override
  String get tagMissingFeature => 'Funktion fehlt';

  @override
  String get tagBug => 'Etwas ging kaputt';

  @override
  String get tagTooManyTaps => 'Zu viele Taps';

  @override
  String get tagRulesUnclear => 'Regeln unklar';

  @override
  String get tagTranslation => 'Übersetzungsfehler';

  @override
  String get tagOther => 'Sonstiges';

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spieler',
      one: '1 Spieler',
    );
    return '$_temp0';
  }

  @override
  String get namesOptionalHint =>
      'Namen sind optional. Tippe auf einen Namen, um ihn zu ändern.';

  @override
  String get recentLabel => 'Zuletzt';

  @override
  String get teamsOffDesc => 'Jeder spielt für sich.';

  @override
  String get teamsOnDesc =>
      'Punkte zählen pro Team. Tippe auf eine Pille, um einen Spieler zu verschieben.';

  @override
  String get swapTeams => 'Teams tauschen';

  @override
  String moveToTeam(String name, String team) {
    return '$name zu $team verschieben';
  }

  @override
  String get resetLabel => 'Zurücksetzen';

  @override
  String get targetScoreDesc => 'Genau treffen, um zu gewinnen';

  @override
  String get backToLabel => 'Zurück auf';

  @override
  String get backToDesc => 'Punktestand nach Überwerfen';

  @override
  String get eliminationDesc => 'Fehlwürfe in Folge, bis du draußen bist';

  @override
  String summaryFirstTo(int target) {
    return 'zuerst auf $target';
  }

  @override
  String summaryBackTo(int reset) {
    return 'zurück auf $reset';
  }

  @override
  String summaryOutAfter(int misses) {
    return 'raus nach $misses Fehlwürfen';
  }

  @override
  String get summaryNoPenalty => 'keine Strafe';

  @override
  String get summaryNoElimination => 'kein Ausscheiden';

  @override
  String get summaryInTeams => 'in Teams';

  @override
  String get editValueTitle => 'Wert eingeben';

  @override
  String renamePlayer(String name) {
    return '$name umbenennen';
  }

  @override
  String appVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String appVersionWithCommit(String version, String commit) {
    return 'Version $version, Commit $commit';
  }
}
