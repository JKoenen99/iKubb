import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// flutter_svg ignores <style> blocks: a raw Illustrator export would draw
/// all black. `dart tool/inline_svg_styles.dart <file>` fixes an export.
void main() {
  final svgs = Directory('assets/character')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.svg'))
      .toList();

  test('character folder has SVGs', () => expect(svgs, isNotEmpty));

  for (final svg in svgs) {
    test('${svg.path} has inline fills, no <style> or classes', () {
      final text = svg.readAsStringSync();
      expect(text, isNot(contains('<style')));
      expect(text, isNot(contains('class=')));
    });
  }
}
