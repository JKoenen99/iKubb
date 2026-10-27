import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaato/app.dart';
import 'package:kaato/features/onboarding/onboarding_state.dart';
import 'package:kaato/theme/glass.dart';
import 'package:kaato/theme/palette.dart';
import 'package:kaato/widgets/kaato_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_utils.dart';

/// Liquid Glass is an iOS idiom: these tests pin the platform to iOS and
/// check the glass layer appears where the HIG puts it (navigation and
/// controls), stays accessible, and falls back to opaque chrome under
/// Increase Contrast — while Android keeps its Material look.
Future<void> pumpHome(WidgetTester tester, {bool highContrast = false}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [onboardingSeenProvider.overrideWithValue(true)],
      child: MediaQuery(
        data: MediaQueryData(highContrast: highContrast),
        child: const KaatoApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> checkGuidelines(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  handle.dispose();
}

/// Pins the platform for one test body; the framework checks that the
/// override is cleared before the body returns.
Future<void> onPlatform(
  TargetPlatform platform,
  Future<void> Function() body,
) async {
  debugDefaultTargetPlatformOverride = platform;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'iOS: the game bar floats its buttons in glass over a '
    'transparent bar and the actions sit on a glass toolbar',
    (tester) => onPlatform(TargetPlatform.iOS, () async {
      await pumpHome(tester);
      await tester.tap(find.text('Quick start'));
      await tester.pumpAndSettle();

      // Glass = backdrop blur: leading disc, actions capsule, bottom bar.
      expect(find.byType(BackdropFilter), findsAtLeastNWidgets(3));
      expect(find.byType(GlassToolbar), findsOneWidget);
      final bar = tester.widget<AppBar>(
        find.descendant(
          of: find.byType(KaatoAppBar),
          matching: find.byType(AppBar),
        ),
      );
      expect(
        Theme.of(tester.element(find.byType(AppBar)))
            .appBarTheme
            .backgroundColor,
        Colors.transparent,
      );
      expect(bar.actions, isNotEmpty);
      // Content extends beneath the bar.
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);
      expect(scaffold.extendBodyBehindAppBar, isTrue);
      await checkGuidelines(tester);
    }),
  );

  testWidgets(
    'iOS: controls are capsules and the rules sheet is an inset '
    'glass sheet with its own grabber',
    (tester) => onPlatform(TargetPlatform.iOS, () async {
      await pumpHome(tester);
      await tester.tap(find.text('Quick start'));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Miss'),
      );
      final shape = button
          .defaultStyleOf(
            tester.element(find.widgetWithText(FilledButton, 'Miss')),
          )
          .shape
          ?.resolve({});
      final themed = Theme.of(tester.element(find.byType(Scaffold).last))
          .filledButtonTheme
          .style
          ?.shape
          ?.resolve({});
      expect(themed ?? shape, isA<StadiumBorder>());

      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pumpAndSettle();
      expect(find.text('Scoring'), findsOneWidget);
      // The sheet body is glass; the Material drag handle is replaced.
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(KaatoGlass),
        ),
        findsOneWidget,
      );
      await checkGuidelines(tester);
    }),
  );

  testWidgets(
    'iOS light theme: the Home settings glyph stays light on clear glass',
    (tester) => onPlatform(TargetPlatform.iOS, () async {
      await pumpHome(tester);
      final glyph = tester.renderObject<RenderParagraph>(
        find
            .descendant(
              of: find.byIcon(Icons.settings_outlined),
              matching: find.byType(RichText),
            )
            .first,
      );
      expect(glyph.text.style!.color, KaatoPalette.birchLight);
    }),
  );

  testWidgets(
    'iOS: settings scrolls beneath the bar and stays accessible',
    (tester) => onPlatform(TargetPlatform.iOS, () async {
      await pumpHome(tester);
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      final list = tester.widget<ListView>(find.byType(ListView));
      final padding = list.padding!.resolve(TextDirection.ltr);
      // Starts below the (transparent) bar instead of under it.
      expect(padding.top, greaterThanOrEqualTo(kToolbarHeight));
      await checkGuidelines(tester);
    }),
  );

  testWidgets(
    'iOS + Increase Contrast: glass falls back to opaque chrome',
    (tester) => onPlatform(TargetPlatform.iOS, () async {
      await pumpHome(tester, highContrast: true);
      await tester.tap(find.text('Quick start'));
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
      // The chrome is still there, just solid.
      expect(find.byType(GlassToolbar), findsOneWidget);
      expect(find.byType(KaatoGlass), findsAtLeastNWidgets(2));
      await checkGuidelines(tester);
    }),
  );

  testWidgets(
    'iOS: setup, tour and win overlay keep their guidelines',
    (tester) => onPlatform(TargetPlatform.iOS, () async {
      await pumpHome(tester);
      await tester.tap(find.text('New game'));
      await tester.pumpAndSettle();
      await addPlayers(tester, ['Anna', 'Björn']);
      await checkGuidelines(tester);
      await tester.tapVisible(find.text('Start game'));
      await tester.pumpAndSettle();
      await checkGuidelines(tester);
    }),
  );

  testWidgets(
    'Android keeps Material: no glass, opaque bar, rounded '
    'rectangles',
    (tester) => onPlatform(TargetPlatform.android, () async {
      await pumpHome(tester);
      await tester.tap(find.text('Quick start'));
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
      expect(find.byType(GlassToolbar), findsNothing);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);
      expect(scaffold.extendBodyBehindAppBar, isFalse);
      final themed = Theme.of(tester.element(find.byType(Scaffold).last))
          .filledButtonTheme
          .style
          ?.shape
          ?.resolve({});
      expect(themed, isA<RoundedRectangleBorder>());
    }),
  );
}
