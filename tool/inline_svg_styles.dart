// Rewrites SVGs exported from Illustrator so flutter_svg draws them in
// colour: flutter_svg ignores <style> blocks, so every `class="cls-N"` is
// replaced by the `fill` its CSS rule sets and the <style> block is removed.
//
// Usage: dart tool/inline_svg_styles.dart assets/character/<file>.svg ...
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart tool/inline_svg_styles.dart <file.svg> ...');
    exit(64);
  }
  for (final path in args) {
    final file = File(path);
    file.writeAsStringSync(inlineStyles(file.readAsStringSync()));
    stdout.writeln('Inlined styles in $path');
  }
}

String inlineStyles(String svg) {
  final fills = {
    for (final m in RegExp(
      r'\.([\w-]+)\s*\{\s*fill\s*:\s*([^;}\s]+)\s*;?\s*\}',
    ).allMatches(svg))
      m[1]!: m[2]!,
  };
  final unknown = <String>{};
  var out = svg.replaceAllMapped(RegExp(r'class="([\w-]+)"'), (m) {
    final fill = fills[m[1]];
    if (fill == null) {
      unknown.add(m[1]!);
      return m[0]!;
    }
    return 'fill="$fill"';
  });
  if (unknown.isNotEmpty) {
    throw FormatException('No fill rule for classes: ${unknown.join(', ')}');
  }
  out = out.replaceAll(RegExp(r'\s*<style>[\s\S]*?</style>'), '');
  out = out.replaceAll(RegExp(r'\s*<defs>\s*</defs>'), '');
  // Illustrator's layer name, not a useful accessible title.
  out = out.replaceAll(RegExp(r'\s*<title>[^<]*</title>'), '');
  return out;
}
