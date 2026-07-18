// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'Die Anzeigetafel für Nummern-Kubb';

  @override
  String get startScoring => 'Ich kenne die Regeln — Punkte zählen';

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
  String get confirmThrow => 'Wurf bestätigen';

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
  String get comingSoon => 'Bald verfügbar';

  @override
  String get players => 'Spieler';

  @override
  String get addPlayer => 'Spieler hinzufügen';

  @override
  String get playerName => 'Name';

  @override
  String get recentPlayers => 'Zuletzt gespielt';

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
  String get overshootRule => 'Überwerfen';

  @override
  String get policyReset => 'Zurücksetzen';

  @override
  String get policyHalf => 'Hälfte des Ziels';

  @override
  String get policyNone => 'Keine Strafe';

  @override
  String get eliminationRule => 'Ausscheiden';

  @override
  String get missLimit => 'Fehlwürfe bis zum Aus';

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
  String get activeRulesLabel => 'Dieses Spiel';

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
      'Jede Partei wirft einen Stock pro Runde, immer in derselben Reihenfolge.';

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
      'Ein Kegel, der auf einem anderen Kegel oder dem Stock liegt, gilt nicht als gefallen.';

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
      'Die Punkte auf deiner Spielerkarte zeigen deine Fehlwurfserie.';

  @override
  String get ruleExactTitle => 'Triff das Ziel genau';

  @override
  String get ruleExactBody =>
      'Die erste Partei, die genau die Zielpunktzahl erreicht, gewinnt das Spiel.';

  @override
  String get ruleLastStandingTitle => 'Wer übrig bleibt, gewinnt';

  @override
  String get ruleLastStandingBody =>
      'Sind alle anderen Parteien ausgeschieden, gewinnt die verbleibende Partei.';

  @override
  String get ruleTeamsTitle => 'Allein oder im Team';

  @override
  String get ruleTeamsBody =>
      'Spiele eins gegen eins oder in zwei Teams — ein Team wirft als eine Partei, die Mitglieder wechseln sich ab.';

  @override
  String get rematch => 'Revanche';
}
