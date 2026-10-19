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
  String get tagline => 'El marcador de kubb';

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
  String get modeKubb => 'Kubb';

  @override
  String get matchLabel => 'Partido';

  @override
  String get bestOfSingle => 'Una partida';

  @override
  String get bestOfThree => 'Al mejor de 3';

  @override
  String get turnClockLabel => 'Reloj de turno';

  @override
  String get offLabel => 'Apagado';

  @override
  String get kingLabel => 'El rey';

  @override
  String get kingWarningTitle => '¿Derribar el rey?';

  @override
  String get kingWarningBody =>
      'Aún no ha caído todo — golpear el rey ahora pierde la partida.';

  @override
  String get advantageLine => 'Línea de ventaja';

  @override
  String get throwInTitle =>
      'Lanza los kubbs derribados a la mitad de los atacantes.';

  @override
  String get outTwice => 'Kubbs de castigo (dos veces fuera)';

  @override
  String get done => 'Hecho';

  @override
  String get nextGameLabel => 'Siguiente partida';

  @override
  String earlyKingBanner(String name) {
    return '¡$name derribó el rey demasiado pronto!';
  }

  @override
  String get catKubbSetup => 'Preparación y equipos';

  @override
  String get catKubbBatons => 'Bastones de lanzamiento';

  @override
  String get catKubbFieldKubbs => 'Kubbs de campo';

  @override
  String get catKubbKing => 'El rey';

  @override
  String get ruleKubbFieldTitle => 'El campo';

  @override
  String get ruleKubbFieldBody =>
      'Dos equipos se enfrentan en el campo. Cada uno coloca cinco kubbs en su línea de fondo; el rey queda solo en el centro.';

  @override
  String get ruleKubbFieldDetail =>
      'Los campos de torneo miden 5 × 8 metros. En el parque bastan dos chaquetas y buen ojo: mantén las mitades más o menos iguales.';

  @override
  String get ruleKubbTeamsTitle => 'De uno a seis por equipo';

  @override
  String get ruleKubbTeamsBody =>
      'El kubb es un juego de equipo: de uno a seis jugadores por equipo. Los compañeros se reparten los seis bastones y lanzan por turnos.';

  @override
  String get ruleKubbBatonsTitle => 'Seis bastones por turno';

  @override
  String get ruleKubbBatonsBody =>
      'El equipo atacante lanza seis bastones contra los kubbs rivales, por debajo del hombro y girando de punta a punta.';

  @override
  String get ruleKubbBatonsDetail =>
      'Nada de lanzamientos en helicóptero: el bastón debe girar en vertical, nunca de lado. Los kubbs derribados quedan en el suelo hasta acabar el turno.';

  @override
  String get ruleKubbThrowInTitle => 'Los kubbs caídos vuelven';

  @override
  String get ruleKubbThrowInBody =>
      'Tras los bastones, los defensores lanzan cada kubb derribado a la mitad de los atacantes. Donde cae, el kubb se levanta como kubb de campo.';

  @override
  String get ruleKubbThrowInDetail =>
      'Los defensores eligen dónde apuntar: los kubbs agrupados son mucho más fáciles de derribar con un solo bastón.';

  @override
  String get ruleKubbFieldFirstTitle => 'Primero los kubbs de campo';

  @override
  String get ruleKubbFieldFirstBody =>
      'Los atacantes deben derribar todos los kubbs de campo en pie antes de poder golpear un kubb de fondo. Un kubb de fondo derribado antes de tiempo se vuelve a levantar.';

  @override
  String get ruleKubbPenaltyTitle => 'Dos veces fuera = castigo';

  @override
  String get ruleKubbPenaltyBody =>
      'Un kubb lanzado fuera del campo dos veces se convierte en kubb de castigo: el otro equipo lo coloca donde quiera en su mitad, incluso justo al lado del rey.';

  @override
  String get ruleKubbAdvantageTitle => 'La línea de ventaja';

  @override
  String get ruleKubbAdvantageBody =>
      'Si los rivales dejan kubbs de campo en pie en vuestra mitad, vuestro equipo puede lanzar los bastones desde la altura del kubb más cercano al rey.';

  @override
  String get ruleKubbKingTitle => 'El rey decide';

  @override
  String get ruleKubbKingBody =>
      'Solo cuando todos los kubbs de la mitad defensora estén caídos puedes apuntar al rey. Derríbalo y la partida es vuestra.';

  @override
  String get ruleKubbEarlyKingTitle => 'No antes de que caiga la línea';

  @override
  String get ruleKubbEarlyKingBody =>
      'Derriba al rey antes de que todo lo demás haya caído —aunque sea sin querer— y tu equipo pierde la partida al instante.';

  @override
  String get ruleKubbMatchTitle => 'Al mejor de tres';

  @override
  String get ruleKubbMatchBody =>
      'En los torneos, un encuentro se juega al mejor de tres partidas. Los equipos se alternan para abrir cada partida.';

  @override
  String get ruleKubbMatchDetail =>
      'Con el reloj de turno activado, el equipo tiene un tiempo fijo para sus seis bastones. El reloj es orientativo: la app nunca bloquea un lanzamiento.';

  @override
  String get tourModePickTitle => '¿A qué juego jugáis?';

  @override
  String get tourModePickBody =>
      'Ambos están en esta app. Elige uno para aprender: puedes cambiar cuando quieras.';

  @override
  String get tourModeNumberDesc =>
      'Doce bolos numerados. Carrera hasta 50 exactos.';

  @override
  String get tourModeKubbDesc =>
      'Dos equipos, cinco kubbs cada uno — y el rey.';

  @override
  String get statKingsFelled => 'Reyes derribados';

  @override
  String get statKubbsPerBaton => 'Kubbs por bastón';

  @override
  String get statAdvantageTurns => 'Turnos con ventaja';

  @override
  String get statEarlyKings => 'Reyes prematuros';

  @override
  String get filterAll => 'Todo';

  @override
  String get closeLabel => 'Cerrar';

  @override
  String get increaseLabel => 'Aumentar';

  @override
  String get decreaseLabel => 'Reducir';

  @override
  String kubbStandingSemantics(int number) {
    return 'Kubb $number, en pie';
  }

  @override
  String kubbSelectedSemantics(int number) {
    return 'Kubb $number, marcado como derribado';
  }

  @override
  String get kingSafeSemantics => 'El rey: derríbalo para ganar';

  @override
  String get kingRiskySemantics => 'El rey: golpearlo ahora pierde la partida';

  @override
  String batonsLeftSemantics(int remaining, int total) {
    return 'Quedan $remaining de $total bastones';
  }

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
  String get newMatchConfirmTitle => '¿Empezar un nuevo encuentro?';

  @override
  String get newMatchConfirmBody => 'Perderás el encuentro en curso.';

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
  String matchScore(int a, int b) {
    return '$a – $b';
  }

  @override
  String get deleteGameConfirmBody =>
      'Esta partida se eliminará de tu historial.';

  @override
  String get newMatch => 'Nuevo encuentro';

  @override
  String playerN(int n) {
    return 'Jugador $n';
  }

  @override
  String secondsShort(int seconds) {
    return '$seconds s';
  }

  @override
  String removePlayer(String name) {
    return 'Quitar a $name';
  }

  @override
  String get showDetails => 'Más detalles';

  @override
  String get toppleKing => 'Derribar al rey';

  @override
  String turnClockSemantics(int seconds) {
    return 'Quedan $seconds segundos en el reloj de turno';
  }

  @override
  String baselineStandingSemantics(int count) {
    return '$count kubbs de línea de fondo en pie';
  }

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
  String get feedbackPromptGameTitle => '¿Qué tal ha ido anotar con iKubb?';

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
}
