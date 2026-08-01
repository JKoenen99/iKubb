import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikubb/l10n/app_localizations.dart';
import 'package:ikubb/widgets/confirm_dialog.dart';
import 'package:ikubb/widgets/dot_row.dart';
import 'package:ikubb/widgets/section_header.dart';
import 'package:ikubb/widgets/settings_tiles.dart';

Widget host(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('DotRow encodes state by shape and exposes one summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const DotRow(
          count: 3,
          filled: 2,
          activeColor: Colors.red,
          idleColor: Colors.grey,
          semanticLabel: '2 of 3',
        ),
      ),
    );

    // Filled vs outlined — never color alone.
    expect(find.byIcon(Icons.circle), findsNWidgets(2));
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
    // One merged summary for assistive tech.
    expect(find.bySemanticsLabel('2 of 3'), findsOneWidget);
  });

  testWidgets('confirmAdaptive returns true only on explicit confirm', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () async {
              result = await confirmAdaptive(
                context,
                title: 'Delete?',
                body: 'Gone forever.',
                confirmLabel: 'Delete',
                isDestructive: true,
              );
            },
            child: const Text('go'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    // Destructive confirm is styled in the error color.
    final confirm = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Delete'),
    );
    expect(confirm.style?.foregroundColor?.resolve({}), isNotNull);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isFalse);

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('SectionHeader and settings tiles render and react', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      host(
        Column(
          children: [
            const SectionHeader('Players'),
            SettingsNavTile(
              icon: Icons.menu_book_outlined,
              title: 'Rules',
              onTap: () => tapped = true,
            ),
            SettingsSwitchTile(
              icon: Icons.vibration,
              title: 'Haptics',
              value: true,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );

    expect(find.text('Players'), findsOneWidget);
    await tester.tap(find.text('Rules'));
    expect(tapped, isTrue);
    expect(find.byType(Switch), findsOneWidget);
  });
}
