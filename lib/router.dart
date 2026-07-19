import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/game/game_screen.dart';
import 'features/game/scoreboard_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/onboarding_state.dart';
import 'features/onboarding/tour_screen.dart';
import 'features/rules/rules_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/setup/setup_screen.dart';
import 'features/stats/stats_screen.dart';

/// App routes, scoped to the ProviderScope so each app instance (and each
/// widget test) gets a fresh navigation state. First launch opens on the
/// onboarding fork; afterwards the app opens on Home — or straight back
/// into an interrupted game (SPEC.md §3.5 resume).
String _initialLocation(Ref ref) =>
    ref.watch(onboardingSeenProvider) ? '/' : '/onboarding';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: _initialLocation(ref),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/tour', builder: (context, state) => const TourScreen()),
      GoRoute(path: '/setup', builder: (context, state) => const SetupScreen()),
      GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
      GoRoute(
        path: '/scoreboard',
        builder: (context, state) => const ScoreboardScreen(),
      ),
      GoRoute(path: '/rules', builder: (context, state) => const RulesScreen()),
      GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  ),
);
