import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The commit a build was made from, passed in at build time with
/// `--dart-define=GIT_SHA=$(git rev-parse --short HEAD)` (tool/ios.sh and
/// the web workflow do this). Empty for builds made without it.
const gitSha = String.fromEnvironment('GIT_SHA');

/// What the installed build is: the pubspec version and build number,
/// plus the commit when known. Shown in Settings so a tester can tell
/// which code is on a device.
class AppVersion {
  AppVersion({
    required this.version,
    required this.buildNumber,
    String commit = gitSha,
  }) : commit = shortCommit(commit);

  final String version;
  final String buildNumber;

  /// Seven characters, like `git log --oneline`; a trailing "+" (local,
  /// uncommitted changes) is kept.
  final String commit;

  static String shortCommit(String sha) {
    final dirty = sha.endsWith('+');
    final hash = dirty ? sha.substring(0, sha.length - 1) : sha;
    final short = hash.length > 7 ? hash.substring(0, 7) : hash;
    return dirty ? '$short+' : short;
  }

  /// "0.2.0 (2)" — the form App Store Connect and TestFlight use too.
  String get short => buildNumber.isEmpty ? version : '$version ($buildNumber)';
}

/// Read once per launch. Tests override this; a missing platform plugin
/// leaves the footer empty instead of failing the screen.
final appVersionProvider = FutureProvider<AppVersion>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return AppVersion(version: info.version, buildNumber: info.buildNumber);
});
