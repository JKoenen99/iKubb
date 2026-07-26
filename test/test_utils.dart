import 'package:flutter_test/flutter_test.dart';

extension TapVisible on WidgetTester {
  /// Scrolls [finder] into view before tapping — the setup screen's list
  /// grew past the default test viewport when the mode picker landed.
  Future<void> tapVisible(Finder finder) async {
    await ensureVisible(finder);
    await pumpAndSettle();
    await tap(finder);
  }
}
