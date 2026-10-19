import 'package:flutter/foundation.dart';

import 'device_info_stub.dart' if (dart.library.io) 'device_info_io.dart';

/// The non-identifying platform facts stored with a feedback event: enough
/// to split ratings by OS and version, nothing that singles out a device.
abstract final class DeviceInfo {
  static String platform() =>
      kIsWeb ? 'web' : defaultTargetPlatform.name.toLowerCase();

  static String osVersion() => kIsWeb ? '' : operatingSystemVersion();
}
