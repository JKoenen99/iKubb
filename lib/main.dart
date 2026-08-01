import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/onboarding/onboarding_state.dart';
import 'features/stats/game_records_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboardingSeen = await loadOnboardingSeen();
  // Restore an interrupted game exactly, undo history included (§3.5).
  // Corrupt JSON is already absorbed by the repository; this guard covers
  // platform-storage failures too — a fresh start beats a bricked launch.
  ActiveRecord? restored;
  try {
    restored = await GameRecordsRepository().loadActive();
  } on Object {
    restored = null;
  }
  runApp(
    ProviderScope(
      overrides: [
        onboardingSeenProvider.overrideWithValue(onboardingSeen),
        restoredGameProvider.overrideWithValue(restored),
      ],
      child: const IKubbApp(),
    ),
  );
}
