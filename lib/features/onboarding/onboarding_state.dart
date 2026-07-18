import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _seenKey = 'onboarding_seen_v1';

/// Whether onboarding has already been completed on this device. Resolved
/// once at startup in main() and provided via override, so the router can
/// pick the initial route synchronously. Onboarding never re-blocks the
/// app (SPEC.md §3.1); the tour stays replayable from the rules screen.
final onboardingSeenProvider = Provider<bool>((ref) => false);

Future<bool> loadOnboardingSeen() async =>
    (await SharedPreferences.getInstance()).getBool(_seenKey) ?? false;

/// Fire-and-forget: persisting must never delay navigation.
void markOnboardingSeen() {
  SharedPreferences.getInstance().then((p) => p.setBool(_seenKey, true));
}
