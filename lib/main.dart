import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/onboarding/onboarding_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboardingSeen = await loadOnboardingSeen();
  runApp(ProviderScope(
    overrides: [onboardingSeenProvider.overrideWithValue(onboardingSeen)],
    child: const IKubbApp(),
  ));
}
