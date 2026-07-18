// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'iKubb';

  @override
  String get tagline => 'El marcador del kubb numérico';

  @override
  String get startScoring => 'Conozco las reglas — empezar a puntuar';

  @override
  String get teachMe => 'Enséñame el juego';

  @override
  String get quickStart => 'Inicio rápido';

  @override
  String get newGame => 'Nueva partida';

  @override
  String get rules => 'Reglas';

  @override
  String get stats => 'Estadísticas';

  @override
  String get confirmThrow => 'Confirmar lanzamiento';

  @override
  String get miss => 'Fallo';

  @override
  String get undo => 'Deshacer';

  @override
  String needsExactly(int points) {
    return 'Necesita exactamente $points';
  }

  @override
  String overshootWarning(int resetScore) {
    return 'Pasado — vuelve a $resetScore';
  }

  @override
  String winnerBanner(String name) {
    return '¡$name gana!';
  }

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get players => 'Jugadores';

  @override
  String get addPlayer => 'Añadir jugador';

  @override
  String get playerName => 'Nombre';

  @override
  String get recentPlayers => 'Jugadores recientes';

  @override
  String get teams => 'Equipos';

  @override
  String get teamA => 'Equipo A';

  @override
  String get teamB => 'Equipo B';

  @override
  String get autoBalance => 'Repartir automáticamente';

  @override
  String get houseRules => 'Reglas de la casa';

  @override
  String get targetScore => 'Puntuación objetivo';

  @override
  String get overshootRule => 'Pasarse';

  @override
  String get policyReset => 'Reiniciar';

  @override
  String get policyHalf => 'Mitad del objetivo';

  @override
  String get policyNone => 'Sin penalización';

  @override
  String get eliminationRule => 'Eliminación';

  @override
  String get missLimit => 'Fallos para la eliminación';

  @override
  String get shuffleOrder => 'Mezclar el orden';

  @override
  String get startGame => 'Empezar partida';

  @override
  String get needTwoPlayers => 'Añade al menos 2 jugadores';

  @override
  String get needBothTeams => 'Cada equipo necesita un jugador';

  @override
  String get custom => 'Personalizado';

  @override
  String get rulesSearchHint => 'Buscar en las reglas';

  @override
  String get rulesNoResults => 'Ninguna regla coincide';

  @override
  String get activeRulesLabel => 'Esta partida';

  @override
  String get catSetup => 'Preparación & campo';

  @override
  String get catThrowing => 'El lanzamiento';

  @override
  String get catScoring => 'Los puntos';

  @override
  String get catOvershoot => 'Pasarse & reinicio';

  @override
  String get catMisses => 'Fallos & eliminación';

  @override
  String get catWinning => 'Ganar';

  @override
  String get catTeams => 'Equipos';

  @override
  String get ruleFormationTitle => 'La formación';

  @override
  String get ruleFormationBody =>
      'Los 12 bolos numerados empiezan en un rombo compacto, a 3–4 metros de la línea de lanzamiento.';

  @override
  String get rulePinsStandTitle => 'Los bolos se quedan donde caen';

  @override
  String get rulePinsStandBody =>
      'Tras cada lanzamiento, los bolos derribados se levantan donde aterrizaron — el campo se va extendiendo durante la partida.';

  @override
  String get ruleTurnsTitle => 'Por turnos';

  @override
  String get ruleTurnsBody =>
      'Cada bando lanza un palo por turno, siempre en el mismo orden.';

  @override
  String get ruleUnderhandTitle => 'Lanza por debajo';

  @override
  String get ruleUnderhandBody => 'El palo se lanza siempre por debajo.';

  @override
  String get ruleOnePinTitle => 'Un bolo derribado';

  @override
  String get ruleOnePinBody =>
      'Derriba exactamente un bolo y anotas su número.';

  @override
  String get ruleManyPinsTitle => 'Varios bolos derribados';

  @override
  String get ruleManyPinsBody =>
      'Derriba varios bolos y anotas el número de bolos, no su suma.';

  @override
  String get ruleManyPinsDetail =>
      'Ejemplo: derribar los bolos 7, 9 y 12 vale 3 puntos.';

  @override
  String get ruleLeaningTitle => 'Los bolos apoyados no cuentan';

  @override
  String get ruleLeaningBody =>
      'Un bolo apoyado en otro bolo o en el palo no cuenta como derribado.';

  @override
  String get ruleOvershootTitle => 'No te pases del objetivo';

  @override
  String get ruleOvershootBody =>
      'Si tu puntuación superara el objetivo, retrocedes (clásico: pasarte de 50 te deja en 25).';

  @override
  String get ruleOvershootDetail =>
      'Las reglas de la casa pueden cambiarlo: volver a la mitad del objetivo o sin penalización.';

  @override
  String get ruleMissesTitle => 'Tres fallos y estás fuera';

  @override
  String get ruleMissesBody =>
      'No anotes nada tres turnos seguidos y quedas eliminado (cuando la eliminación está activada).';

  @override
  String get ruleMissesDetail =>
      'Los puntos de tu tarjeta de jugador siguen tu racha de fallos.';

  @override
  String get ruleExactTitle => 'Alcanza el objetivo exacto';

  @override
  String get ruleExactBody =>
      'El primer bando en llegar exactamente a la puntuación objetivo gana la partida.';

  @override
  String get ruleLastStandingTitle => 'El último en pie';

  @override
  String get ruleLastStandingBody =>
      'Si todos los demás bandos quedan eliminados, gana el que queda.';

  @override
  String get ruleTeamsTitle => 'Solo o en equipos';

  @override
  String get ruleTeamsBody =>
      'Juega uno contra uno o en dos equipos — un equipo lanza como un solo bando y sus miembros se alternan.';

  @override
  String get rematch => 'Revancha';

  @override
  String get skip => 'Omitir';

  @override
  String get next => 'Siguiente';

  @override
  String get tourTryIt => 'Pruébalo — toca los bolos caídos';

  @override
  String get historyTitle => 'Historial';

  @override
  String get noGamesYet => 'Aún no hay partidas — ¡el campo espera!';

  @override
  String get gamesPlayed => 'Partidas';

  @override
  String get wins => 'Victorias';

  @override
  String get winRate => 'Porcentaje de victorias';

  @override
  String get avgPerThrow => 'Media de puntos por lanzamiento';

  @override
  String get mostHitPin => 'Bolo favorito';

  @override
  String get statMisses => 'Fallos';

  @override
  String get statOvershoots => 'Pasadas';

  @override
  String get statEliminations => 'Eliminaciones';
}
