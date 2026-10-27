import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/theme/ikubb_theme.dart';
import 'package:ikubb/widgets/adaptive_choice.dart';
import 'package:ikubb/widgets/segmented_control.dart';

void main() {
  Widget host(int selected, ValueChanged<int> onSelected) => MaterialApp(
    theme: IKubbTheme.light,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SegmentedControl<int>(
          options: const [
            ChoiceOption(value: 0, label: 'Table'),
            ChoiceOption(value: 1, label: 'Board', icon: Icons.view_column),
            ChoiceOption(value: 2, label: 'Timeline'),
          ],
          selected: selected,
          onSelected: onSelected,
        ),
      ),
    ),
  );

  testWidgets('tapping a segment selects it; the active one is inert', (
    tester,
  ) async {
    final picked = <int>[];
    await tester.pumpWidget(host(0, picked.add));
    await tester.tap(find.text('Timeline'));
    await tester.tap(find.text('Table'));
    expect(picked, [2]);
  });

  testWidgets('segments are 48pt, equal width, with radio-group semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(host(1, (_) {}));
    expect(tester.getSize(find.byType(SegmentedControl<int>)).height, 48);
    // Each segment's tap area is the full track height.
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Board'),
                  matching: find.byType(InkWell),
                )
                .first,
          )
          .height,
      48,
    );
    final widths = {
      for (final t in ['Table', 'Board', 'Timeline'])
        tester
            .getSize(
              find
                  .ancestor(of: find.text(t), matching: find.byType(InkWell))
                  .first,
            )
            .width
            .round(),
    };
    expect(widths.length, 1, reason: 'equal segment widths');
    expect(
      tester.getSemantics(find.text('Board')),
      matchesSemantics(
        label: 'Board',
        isButton: true,
        isInMutuallyExclusiveGroup: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
        hasEnabledState: true,
        isEnabled: true,
      ),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  testWidgets('arrow keys move the selection', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) =>
            host(selected, (v) => setState(() => selected = v)),
      ),
    );
    // Focus the first segment, then step right twice and left once.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(selected, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(selected, 2, reason: 'stops at the last segment');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(selected, 1);
  });
}
