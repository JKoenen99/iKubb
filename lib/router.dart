import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/game/game_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/rules/rules_screen.dart';
import 'features/setup/setup_screen.dart';
import 'features/stats/stats_screen.dart';

/// App routes, scoped to the ProviderScope so each app instance (and each
/// widget test) gets a fresh navigation state. Onboarding is the initial
/// route for now; once first-launch state is persisted it will redirect to
/// home on subsequent launches.
final routerProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/setup', builder: (context, state) => const SetupScreen()),
    GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
    GoRoute(path: '/rules', builder: (context, state) => const RulesScreen()),
    GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
  ],
));
