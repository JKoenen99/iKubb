// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Kaato';

  @override
  String get tagline => 'El marcador de kubb numérico';

  @override
  String get startScoring => 'Conozco las reglas, a puntuar';

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
  String get players => 'Jugadores';

  @override
  String get addPlayer => 'Añadir jugador';

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
  String policyReset(int score) {
    return 'Vuelta a $score';
  }

  @override
  String get policyHalf => 'Mitad del objetivo';

  @override
  String get policyNone => 'Sin penalización';

  @override
  String get eliminationRule => 'Eliminación';

  @override
  String get missLimit => 'Fallos antes de la eliminación';

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
  String get activeRulesLabel => 'Reglas de la casa en juego';

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
      'Los jugadores lanzan por turnos en un orden fijo: un palo por tiro.';

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
      'Los puntos de la tarjeta de puntuación cuentan los fallos seguidos.';

  @override
  String get ruleExactTitle => 'Alcanza el objetivo exacto';

  @override
  String get ruleExactBody =>
      'El primer jugador o equipo que alcance exactamente la puntuación objetivo gana la partida.';

  @override
  String get ruleLastStandingTitle => 'El último en pie';

  @override
  String get ruleLastStandingBody =>
      'Si todos los demás quedan eliminados, gana el último jugador o equipo en pie.';

  @override
  String get ruleTeamsTitle => 'Solo o en equipos';

  @override
  String get ruleTeamsBody =>
      'Juega uno contra uno o en dos equipos: el equipo comparte un turno y sus miembros alternan los tiros.';

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
  String get avgPerThrow => 'Puntos por tiro';

  @override
  String get mostHitPin => 'Bolo más golpeado';

  @override
  String get statMisses => 'Fallos';

  @override
  String get statOvershoots => 'Pasadas';

  @override
  String get statEliminations => 'Eliminaciones';

  @override
  String get numberPad => 'Teclado numérico';

  @override
  String get tapPins => 'Tocar los bolos';

  @override
  String get scoreboardMode => 'Marcador';

  @override
  String get share => 'Compartir';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Sistema';

  @override
  String get haptics => 'Vibración';

  @override
  String get keepAwake => 'Mantener la pantalla encendida';

  @override
  String get homeLabel => 'Inicio';

  @override
  String pinSemantics(int number) {
    return 'Bolo $number';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get newGameConfirmTitle => '¿Empezar una partida nueva?';

  @override
  String get newGameConfirmBody => 'Perderás la partida en curso.';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get delete => 'Eliminar';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get clearHistoryConfirmBody =>
      'Esto borra todas las partidas y estadísticas.';

  @override
  String get modeNumber => 'Kubb numérico';

  @override
  String get offLabel => 'Apagado';

  @override
  String get done => 'Hecho';

  @override
  String get closeLabel => 'Cerrar';

  @override
  String get increaseLabel => 'Aumentar';

  @override
  String get decreaseLabel => 'Reducir';

  @override
  String missesSemantics(int count, int limit) {
    return '$count de $limit fallos';
  }

  @override
  String get statsErrorBody => 'No se pudieron cargar tus estadísticas.';

  @override
  String get retryLabel => 'Reintentar';

  @override
  String get deleteGameLabel => 'Eliminar partida';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsDuringPlay => 'Durante el juego';

  @override
  String get settingsLearn => 'Aprender';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get designSystemLabel => 'Design system';

  @override
  String get licensesLabel => 'Licencias de código abierto';

  @override
  String confirmThrowCount(int count) {
    return 'Confirmar tiro (+$count)';
  }

  @override
  String resumeGameSummary(String summary) {
    return 'Reanudar partida · $summary';
  }

  @override
  String get deleteGameConfirmBody =>
      'Esta partida se eliminará de tu historial.';

  @override
  String playerN(int n) {
    return 'Jugador $n';
  }

  @override
  String removePlayer(String name) {
    return 'Quitar a $name';
  }

  @override
  String get showDetails => 'Más detalles';

  @override
  String get opensRuleHint => 'Abre la regla';

  @override
  String get clearSearch => 'Borrar búsqueda';

  @override
  String scoredAnnouncement(String name, int points, int total) {
    return '$name anota $points, ahora con $total';
  }

  @override
  String missAnnouncement(String name) {
    return '$name falla';
  }

  @override
  String overshootAnnouncement(String name, int total) {
    return '$name se pasa y baja a $total';
  }

  @override
  String eliminatedAnnouncement(String name) {
    return '$name queda eliminado';
  }

  @override
  String get feedbackPromptGameTitle => '¿Qué tal ha ido anotar con Kaato?';

  @override
  String get feedbackPromptTourTitle => '¿La guía te explicó el juego?';

  @override
  String get feedbackSheetTitle => 'Tu opinión';

  @override
  String get feedbackNotNow => 'Ahora no';

  @override
  String feedbackStarsSemantics(int count) {
    return '$count de 5 estrellas';
  }

  @override
  String get feedbackWhatLiked => '¿Qué ha funcionado bien?';

  @override
  String get feedbackWhatImprove => '¿Qué podría mejorar?';

  @override
  String get feedbackCommentHint => '¿Algo más? (opcional)';

  @override
  String get feedbackSubmit => 'Enviar opinión';

  @override
  String get feedbackThanks => '¡Gracias, nos ayuda a mejorar!';

  @override
  String get feedbackSection => 'Opiniones';

  @override
  String get feedbackGive => 'Dar tu opinión';

  @override
  String get feedbackGiveSubtitle => 'Dile al desarrollador qué mejorar';

  @override
  String get feedbackPrivacyNote =>
      'Anónimo: solo guardamos tu valoración, etiquetas, comentario y la versión de la app.';

  @override
  String get tagEasyScoring => 'Anotar es fácil';

  @override
  String get tagRulesHelpful => 'Las reglas ayudaron';

  @override
  String get tagLooksGreat => 'Se ve genial';

  @override
  String get tagFast => 'Rápida';

  @override
  String get tagStatsFun => 'Las estadísticas molan';

  @override
  String get tagShareCard => 'Tarjeta para compartir';

  @override
  String get tagConfusing => 'Confusa';

  @override
  String get tagMissingFeature => 'Falta una función';

  @override
  String get tagBug => 'Algo falló';

  @override
  String get tagTooManyTaps => 'Demasiados toques';

  @override
  String get tagRulesUnclear => 'Reglas poco claras';

  @override
  String get tagTranslation => 'Problema de traducción';

  @override
  String get tagOther => 'Otro';

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadores',
      one: '1 jugador',
    );
    return '$_temp0';
  }

  @override
  String get namesOptionalHint =>
      'Los nombres son opcionales. Toca uno para cambiarlo.';

  @override
  String get recentLabel => 'Recientes';

  @override
  String get teamsOffDesc => 'Cada uno juega por su cuenta.';

  @override
  String get teamsOnDesc =>
      'La puntuación cuenta por equipo. Toca una etiqueta para mover a un jugador.';

  @override
  String get swapTeams => 'Intercambiar equipos';

  @override
  String moveToTeam(String name, String team) {
    return 'Mover a $name a $team';
  }

  @override
  String get resetLabel => 'Restablecer';

  @override
  String get targetScoreDesc => 'Acierta exactamente para ganar';

  @override
  String get backToLabel => 'Vuelta a';

  @override
  String get backToDesc => 'Puntuación al pasarte';

  @override
  String get eliminationDesc => 'Fallos seguidos antes de quedar fuera';

  @override
  String summaryFirstTo(int target) {
    return 'primero a $target';
  }

  @override
  String summaryBackTo(int reset) {
    return 'vuelta a $reset';
  }

  @override
  String summaryOutAfter(int misses) {
    return 'fuera tras $misses fallos';
  }

  @override
  String get summaryNoPenalty => 'sin castigo';

  @override
  String get summaryNoElimination => 'sin eliminación';

  @override
  String get summaryInTeams => 'por equipos';

  @override
  String get editValueTitle => 'Introduce un valor';

  @override
  String renamePlayer(String name) {
    return 'Cambiar el nombre de $name';
  }

  @override
  String appVersionLabel(String version) {
    return 'Versión $version';
  }

  @override
  String appVersionWithCommit(String version, String commit) {
    return 'Versión $version, commit $commit';
  }
}
