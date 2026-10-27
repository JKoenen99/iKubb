import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/glass.dart';
import '../../theme/palette.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/adaptive_choice.dart';
import '../../widgets/celebration.dart';
import '../../widgets/confetti.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/dot_row.dart';
import '../../widgets/form_cards.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/kaato_app_bar.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/section_header.dart';
import '../../widgets/segmented_control.dart';
import '../../widgets/settings_tiles.dart';
import '../../widgets/share_card.dart';
import '../../widgets/side_card.dart';
import '../../widgets/viking_mascot.dart';
import '../../widgets/wood_grain.dart';
import '../feedback/star_rating.dart';
import '../game/pin_diagram.dart';
import '../settings/settings_controller.dart';
import 'story.dart';

/// The living design system, documented the way a Storybook is: every
/// token with its value, every component with a summary, its props, its
/// variants on a neutral canvas and its accessibility contract. Renders
/// in both themes (switch at the top) and can preview the iOS chrome.
/// Review surface only: reachable via /designsystem and Settings.
class DesignSystemScreen extends ConsumerStatefulWidget {
  const DesignSystemScreen({super.key});

  @override
  ConsumerState<DesignSystemScreen> createState() => _DesignSystemScreenState();
}

/// Catalog sections, in page order; each gets an anchor for the jump nav.
enum _Section {
  color('Color'),
  type('Type'),
  shape('Space & shape'),
  motion('Motion'),
  chrome('Chrome & glass'),
  buttons('Buttons'),
  inputs('Inputs'),
  cards('Cards & tiles'),
  players('Players & teams'),
  status('Status & numbers'),
  overlays('Overlays & dialogs'),
  pieces('Game pieces'),
  illustration('Illustration'),
  behaviours('Behaviours');

  const _Section(this.title);

  final String title;
}

class _DesignSystemScreenState extends ConsumerState<DesignSystemScreen> {
  final _anchors = {for (final s in _Section.values) s: GlobalKey()};

  var _rolling = 42;
  var _motionOn = false;
  var _stepper = 50;
  var _toggle = true;
  var _choice = 0;
  var _segment = 0;
  var _segment3 = 0;
  var _select = '';
  var _stars = 0;
  var _iosChrome = false;
  var _confettiRun = 0;

  Future<void> _jumpTo(_Section section) async {
    final target = _anchors[section]!.currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: KaatoMotion.resolve(context, KaatoMotion.entrance),
      curve: KaatoMotion.enter,
    );
  }

  Widget _anchor(_Section section) => Padding(
    key: _anchors[section],
    padding: const EdgeInsets.only(
      top: KaatoSpacing.xl,
      bottom: KaatoSpacing.md,
    ),
    child: SectionHeader(section.title),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // The glass widgets key off Theme.platform, so one override previews
    // the iOS chrome on any host. Control shapes come from the build
    // target and are not affected.
    final chromeTheme = _iosChrome
        ? theme.copyWith(platform: TargetPlatform.iOS)
        : theme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.designSystemLabel),
        leading: homeLeading(context),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: KaatoLayout.maxPanel),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(KaatoSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _intro(scheme),
                ..._foundations(scheme),
                ..._chrome(chromeTheme, scheme),
                ..._buttons(l10n, scheme),
                ..._inputs(l10n),
                ..._cards(l10n),
                ..._players(l10n),
                ..._status(scheme),
                ..._overlays(l10n, scheme),
                ..._pieces(),
                ..._illustration(l10n, scheme),
                ..._behaviours(scheme),
                const SizedBox(height: KaatoSpacing.huge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- intro

  Widget _intro(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scandinavian modern, Viking soul. Birch surfaces, forest '
          'primaries, a four-tone wood ramp for accents, ink for text. '
          'Every component below is the production widget, rendered live '
          'in the current theme, with its props and states.',
          style: KaatoType.reading,
        ),
        const SizedBox(height: KaatoSpacing.md),
        AdaptiveChoice<ThemeMode>(
          options: const [
            ChoiceOption(value: ThemeMode.system, label: 'System'),
            ChoiceOption(value: ThemeMode.light, label: 'Light'),
            ChoiceOption(value: ThemeMode.dark, label: 'Dark'),
          ],
          selected: ref.watch(themeModeProvider),
          onSelected: ref.read(themeModeProvider.notifier).set,
        ),
        const SizedBox(height: KaatoSpacing.sm),
        SwitchCard(
          title: 'Preview iOS chrome',
          subtitle:
              'Renders the Liquid Glass bars, groups and sheets in '
              'the Chrome section as iOS draws them.',
          value: _iosChrome,
          onChanged: (v) => setState(() => _iosChrome = v),
        ),
        Wrap(
          spacing: KaatoSpacing.sm,
          runSpacing: KaatoSpacing.xs,
          children: [
            for (final s in _Section.values)
              ActionChip(label: Text(s.title), onPressed: () => _jumpTo(s)),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------- foundations

  List<Widget> _foundations(ColorScheme scheme) {
    Widget bar(double v) => Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: v * 4,
        height: 12,
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(KaatoRadius.xs),
        ),
      ),
    );
    Widget corner(double r) => Container(
      width: 64,
      height: 36,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(r.clamp(0, 18)),
      ),
    );
    Widget alpha(double a) => Container(
      width: 64,
      height: 20,
      color: scheme.primary.withValues(alpha: a),
    );
    Widget line(double w) => Container(height: w, color: scheme.outline);
    Widget dot(double d) => Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: scheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
    return [
      _anchor(_Section.color),
      const Story(
        name: 'KaatoPalette',
        source: 'theme/palette.dart',
        summary:
            'Named colors only; no screen carries a hex. Surfaces are birch '
            'in the light theme and charcoal-wood in the dark one, the brand '
            'is forest green, accents come from one wood ramp, and the '
            'identity hues are reserved for players and teams.',
        usedIn:
            'everywhere via ColorScheme; directly for wood, identity and '
            'signal colors',
      ),
      const _SwatchGrid(
        title: 'Neutrals (surfaces and text)',
        entries: [
          ('birchLight', KaatoPalette.birchLight),
          ('birch', KaatoPalette.birch),
          ('charcoalWood', KaatoPalette.charcoalWood),
          ('nightSurface', KaatoPalette.nightSurface),
          ('ink', KaatoPalette.ink),
        ],
      ),
      const _SwatchGrid(
        title: 'Brand greens',
        entries: [
          ('forest', KaatoPalette.forest),
          ('forestDeep', KaatoPalette.forestDeep),
          ('pine', KaatoPalette.pine),
          ('sage', KaatoPalette.sage),
        ],
      ),
      const _SwatchGrid(
        title: 'Wood ramp (one material, light to dark)',
        entries: [
          ('oakLight · dark accent', KaatoPalette.oakLight),
          ('oak · light fills, pins', KaatoPalette.oak),
          ('walnut · light accent, Team A', KaatoPalette.walnut),
          ('bark · edges, knots', KaatoPalette.bark),
        ],
      ),
      const _WoodRampStrip(),
      const _SwatchGrid(
        title: 'Lines (input and control borders, 3:1 on their card)',
        entries: [
          ('lineLight', KaatoPalette.lineLight),
          ('lineSoftLight', KaatoPalette.lineSoftLight),
          ('lineDark', KaatoPalette.lineDark),
          ('lineSoftDark', KaatoPalette.lineSoftDark),
        ],
      ),
      const _SwatchGrid(
        title: 'Signals',
        entries: [
          ('amber · overshoot', KaatoPalette.amber),
          ('berry · danger (light)', KaatoPalette.berry),
          ('berryLight · danger (dark)', KaatoPalette.berryLight),
        ],
      ),
      const _SwatchGrid(
        title: 'Player identity (never a brand green)',
        entries: [
          ('oak', KaatoPalette.oak),
          ('fjord', KaatoPalette.fjord),
          ('berry', KaatoPalette.berry),
          ('amber', KaatoPalette.amber),
          ('plum', KaatoPalette.plum),
          ('copper', KaatoPalette.copper),
          ('slate', KaatoPalette.slate),
          ('indigo', KaatoPalette.indigo),
        ],
      ),
      _anchor(_Section.type),
      const Story(
        name: 'KaatoType',
        source: 'theme/typography.dart',
        summary:
            'Baloo 2 for the wordmark, headings and scores (tabular-lining '
            'numerals so digits never jiggle); the platform sans for body '
            'text. One step scale from chip to scoreboard.',
      ),
      for (final (name, size) in const [
        ('stepChip', KaatoType.stepChip),
        ('stepLabel', KaatoType.stepLabel),
        ('stepBody', KaatoType.stepBody),
        ('stepTitle', KaatoType.stepTitle),
        ('stepHeadline', KaatoType.stepHeadline),
        ('stepScoreCard', KaatoType.stepScoreCard),
        ('stepScoreLg', KaatoType.stepScoreLg),
        ('stepHero', KaatoType.stepHero),
        ('stepDisplay', KaatoType.stepDisplay),
        ('stepWordmark', KaatoType.stepWordmark),
      ])
        TokenRow(
          name: name,
          value: '${size.toInt()} px',
          sample: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text('Kubb 21', style: KaatoType.heading(size: size)),
          ),
        ),
      const SizedBox(height: KaatoSpacing.sm),
      for (final (name, style, use) in const [
        ('emphasis', KaatoType.emphasis, 'side and player names'),
        ('strong', KaatoType.strong, 'card titles in lists'),
        ('reading', KaatoType.reading, 'long-form tour and rule text'),
        ('statValue', KaatoType.statValue, 'stat and stepper values'),
        ('cardTitle', KaatoType.cardTitle, 'player card names'),
        ('caption', KaatoType.caption, 'dates, footnotes, hints'),
      ])
        TokenRow(
          name: name,
          value: '',
          sample: Text(use, style: style),
        ),
      _anchor(_Section.shape),
      const Story(
        name: 'KaatoSpacing · KaatoRadius · KaatoBorder · KaatoIconSize',
        source: 'theme/tokens.dart',
        summary:
            'A 4-point spacing scale, five corner radii plus the glass and '
            'sheet radii for iOS, three line weights and the icon sizes. No '
            'screen carries a raw spacing, radius or size literal.',
      ),
      for (final (name, v) in const [
        ('xxs', KaatoSpacing.xxs),
        ('xs', KaatoSpacing.xs),
        ('sm', KaatoSpacing.sm),
        ('md', KaatoSpacing.md),
        ('lg', KaatoSpacing.lg),
        ('xl', KaatoSpacing.xl),
        ('xxl', KaatoSpacing.xxl),
        ('huge', KaatoSpacing.huge),
      ])
        TokenRow(name: 'spacing.$name', value: '${v.toInt()}', sample: bar(v)),
      const SizedBox(height: KaatoSpacing.sm),
      for (final (name, r) in const [
        ('xs', KaatoRadius.xs),
        ('sm', KaatoRadius.sm),
        ('chip', KaatoRadius.chip),
        ('md', KaatoRadius.md),
        ('lg', KaatoRadius.lg),
        ('xl', KaatoRadius.xl),
        ('glass', KaatoRadius.glass),
        ('sheet', KaatoRadius.sheet),
      ])
        TokenRow(
          name: 'radius.$name',
          value: '${r.toInt()}',
          sample: Align(alignment: Alignment.centerLeft, child: corner(r)),
        ),
      const SizedBox(height: KaatoSpacing.sm),
      for (final (name, w, use) in const [
        ('hairline', KaatoBorder.hairline, 'input at rest, chips'),
        ('line', KaatoBorder.line, 'focus ring, pins, pills'),
        ('focus', KaatoBorder.focus, 'keyboard focus'),
        ('frame', KaatoBorder.frame, 'share card frame'),
      ])
        TokenRow(
          name: 'border.$name',
          value: '$w',
          sample: Row(
            children: [
              Expanded(child: line(w)),
              const SizedBox(width: KaatoSpacing.md),
              Text(use, style: KaatoType.caption),
            ],
          ),
        ),
      const SizedBox(height: KaatoSpacing.sm),
      for (final (name, d) in const [
        ('dot', KaatoIconSize.dot),
        ('sm', KaatoIconSize.sm),
        ('md', KaatoIconSize.md),
        ('lg', KaatoIconSize.lg),
        ('field', KaatoIconSize.field),
        ('xl', KaatoIconSize.xl),
        ('display', KaatoIconSize.display),
      ])
        TokenRow(name: 'icon.$name', value: '${d.toInt()}', sample: dot(d)),
      const SizedBox(height: KaatoSpacing.sm),
      for (final (name, a, use) in const [
        ('grain', KaatoAlpha.grain, 'wood grain on brand surfaces'),
        ('choiceTint', KaatoAlpha.choiceTint, 'selected choice card wash'),
        ('dotIdle', KaatoAlpha.dotIdle, 'idle dots, chip lines'),
        ('activeTint', KaatoAlpha.activeTint, 'team card tint'),
        ('faded', KaatoAlpha.faded, 'secondary text'),
        ('glassTint', KaatoAlpha.glassTint, 'regular glass'),
        ('scrim', KaatoAlpha.scrim, 'overlay scrim'),
      ])
        TokenRow(
          name: 'alpha.$name',
          value: '$a',
          sample: Row(
            children: [
              alpha(a),
              const SizedBox(width: KaatoSpacing.md),
              Text(use, style: KaatoType.caption),
            ],
          ),
        ),
      const SizedBox(height: KaatoSpacing.sm),
      for (final (name, w, use) in const [
        ('maxColumn', KaatoLayout.maxColumn, 'phone-first columns'),
        ('maxOverlay', KaatoLayout.maxOverlay, 'win overlay content'),
        ('maxContent', KaatoLayout.maxContent, 'readable text'),
        ('maxPanel', KaatoLayout.maxPanel, 'settings, this page'),
        ('maxWide', KaatoLayout.maxWide, 'two-column New game'),
      ])
        TokenRow(
          name: 'layout.$name',
          value: '${w.toInt()}',
          sample: Text(use, style: KaatoType.caption),
        ),
      TokenRow(
        name: 'tap.min',
        value: '${KaatoTap.min.toInt()}',
        sample: const Text(
          'HIG 44pt; Material targets pad to 48',
          style: KaatoType.caption,
        ),
      ),
      _anchor(_Section.motion),
      Story(
        name: 'KaatoMotion',
        source: 'theme/tokens.dart',
        summary:
            'Four durations (quick 200, base 250, entrance 300, gentle 350) '
            'and three curves. Every animation routes its duration through '
            'resolve(), which collapses it to zero under Reduce Motion, so '
            'state changes land first and motion is decoration.',
        props: const [
          Prop(
            'resolve',
            'Duration Function(context, d)',
            'zero when '
                'MediaQuery.disableAnimations is set',
          ),
          Prop('standard', 'Curve', 'easeOut: most transitions'),
          Prop('emphasized', 'Curve', 'easeOutBack: pins, selection'),
          Prop('enter', 'Curve', 'easeOutCubic: screen entrances'),
          Prop('glassBlur', 'double', 'backdrop blur radius (18)'),
        ],
        variants: [
          Variant(
            'base · emphasized',
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: () => setState(() => _motionOn = !_motionOn),
                  child: const Text('Play'),
                ),
                const SizedBox(width: KaatoSpacing.lg),
                AnimatedContainer(
                  duration: KaatoMotion.resolve(context, KaatoMotion.base),
                  curve: KaatoMotion.emphasized,
                  width: _motionOn ? 120 : 48,
                  height: 32,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(KaatoRadius.lg),
                  ),
                ),
              ],
            ),
          ),
        ],
        a11y: 'With Reduce Motion on, Play jumps straight to the end state.',
      ),
    ];
  }

  // --------------------------------------------------------------- chrome

  List<Widget> _chrome(ThemeData chromeTheme, ColorScheme scheme) {
    Widget wood(Widget child, {bool dark = false}) => SizedBox(
      height: 112,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: dark ? KaatoPalette.forestDeep : scheme.surface),
          WoodGrainBackground(
            color: dark
                ? KaatoPalette.oakLight
                : KaatoPalette.woodGrain(scheme.brightness),
            opacity: 0.14,
          ),
          Center(child: child),
        ],
      ),
    );
    return [
      _anchor(_Section.chrome),
      Theme(
        data: chromeTheme,
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Story(
                name: 'KaatoAppBar',
                source: 'widgets/kaato_app_bar.dart',
                summary:
                    'The app bar of every screen. On iOS it is transparent: '
                    'the leading button and the actions float in glass and '
                    'a scroll-edge fade keeps the title legible. Elsewhere '
                    'it is a plain Material bar.',
                usedIn: 'every screen; screens set extendBodyBehindAppBar',
                props: const [
                  Prop('title', 'Widget?', 'centered on iOS'),
                  Prop('leading', 'Widget?', 'usually homeLeading(context)'),
                  Prop('actions', 'List<Widget>', 'grouped in one GlassGroup'),
                  Prop(
                    'glassVariant',
                    'GlassVariant',
                    'clear over rich '
                        'media (Home), regular elsewhere',
                  ),
                ],
                variants: [
                  Variant(
                    'Default',
                    SizedBox(
                      height: kToolbarHeight,
                      child: KaatoAppBar(
                        title: const Text('New game'),
                        leading: BackButton(onPressed: () {}),
                        actions: [
                          IconButton(
                            tooltip: 'Help',
                            onPressed: () {},
                            icon: const Icon(Icons.help_outline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                a11y:
                    'Bar buttons keep tooltips as their labels; the title '
                    'is the screen heading for screen readers.',
              ),
              Story(
                name:
                    'KaatoGlass · GlassGroup · GlassToolbar · BottomActionBar',
                source: 'theme/glass.dart',
                summary:
                    'The Liquid Glass layer for navigation and controls, '
                    'never for content: a blurred, tinted surface with a '
                    'specular rim. GlassGroup gathers icon buttons in one '
                    'capsule, GlassToolbar floats a row of actions, '
                    'BottomActionBar is the toolbar on iOS and plain '
                    'padding elsewhere.',
                usedIn:
                    'app bars, the game action bar, the setup summary '
                    'bar, sheets',
                props: const [
                  Prop(
                    'variant',
                    'GlassVariant',
                    'regular (surface tint '
                        '72%) or clear (dims rich media 35%)',
                  ),
                  Prop('radius', 'double', 'KaatoGlass only; 26 by default'),
                  Prop('padding', 'EdgeInsets', 'inside the glass'),
                  Prop('shadow', 'bool', 'soft drop shadow (KaatoGlass)'),
                ],
                variants: [
                  Variant(
                    'GlassGroup · regular',
                    wood(
                      GlassGroup(
                        children: [
                          IconButton(
                            tooltip: 'Undo',
                            onPressed: () {},
                            icon: const Icon(Icons.undo),
                          ),
                          IconButton(
                            tooltip: 'Share',
                            onPressed: () {},
                            icon: const Icon(Icons.ios_share),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Variant(
                    'GlassToolbar · clear, over rich media',
                    wood(
                      dark: true,
                      GlassToolbar(
                        variant: GlassVariant.clear,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FilledButton.tonal(
                              onPressed: () {},
                              child: const Text('Miss'),
                            ),
                            const SizedBox(width: KaatoSpacing.sm),
                            FilledButton(
                              onPressed: () {},
                              child: const Text('Score'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    note:
                        'Tonal buttons turn monochrome glass; only the '
                        'primary action keeps its tint, trailing.',
                  ),
                  Variant(
                    'glassIconButton · clear',
                    wood(
                      dark: true,
                      glassIconButton(
                        context,
                        IconButton(
                          tooltip: 'Settings',
                          onPressed: () {},
                          icon: const Icon(Icons.settings_outlined),
                        ),
                      ),
                    ),
                  ),
                  Variant(
                    'glassSheet',
                    FilledButton.tonal(
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        builder: (context) => glassSheet(
                          context,
                          const Padding(
                            padding: EdgeInsets.all(KaatoSpacing.xl),
                            child: Text(
                              'An inset half sheet with its own grabber on '
                              'iOS; a plain bottom sheet elsewhere.',
                              style: KaatoType.reading,
                            ),
                          ),
                        ),
                      ),
                      child: const Text('Open sheet'),
                    ),
                  ),
                ],
                a11y:
                    'Under Increase Contrast the blur is replaced by an '
                    'opaque surface with a visible rim; text on glass stays '
                    'onSurface at AA.',
              ),
            ],
          ),
        ),
      ),
      Story(
        name: 'SectionHeader',
        source: 'widgets/section_header.dart',
        summary:
            'The one way to head a content section: a bold title, an '
            'optional small detail and an optional trailing action.',
        usedIn: 'setup sections, stats, settings, this page',
        props: const [
          Prop('text', 'String', 'the title'),
          Prop('detail', 'String?', 'small secondary text ("2 players")'),
          Prop(
            'trailing',
            'Widget?',
            'an action; title and detail give '
                'way to it with an ellipsis',
          ),
          Prop('padded', 'bool', 'vertical breathing room in lists'),
        ],
        variants: [
          const Variant('Plain', SectionHeader('Players')),
          const Variant(
            'With detail',
            SectionHeader('Players', detail: '2 players'),
          ),
          Variant(
            'With trailing action',
            SectionHeader(
              'House rules',
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Reset'),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  // -------------------------------------------------------------- buttons

  List<Widget> _buttons(AppLocalizations l10n, ColorScheme scheme) {
    return [
      _anchor(_Section.buttons),
      Story(
        name: 'FilledButton · OutlinedButton · TextButton · IconButton',
        source: 'theme/kaato_theme.dart (themed Material buttons)',
        summary:
            'Material buttons with the Kaato theme: 56pt filled primaries '
            '(primaryContainer: forest in light, night pine in dark), '
            '48pt outlined secondaries, capsules on iOS and 16pt corners '
            'elsewhere. One filled button per screen, trailing; tonal for '
            'the frequent in-game actions.',
        usedIn: 'every screen',
        props: const [
          Prop(
            'onPressed',
            'VoidCallback?',
            'null renders the disabled '
                'state',
          ),
          Prop(
            'icon',
            'Widget',
            '.icon constructors; iconAlignment: end '
                'for "next" actions',
          ),
        ],
        variants: [
          Variant(
            'Hierarchy',
            Wrap(
              spacing: KaatoSpacing.md,
              runSpacing: KaatoSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton(onPressed: () {}, child: const Text('Filled')),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Tonal'),
                ),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                TextButton(onPressed: () {}, child: const Text('Text')),
              ],
            ),
          ),
          Variant(
            'With icon · disabled',
            Wrap(
              spacing: KaatoSpacing.md,
              runSpacing: KaatoSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Start game'),
                ),
                const FilledButton(onPressed: null, child: Text('Disabled')),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shuffle, size: KaatoIconSize.sm),
                  label: const Text('Shuffle order'),
                ),
              ],
            ),
          ),
          Variant(
            'Icon buttons',
            Wrap(
              spacing: KaatoSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Remove',
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                ),
                IconButton.filledTonal(
                  tooltip: 'Increase',
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
                IconButton.filled(
                  tooltip: 'Confirm',
                  onPressed: () {},
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
            note:
                'Every icon button carries a tooltip: it is the '
                'accessible label.',
          ),
        ],
        a11y:
            'Minimum 48pt tap targets (materialTapTargetSize.padded); '
            'labels are verbs; disabled buttons stay readable at 3:1.',
      ),
      Story(
        name: 'OverlayFilledButton · OverlayOutlinedButton',
        source: 'widgets/celebration.dart',
        summary:
            'The two actions of a full-screen overlay (win, early king): '
            'birch on the forest scrim, one filled primary and one outlined '
            'secondary.',
        usedIn: 'win overlay, share dialog',
        props: const [
          Prop('onPressed', 'VoidCallback', 'required'),
          Prop('child', 'Widget', 'the label'),
          Prop('icon', 'Widget?', 'leading icon'),
        ],
        variants: [
          Variant(
            'On the overlay scrim',
            Wrap(
              spacing: KaatoSpacing.md,
              runSpacing: KaatoSpacing.md,
              children: [
                OverlayFilledButton(
                  onPressed: () {},
                  child: Text(l10n.rematch),
                ),
                OverlayOutlinedButton(
                  onPressed: () {},
                  child: const Text('Share'),
                ),
              ],
            ),
            background: KaatoPalette.forestDeep,
          ),
        ],
      ),
      Story(
        name: 'DashedAddButton',
        source: 'widgets/form_cards.dart',
        summary:
            'A full-width dashed outline button for "add one more": it '
            'reads as an empty slot rather than a primary action.',
        usedIn: 'New game, player list',
        props: const [
          Prop('label', 'String', 'with a leading plus'),
          Prop('onPressed', 'VoidCallback?', 'null disables'),
        ],
        variants: [
          Variant(
            'Default',
            DashedAddButton(label: l10n.addPlayer, onPressed: () {}),
          ),
        ],
      ),
    ];
  }

  // --------------------------------------------------------------- inputs

  List<Widget> _inputs(AppLocalizations l10n) {
    return [
      _anchor(_Section.inputs),
      Story(
        name: 'TextField (InputDecorationTheme)',
        source: 'theme/kaato_theme.dart',
        summary:
            'One recipe for every input: a quiet fill one step lighter '
            'than the card, a neutral 1.5pt line at rest, the primary color '
            'at 2pt on focus, the danger color on error and a soft line '
            'when disabled. Fields never rely on an underline alone.',
        usedIn:
            'player and team names, rules search, feedback comment, '
            'stepper value dialog',
        props: const [
          Prop('hintText', 'String', 'placeholder at faded onSurface'),
          Prop('prefixIcon / suffixIcon', 'Widget', 'search, clear'),
          Prop('errorText', 'String', 'switches to the error line'),
          Prop('isDense', 'bool', 'inline fields inside cards'),
        ],
        variants: [
          const Variant(
            'Empty · hint',
            TextField(decoration: InputDecoration(hintText: 'Player name')),
          ),
          Variant(
            'Filled · with icons',
            TextField(
              controller: TextEditingController(text: 'Elimination'),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.clear),
              ),
            ),
          ),
          Variant(
            'Error',
            TextField(
              controller: TextEditingController(text: '250'),
              decoration: const InputDecoration(
                errorText: 'Target must be 200 or less',
              ),
            ),
          ),
          const Variant(
            'Disabled',
            TextField(
              enabled: false,
              decoration: InputDecoration(hintText: 'Disabled'),
            ),
          ),
        ],
        a11y:
            'Line contrast 3:1 on its card (WCAG 1.4.11); focus is shown '
            'by weight and color, not color alone.',
      ),
      Story(
        name: 'SelectField<T>',
        source: 'widgets/form_cards.dart',
        summary:
            'A select that looks like every other input: the themed field '
            'with the current value and a chevron. Tapping opens a menu as '
            'wide as the field with a check on the current option.',
        usedIn: 'Settings, language',
        props: const [
          Prop('value', 'T', 'current option'),
          Prop('options', 'List<ChoiceOption<T>>', 'value, label, icon?'),
          Prop('onChanged', 'ValueChanged<T>', 'only fires on a change'),
          Prop('semanticLabel', 'String?', 'what the field is for'),
        ],
        variants: [
          Variant(
            'Default',
            SelectField<String>(
              value: _select,
              semanticLabel: 'Language',
              options: const [
                ChoiceOption(value: '', label: 'System'),
                ChoiceOption(value: 'nl', label: 'Nederlands'),
                ChoiceOption(value: 'sv', label: 'Svenska'),
              ],
              onChanged: (v) => setState(() => _select = v),
            ),
          ),
        ],
        a11y:
            'Announced as a button with the label and the current value; '
            'the menu items are the options.',
      ),
      Story(
        name: 'SegmentedControl<T>',
        source: 'widgets/segmented_control.dart',
        summary:
            'Two to four short, mutually exclusive options that switch a view '
            'or setting in place. Track-and-tile anatomy: a recessed track '
            'tinted from the text color, and a raised tile with a soft '
            'shadow that slides to the chosen segment. No outlines and no '
            'brand-colored fill; equal segment widths.',
        usedIn:
            'through AdaptiveChoice: Settings theme, New game mode, '
            'match and turn clock, rules panel mode, game input mode',
        props: const [
          Prop('options', 'List<ChoiceOption<T>>', 'value, label, icon?'),
          Prop('selected', 'T', 'exactly one'),
          Prop('onSelected', 'ValueChanged<T>', 'only fires on a change'),
        ],
        variants: [
          Variant(
            'Labels',
            SegmentedControl<int>(
              options: const [
                ChoiceOption(value: 0, label: 'System'),
                ChoiceOption(value: 1, label: 'Light'),
                ChoiceOption(value: 2, label: 'Dark'),
              ],
              selected: _segment3,
              onSelected: (v) => setState(() => _segment3 = v),
            ),
            note: 'Tap to see the tile slide (instant under Reduce Motion).',
          ),
          Variant(
            'Icon and label',
            SegmentedControl<int>(
              options: const [
                ChoiceOption(
                  value: 0,
                  icon: Icons.touch_app_outlined,
                  label: 'Tap pins',
                ),
                ChoiceOption(
                  value: 1,
                  icon: Icons.grid_view_rounded,
                  label: 'Number pad',
                ),
              ],
              selected: _segment,
              onSelected: (v) => setState(() => _segment = v),
            ),
          ),
          Variant(
            'On a card',
            FormCard(
              margin: EdgeInsets.zero,
              child: SegmentedControl<int>(
                options: const [
                  ChoiceOption(value: 0, label: 'Single game'),
                  ChoiceOption(value: 1, label: 'Best of three'),
                ],
                selected: _segment,
                onSelected: (v) => setState(() => _segment = v),
              ),
            ),
            note:
                'The track is a tint, so it recedes from a card as well as '
                'from the page.',
          ),
        ],
        a11y:
            'Each segment is a button in a mutually exclusive group with '
            'selected state; arrow keys move the selection. The active state '
            'is shown three ways: the raised tile, a semibold label and the '
            'full-strength label color. Labels pass AA on track and tile. '
            '48pt tall.',
      ),
      const _Anatomy(),
      Story(
        name: 'AdaptiveChoice<T>',
        source: 'widgets/adaptive_choice.dart',
        summary:
            'The one way to pick one of a few options in a screen. Renders a '
            'SegmentedControl at normal text sizes; once Dynamic Type grows '
            'past 1.3× it becomes a wrapping row of choice chips so labels '
            'never clip.',
        usedIn:
            'Settings theme, New game mode, rules panel mode, game input '
            'mode',
        props: const [
          Prop('options', 'List<ChoiceOption<T>>', 'two to four'),
          Prop('selected', 'T', 'exactly one'),
          Prop('onSelected', 'ValueChanged<T>', 'fires on change'),
        ],
        variants: [
          Variant(
            'Large text · chips',
            MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.4)),
              child: AdaptiveChoice<int>(
                options: const [
                  ChoiceOption(value: 0, label: 'Tap pins'),
                  ChoiceOption(value: 1, label: 'Number pad'),
                ],
                selected: _segment,
                onSelected: (v) => setState(() => _segment = v),
              ),
            ),
            note: 'Same semantics, same 48pt targets, at 1.4× text.',
          ),
        ],
      ),
      Story(
        name: 'Chips',
        source: 'theme/kaato_theme.dart (ChipThemeData)',
        summary:
            'Chips share the input line at rest and the primary fill when '
            'selected. FilterChip for tags, ChoiceChip in AdaptiveChoice, '
            'plain Chip for read-only rule facts, ActionChip for jumps.',
        usedIn: 'feedback tags, active rules, this page',
        variants: [
          Variant(
            'States',
            Wrap(
              spacing: KaatoSpacing.sm,
              runSpacing: KaatoSpacing.sm,
              children: [
                FilterChip(
                  label: const Text('Selected'),
                  selected: true,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('Unselected'),
                  selected: false,
                  onSelected: (_) {},
                ),
                const Chip(label: Text('First to 50')),
                ActionChip(label: const Text('Action'), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'SwitchCard · Switch.adaptive',
        source: 'widgets/form_cards.dart',
        summary:
            'A toggle row on a card: title, optional subtitle that can '
            'describe the current state, and a platform-adaptive switch.',
        usedIn: 'teams toggle, settings (haptics, keep awake)',
        props: const [
          Prop('title', 'String', ''),
          Prop('subtitle', 'String?', 'describe the effect of the state'),
          Prop('value', 'bool', ''),
          Prop('onChanged', 'ValueChanged<bool>?', 'null disables'),
          Prop('leading', 'Widget?', 'an icon'),
        ],
        variants: [
          Variant(
            'On · off · disabled',
            Column(
              children: [
                SwitchCard(
                  title: l10n.teams,
                  subtitle: _toggle ? l10n.teamsOnDesc : l10n.teamsOffDesc,
                  value: _toggle,
                  onChanged: (v) => setState(() => _toggle = v),
                ),
                SwitchCard(
                  title: 'Disabled',
                  subtitle: 'Shown when the option does not apply.',
                  value: true,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ],
        a11y: 'Title, subtitle and switch merge into one semantics node.',
      ),
      Story(
        name: 'StepperCard',
        source: 'widgets/form_cards.dart',
        summary:
            'Minus, value, plus on a card with circular buttons. The value '
            'is tappable and opens a dialog to type one; format() renders '
            'special values ("Off" for 0).',
        usedIn: 'house rules: target, back-to, elimination',
        props: const [
          Prop('value / min / max / step', 'int', 'clamped and stepped'),
          Prop('format', 'String Function(int)?', '"Off" for 0'),
          Prop(
            'editTitle',
            'String?',
            'dialog title; omit to disable '
                'typing',
          ),
          Prop('decreaseLabel / increaseLabel', 'String?', 'tooltips'),
          Prop('cancelLabel / doneLabel', 'String?', 'dialog actions'),
        ],
        variants: [
          Variant(
            'Editable, step 5',
            StepperCard(
              title: l10n.targetScore,
              subtitle: l10n.targetScoreDesc,
              value: _stepper,
              min: 10,
              max: 200,
              step: 5,
              onChanged: (v) => setState(() => _stepper = v),
              editTitle: l10n.editValueTitle,
              decreaseLabel: l10n.decreaseLabel,
              increaseLabel: l10n.increaseLabel,
              cancelLabel: l10n.cancel,
              doneLabel: l10n.done,
            ),
          ),
          Variant(
            'Formatted zero',
            StepperCard(
              title: l10n.eliminationRule,
              subtitle: l10n.eliminationDesc,
              value: 0,
              max: 9,
              format: (v) => v == 0 ? 'Off' : '$v',
              onChanged: (_) {},
              decreaseLabel: l10n.decreaseLabel,
              increaseLabel: l10n.increaseLabel,
            ),
          ),
        ],
        a11y:
            'Buttons carry tooltips; the value is a 48pt button; limits '
            'disable the matching button instead of ignoring the tap.',
      ),
      Story(
        name: 'ChoiceCard',
        source: 'widgets/form_cards.dart',
        summary:
            'A selectable option card with a radio dot. The selected card '
            'carries the primary border and a 12% wash; the others stay '
            'quiet. Use two to three side by side.',
        usedIn: 'available; no screen uses it since the app plays one game',
        props: const [
          Prop('title', 'String', ''),
          Prop('subtitle', 'String', 'one line on the consequence'),
          Prop('selected', 'bool', ''),
          Prop('onTap', 'VoidCallback', ''),
        ],
        variants: [
          Variant(
            'Pair',
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ChoiceCard(
                      title: 'Tap pins',
                      subtitle: 'Tap the pins that fell; the app adds up.',
                      selected: _choice == 0,
                      onTap: () => setState(() => _choice = 0),
                    ),
                  ),
                  const SizedBox(width: KaatoSpacing.md),
                  Expanded(
                    child: ChoiceCard(
                      title: 'Number pad',
                      subtitle: 'Type the score of the throw yourself.',
                      selected: _choice == 1,
                      onTap: () => setState(() => _choice = 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        a11y: 'Exposed as a radio-like button with selected state.',
      ),
      Story(
        name: 'StarRating',
        source: 'features/feedback/star_rating.dart',
        summary:
            'Five tappable stars, filled up to the value. The first '
            'question of every feedback moment.',
        usedIn: 'feedback sheet',
        props: const [
          Prop('value', 'int', '0 to 5'),
          Prop('onChanged', 'ValueChanged<int>', ''),
          Prop('size', 'double', 'icon.display by default'),
          Prop('idleColor', 'Color?', 'faded onSurface by default'),
        ],
        variants: [
          Variant(
            'Interactive',
            StarRating(
              value: _stars,
              onChanged: (v) => setState(() => _stars = v),
            ),
          ),
        ],
        a11y: 'Each star is a button labelled "n of 5 stars".',
      ),
    ];
  }

  // ---------------------------------------------------------------- cards

  List<Widget> _cards(AppLocalizations l10n) {
    return [
      _anchor(_Section.cards),
      Story(
        name: 'FormCard · FormLabel',
        source: 'widgets/form_cards.dart',
        summary:
            'The quiet surface behind every form row (surfaceContainerHighest, '
            '16pt corners). FormLabel is the title/subtitle pair most rows '
            'start with. Everything in Inputs and Cards sits on one.',
        usedIn: 'New game, Settings, this page',
        props: const [
          Prop('child', 'Widget', ''),
          Prop('onTap', 'VoidCallback?', 'makes the whole card a button'),
          Prop('borderColor / color', 'Color?', 'tinted team cards'),
          Prop(
            'padding / margin',
            'EdgeInsets',
            'defaults: 16/12 and a '
                '8pt bottom gap',
          ),
        ],
        variants: [
          const Variant(
            'Plain with FormLabel',
            FormCard(
              margin: EdgeInsets.zero,
              child: FormLabel(
                title: 'Title',
                subtitle: 'Subtitle explains the consequence.',
              ),
            ),
          ),
          Variant(
            'Tappable · bordered and tinted',
            Column(
              children: [
                FormCard(
                  onTap: () {},
                  child: const FormLabel(title: 'Tappable card'),
                ),
                FormCard(
                  margin: EdgeInsets.zero,
                  borderColor: KaatoPalette.walnut,
                  color: Color.alphaBlend(
                    KaatoPalette.walnut.withValues(
                      alpha: KaatoAlpha.activeTint,
                    ),
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: const FormLabel(title: 'Tinted (Team A)'),
                ),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'SettingCard',
        source: 'widgets/form_cards.dart',
        summary:
            'A row card: label on the left, one control on the right. With '
            'onTap and no trailing it shows a disclosure chevron and opens '
            'a sheet or screen.',
        usedIn: 'phone layout of New game (house rules, match), Settings',
        props: const [
          Prop(
            'title / subtitle',
            'String',
            'subtitle summarises the '
                'current value',
          ),
          Prop('leading', 'Widget?', 'icon'),
          Prop('trailing', 'Widget?', 'a control'),
          Prop('onTap', 'VoidCallback?', 'chevron when trailing is null'),
        ],
        variants: [
          Variant(
            'Disclosure · with trailing',
            Column(
              children: [
                SettingCard(
                  title: l10n.houseRules,
                  subtitle: 'First to 50, back to 25, out after 3 misses',
                  onTap: () {},
                ),
                SettingCard(
                  leading: const Icon(Icons.timer_outlined),
                  title: 'Turn clock',
                  trailing: TintPill(
                    label: '30s',
                    color: KaatoPalette.fjord,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Story(
        name:
            'SettingsSection · SettingsNavTile · SettingsSwitchTile · '
            'SettingsChoiceTile',
        source: 'widgets/settings_tiles.dart',
        summary:
            'The Settings vocabulary built on the form cards: a titled '
            'section, a navigation row with chevron, a switch row and a '
            'row that hosts a choice control (trailing or below).',
        usedIn: 'Settings',
        props: const [
          Prop('icon', 'IconData', 'leading glyph on every tile'),
          Prop('title / subtitle', 'String', ''),
          Prop('onTap / value / onChanged', '', 'per tile type'),
          Prop(
            'trailing / below',
            'Widget?',
            'SettingsChoiceTile: a '
                'compact control, or one on its own line',
          ),
        ],
        variants: [
          Variant(
            'A section',
            SettingsSection(
              title: 'Appearance',
              children: [
                SettingsChoiceTile(
                  icon: Icons.brightness_6_outlined,
                  title: 'Theme',
                  below: AdaptiveChoice<int>(
                    options: const [
                      ChoiceOption(value: 0, label: 'System'),
                      ChoiceOption(value: 1, label: 'Light'),
                      ChoiceOption(value: 2, label: 'Dark'),
                    ],
                    selected: 0,
                    onSelected: (_) {},
                  ),
                ),
                SettingsSwitchTile(
                  icon: Icons.vibration,
                  title: 'Haptics',
                  value: true,
                  onChanged: (_) {},
                ),
                SettingsNavTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Rules',
                  subtitle: 'Number kubb',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'ActiveSideCard · ColorDotName',
        source: 'widgets/side_card.dart',
        summary:
            'A standings card: filled with the primary color when the side '
            'is up, a quiet surface otherwise. ColorDotName pairs the '
            'identity dot with the name.',
        usedIn: 'game screen standings',
        props: const [
          Prop('isActive', 'bool', 'primaryContainer fill with its on-color'),
          Prop('color / name / textColor', '', 'ColorDotName'),
        ],
        variants: [
          Variant(
            'Active and waiting',
            Row(
              children: [
                Expanded(
                  child: ActiveSideCard(
                    isActive: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ColorDotName(
                          color: KaatoPalette.oak,
                          name: 'Freya',
                          textColor: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                        RollingNumber(
                          value: _rolling,
                          style: KaatoType.score(
                            size: KaatoType.stepScoreLg,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ActiveSideCard(
                    isActive: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ColorDotName(
                          color: KaatoPalette.fjord,
                          name: 'Björn',
                          textColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        Text(
                          '17',
                          style: KaatoType.score(
                            size: KaatoType.stepScoreLg,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        a11y:
            'The active side is also announced ("to throw"), not only '
            'shown by color.',
      ),
    ];
  }

  // -------------------------------------------------------------- players

  List<Widget> _players(AppLocalizations l10n) {
    return [
      _anchor(_Section.players),
      const Story(
        name: 'AvatarCircle',
        source: 'widgets/form_cards.dart',
        summary:
            'A player\'s identity disc: the initial, or the number for an '
            'unnamed player. The glyph is ink on light fills and birch on '
            'dark ones (KaatoPalette.on).',
        usedIn: 'player rows (also the drag handle), recent chips',
        props: [
          Prop('color', 'Color', 'one of playerColors'),
          Prop('label', 'String', 'initial or number'),
          Prop('size', 'double', '40 by default; 24 in chips'),
          Prop('dimmed', 'bool', '45% when the player is already picked'),
        ],
        variants: [
          Variant(
            'Initial · number · dimmed · sizes',
            Wrap(
              spacing: KaatoSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AvatarCircle(color: KaatoPalette.oak, label: 'J'),
                AvatarCircle(color: KaatoPalette.fjord, label: '2'),
                AvatarCircle(
                  color: KaatoPalette.berry,
                  label: 'E',
                  dimmed: true,
                ),
                AvatarCircle(color: KaatoPalette.amber, label: 'S', size: 24),
                AvatarCircle(color: KaatoPalette.plum, label: 'K', size: 56),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'TintPill',
        source: 'widgets/form_cards.dart',
        summary:
            'A small capsule in an identity color ("Team A"). Tappable '
            'when it is also the way to move a player.',
        usedIn: 'player rows in team mode',
        props: const [
          Prop('label', 'String', ''),
          Prop('color', 'Color', 'teamColor(team)'),
          Prop('onTap', 'VoidCallback?', ''),
          Prop(
            'semanticLabel',
            'String?',
            'the action ("Move Freya to '
                'Team B"), not the label',
          ),
        ],
        variants: [
          Variant(
            'Team A · Team B · static',
            Wrap(
              spacing: KaatoSpacing.sm,
              children: [
                TintPill(
                  label: l10n.teamA,
                  color: KaatoPalette.walnut,
                  onTap: () {},
                ),
                TintPill(
                  label: l10n.teamB,
                  color: KaatoPalette.fjord,
                  onTap: () {},
                ),
                const TintPill(label: '30s', color: KaatoPalette.fjord),
              ],
            ),
          ),
        ],
        a11y:
            '48pt minimum height; the label is excluded in favour of the '
            'action semantics.',
      ),
      Story(
        name: 'RecentChip',
        source: 'widgets/form_cards.dart',
        summary:
            'A recent player as a capsule chip: avatar plus name. Dimmed '
            'and inert once the player is in the list.',
        usedIn: 'New game, Recent',
        props: const [
          Prop('name / initial / color', '', 'from the stored player'),
          Prop('onPressed', 'VoidCallback?', 'adds the player'),
          Prop('dimmed', 'bool', 'already picked'),
        ],
        variants: [
          Variant(
            'Available · picked',
            Wrap(
              spacing: KaatoSpacing.sm,
              children: [
                RecentChip(
                  name: 'Jasper',
                  color: KaatoPalette.oak,
                  initial: 'J',
                  onPressed: () {},
                ),
                const RecentChip(
                  name: 'Kato',
                  color: KaatoPalette.fjord,
                  initial: 'K',
                  dimmed: true,
                  onPressed: null,
                ),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'Player row (composition)',
        source: 'features/setup/setup_screen.dart (_PlayerRow)',
        summary:
            'FormCard + AvatarCircle (drag handle) + inline name + '
            'TintPill + remove. Tapping the name swaps it for a dense '
            'TextField prefilled with the name.',
        usedIn: 'New game, Players',
        variants: [
          Variant(
            'Display · editing',
            Column(
              children: [
                FormCard(
                  padding: const EdgeInsets.fromLTRB(
                    KaatoSpacing.md,
                    KaatoSpacing.sm,
                    KaatoSpacing.sm,
                    KaatoSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      const AvatarCircle(color: KaatoPalette.oak, label: 'J'),
                      const SizedBox(width: KaatoSpacing.md),
                      const Expanded(
                        child: Text('Jasper', style: KaatoType.emphasis),
                      ),
                      TintPill(
                        label: l10n.teamA,
                        color: KaatoPalette.walnut,
                        onTap: () {},
                      ),
                      IconButton(
                        tooltip: l10n.removePlayer('Jasper'),
                        onPressed: () {},
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                FormCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.fromLTRB(
                    KaatoSpacing.md,
                    KaatoSpacing.sm,
                    KaatoSpacing.sm,
                    KaatoSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      const AvatarCircle(color: KaatoPalette.fjord, label: '2'),
                      const SizedBox(width: KaatoSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: 'Player 2'),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: KaatoSpacing.md,
                              vertical: KaatoSpacing.sm + KaatoSpacing.xxs,
                            ),
                          ),
                          style: KaatoType.emphasis,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.removePlayer('Player 2'),
                        onPressed: () {},
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'Team card (composition)',
        source: 'features/setup/setup_screen.dart (_TeamCard)',
        summary:
            'A FormCard tinted and bordered in the team color, with the '
            'team-name field and the member list.',
        usedIn: 'New game, Teams',
        variants: [
          Variant(
            'Team A',
            FormCard(
              margin: EdgeInsets.zero,
              borderColor: KaatoPalette.walnut,
              color: Color.alphaBlend(
                KaatoPalette.walnut.withValues(alpha: KaatoAlpha.activeTint),
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.teamA,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: KaatoSpacing.md,
                        vertical: KaatoSpacing.sm + KaatoSpacing.xxs,
                      ),
                    ),
                    style: KaatoType.emphasis,
                  ),
                  const SizedBox(height: KaatoSpacing.xs),
                  const Text('Jasper, Erik', style: KaatoType.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  // --------------------------------------------------------------- status

  List<Widget> _status(ColorScheme scheme) {
    return [
      _anchor(_Section.status),
      Story(
        name: 'DotRow',
        source: 'widgets/dot_row.dart',
        summary:
            'A row of dots, filled up to a count: misses toward '
            'elimination. One semantic label describes the whole row.',
        usedIn: 'standings cards, scoreboard',
        props: const [
          Prop('count / filled', 'int', ''),
          Prop(
            'activeColor / idleColor',
            'Color',
            'idle is usually '
                'onSurface at alpha.dotIdle',
          ),
          Prop('size', 'double', 'icon.dot (10) or icon.md'),
          Prop('semanticLabel', 'String?', '"2 of 3 misses"'),
        ],
        variants: [
          Variant(
            'Misses (danger) · neutral',
            Wrap(
              spacing: KaatoSpacing.xl,
              runSpacing: KaatoSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DotRow(
                  count: 3,
                  filled: 2,
                  activeColor: KaatoPalette.danger(scheme.brightness),
                  idleColor: scheme.onSurface.withValues(
                    alpha: KaatoAlpha.dotIdle,
                  ),
                  semanticLabel: 'misses 2/3',
                ),
                DotRow(
                  count: 3,
                  filled: 1,
                  activeColor: KaatoPalette.woodAccent(scheme.brightness),
                  idleColor: KaatoPalette.woodAccent(scheme.brightness)
                      .withValues(alpha: KaatoAlpha.dotIdle),
                  size: KaatoIconSize.md,
                  semanticLabel: '1 of 3',
                ),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'RollingNumber',
        source: 'widgets/rolling_number.dart',
        summary:
            'A score that rolls to its new value. The number is the state; '
            'the roll is decoration and collapses under Reduce Motion.',
        usedIn: 'standings cards, scoreboard',
        props: const [
          Prop('value', 'int', ''),
          Prop(
            'style',
            'TextStyle?',
            'use KaatoType.score for tabular '
                'digits',
          ),
        ],
        variants: [
          Variant(
            'Roll',
            Row(
              children: [
                RollingNumber(
                  value: _rolling,
                  style: KaatoType.score(size: KaatoType.stepScoreLg),
                ),
                const SizedBox(width: KaatoSpacing.lg),
                FilledButton.tonal(
                  onPressed: () => setState(() => _rolling += 3),
                  child: const Text('+3'),
                ),
              ],
            ),
          ),
        ],
      ),
      Story(
        name: 'CelebrationBanner',
        source: 'widgets/celebration.dart',
        summary:
            'The headline of an overlay ("Freya wins!") in the brand '
            'face, sized for the hero step.',
        usedIn: 'win overlay',
        props: const [
          Prop('text', 'String', ''),
          Prop('size', 'double?', 'stepHero by default'),
        ],
        variants: const [
          Variant(
            'On the scrim',
            CelebrationBanner('Freya wins!'),
            background: KaatoPalette.forestDeep,
          ),
        ],
      ),
      Story(
        name: 'SnackBar',
        source: 'Material, themed',
        summary:
            'Transient confirmations ("Thanks for the feedback"). Never for '
            'anything the player must act on.',
        usedIn: 'feedback thank-you, undo hints',
        variants: [
          Variant(
            'Show',
            FilledButton.tonal(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thanks for the feedback')),
              ),
              child: const Text('Show snackbar'),
            ),
          ),
        ],
      ),
    ];
  }

  // ------------------------------------------------------------- overlays

  List<Widget> _overlays(AppLocalizations l10n, ColorScheme scheme) {
    return [
      _anchor(_Section.overlays),
      Story(
        name: 'confirmAdaptive',
        source: 'widgets/confirm_dialog.dart',
        summary:
            'The one confirmation dialog: a Cupertino alert on iOS, a '
            'Material one elsewhere, with the destructive action styled '
            'as such and cancel as the default.',
        usedIn: 'new game while one runs, delete history, swipe to delete',
        props: const [
          Prop('title / body', 'String', ''),
          Prop('confirmLabel', 'String', 'a verb ("Delete")'),
          Prop('isDestructive', 'bool', 'red confirm'),
        ],
        variants: [
          Variant(
            'Open',
            FilledButton.tonal(
              onPressed: () => confirmAdaptive(
                context,
                title: l10n.newGameConfirmTitle,
                body: l10n.newGameConfirmBody,
                confirmLabel: l10n.newGame,
                isDestructive: true,
              ),
              child: const Text('Open confirm dialog'),
            ),
          ),
        ],
      ),
      Story(
        name: 'CelebrationScaffold',
        source: 'widgets/celebration.dart',
        summary:
            'The full-screen end-of-game overlay: forest scrim tinted with '
            'the winner\'s color, banner, score line, details, actions and '
            'a footer, with confetti when celebrate is true.',
        usedIn: 'win overlay, early king, match won',
        props: const [
          Prop('banner', 'Widget', 'CelebrationBanner'),
          Prop('scoreLine / details / footer', 'Widget?', ''),
          Prop('actions', 'List<Widget>', 'Overlay buttons, primary first'),
          Prop('winnerColor', 'Color?', 'tints the scrim'),
          Prop('celebrate', 'bool', 'confetti and mascot cheer'),
        ],
        variants: [
          Variant(
            'Inline preview (celebrate off)',
            SizedBox(
              height: 380,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(KaatoRadius.lg),
                child: CelebrationScaffold(
                  celebrate: false,
                  winnerColor: KaatoPalette.oak,
                  banner: const CelebrationBanner('Freya wins!'),
                  scoreLine: Text(
                    '50 – 42',
                    textAlign: TextAlign.center,
                    style: KaatoType.score(
                      size: KaatoType.stepScoreLg,
                      color: KaatoPalette.birchLight,
                    ),
                  ),
                  actions: [
                    OverlayFilledButton(
                      onPressed: () {},
                      child: Text(l10n.rematch),
                    ),
                    OverlayOutlinedButton(
                      onPressed: () {},
                      child: const Text('Share'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        a11y:
            'The banner is announced first; actions are in reading order; '
            'confetti ignores pointer events and stops with Reduce Motion.',
      ),
      Story(
        name: 'ConfettiBurst',
        source: 'widgets/confetti.dart',
        summary:
            'A 2.5 s burst of leaves and chips in the brand colors, '
            'drawn above the overlay. Decoration only.',
        usedIn: 'CelebrationScaffold',
        props: const [Prop('duration', 'Duration', '2500 ms by default')],
        variants: [
          Variant(
            'Burst',
            SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_confettiRun > 0)
                    ConfettiBurst(key: ValueKey(_confettiRun)),
                  Center(
                    child: FilledButton.tonal(
                      onPressed: () => setState(() => _confettiRun++),
                      child: const Text('Burst'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Story(
        name: 'ShareCard · showShareCardDialog',
        source: 'widgets/share_card.dart',
        summary:
            'The result as an image: birch card with wood grain, framed in '
            'the winner\'s color, rows for every side. The dialog renders '
            'it to a PNG for the share sheet.',
        usedIn: 'win overlay, Share',
        props: const [
          Prop('banner', 'String', ''),
          Prop('rows', 'List<ShareRow>', 'label, value, emphasized, struck'),
          Prop('winnerColor', 'Color', 'frame'),
          Prop('width', 'double', 'defaultWidth'),
        ],
        variants: [
          Variant(
            'Card',
            Center(
              child: ShareCard(
                banner: l10n.winnerBanner('Freya'),
                rows: const [
                  ShareRow('Freya', '50', emphasized: true),
                  ShareRow('Björn', '42'),
                  ShareRow('Erik', '31', struck: true),
                ],
                winnerColor: KaatoPalette.oak,
              ),
            ),
          ),
          Variant(
            'Dialog',
            FilledButton.tonal(
              onPressed: () => showShareCardDialog(
                context,
                banner: l10n.winnerBanner('Freya'),
                rows: const [
                  ShareRow('Freya', '50', emphasized: true),
                  ShareRow('Björn', '42'),
                ],
                winnerColor: KaatoPalette.oak,
              ),
              child: const Text('Open share dialog'),
            ),
          ),
        ],
      ),
    ];
  }

  // --------------------------------------------------------------- pieces

  List<Widget> _pieces() {
    return [
      _anchor(_Section.pieces),
      Story(
        name: 'PinDiagram',
        source: 'features/game/pin_diagram.dart',
        summary:
            'The twelve Mölkky pins as tappable wooden discs: oak standing, '
            'walnut when down, numbers on painted birch discs. The main '
            'input of a number-kubb turn.',
        usedIn: 'game screen (tap pins mode), rules illustrations',
        props: const [
          Prop('selected', 'Set<int>', 'pins marked down'),
          Prop('onToggle', 'ValueChanged<int>', ''),
          Prop('pinSize', 'double', '60 by default'),
        ],
        variants: [
          Variant(
            'Pin 10 down',
            PinDiagram(selected: const {10}, onToggle: (_) {}, pinSize: 34),
          ),
        ],
        a11y:
            'Each pin is a button "pin n" with selected state; the fallen '
            'pin also tilts, so state is not color alone.',
      ),
    ];
  }

  // --------------------------------------------------------- illustration

  List<Widget> _illustration(AppLocalizations l10n, ColorScheme scheme) {
    return [
      _anchor(_Section.illustration),
      const Story(
        name: 'VikingMascot',
        source: 'widgets/viking_mascot.dart',
        summary:
            'The code-drawn Viking: flat, chunky linework, no gradients. '
            'Three poses; idle on Home, cheer on a win, oops on a miss '
            'streak. Text-free so it never needs localization.',
        usedIn: 'Home, win overlay, empty states',
        props: [
          Prop('pose', 'MascotPose', 'idle, cheer, oops'),
          Prop('size', 'double', '120 by default'),
        ],
        variants: [
          Variant(
            'Poses',
            Row(
              children: [
                VikingMascot(size: 96),
                VikingMascot(pose: MascotPose.cheer, size: 96),
                VikingMascot(pose: MascotPose.oops, size: 96),
              ],
            ),
          ),
        ],
        a11y: 'Decorative: excluded from semantics.',
      ),
      Story(
        name: 'WoodGrainBackground',
        source: 'widgets/wood_grain.dart',
        summary:
            'Long grain lines with the odd knot, drawn at low opacity over '
            'a brand surface. Only on large surfaces (Home, onboarding, '
            'share card), never behind body text.',
        usedIn: 'Home, onboarding, share card',
        props: const [
          Prop('color', 'Color', 'KaatoPalette.woodGrain(brightness)'),
          Prop(
            'opacity',
            'double',
            '0.05 by default; alpha.grain on the '
                'share card',
          ),
        ],
        variants: [
          Variant(
            'Exaggerated to 14% for this page',
            SizedBox(
              height: 96,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  WoodGrainBackground(
                    color: KaatoPalette.woodGrain(scheme.brightness),
                    opacity: 0.14,
                  ),
                ],
              ),
            ),
          ),
        ],
        a11y: 'Ignores pointers; purely decorative.',
      ),
      Story(
        name: 'Rule illustrations',
        source: 'features/rules/rule_illustrations.dart',
        summary:
            'Small text-free diagrams for the rules panel (throw arc, '
            'scoring, elimination, king). Arrows, trophies and sticks use '
            'KaatoPalette.woodAccent so they read in both themes.',
        usedIn: 'rules panel',
        variants: [
          Variant(
            'Wood accent on this surface',
            Row(
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: KaatoPalette.woodAccent(scheme.brightness),
                ),
                const SizedBox(width: KaatoSpacing.md),
                Icon(
                  Icons.emoji_events,
                  color: KaatoPalette.woodAccent(scheme.brightness),
                ),
                const SizedBox(width: KaatoSpacing.md),
                Text(
                  scheme.brightness == Brightness.dark
                      ? 'sanded oak on charcoal'
                      : 'walnut on birch',
                  style: KaatoType.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // ----------------------------------------------------------- behaviours

  List<Widget> _behaviours(ColorScheme scheme) {
    return [
      _anchor(_Section.behaviours),
      const Story(
        name: 'KeepAwake',
        source: 'widgets/keep_awake.dart',
        summary:
            'Wraps a screen and keeps the display on while it is visible, '
            'when the setting allows. Non-visual.',
        usedIn: 'game screen and scoreboard',
        props: [Prop('child', 'Widget', '')],
      ),
      const Story(
        name: 'LiquidGlass.isEnabled · isCupertino',
        source: 'theme/glass.dart',
        summary:
            'Platform gates for the chrome: Cupertino idiom on iOS and '
            'macOS; real blur only when Increase Contrast is off. Both read '
            'Theme.platform, which is how this page previews iOS.',
      ),
      Story(
        name: 'KaatoPalette.on · woodAccent · woodGrain · danger',
        source: 'theme/palette.dart',
        summary:
            'Small color functions so screens never pick a foreground by '
            'hand: on(fill) returns ink or birch by luminance; the others '
            'return the tone that passes AA on the current theme.',
        variants: [
          Variant(
            'Live on this theme',
            Wrap(
              spacing: KaatoSpacing.md,
              runSpacing: KaatoSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final (name, c) in [
                  ('woodAccent', KaatoPalette.woodAccent(scheme.brightness)),
                  ('danger', KaatoPalette.danger(scheme.brightness)),
                  ('on(oak)', KaatoPalette.on(KaatoPalette.oak)),
                  ('on(walnut)', KaatoPalette.on(KaatoPalette.walnut)),
                ])
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                      ),
                      const SizedBox(width: KaatoSpacing.xs),
                      Text(name, style: Story.code),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ];
  }
}

/// The labelled anatomy of a segmented control, like the blueprint:
/// track, active tile, label, icon, active and inactive segments.
class _Anatomy extends StatelessWidget {
  const _Anatomy();

  @override
  Widget build(BuildContext context) {
    final faded = Theme.of(context).colorScheme.onSurface
        .withValues(alpha: KaatoAlpha.faded);
    Widget part(String name, String what) => Padding(
      padding: const EdgeInsets.only(bottom: KaatoSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(name, style: KaatoType.strong)),
          Expanded(
            child: Text(what, style: KaatoType.caption.copyWith(color: faded)),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: KaatoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Anatomy', style: KaatoType.emphasis),
          const SizedBox(height: KaatoSpacing.sm),
          part(
            'Track',
            'Text color at 8% (light) or 10% (dark); radius 12; 48pt tall.',
          ),
          part(
            'Active tile',
            'Surface (birch) or segmentTileDark; radius 8, inset 4 so the '
                'corners are concentric; soft shadow; slides in 200 ms.',
          ),
          part(
            'Label',
            'Active: full onSurface, semibold. Inactive: onSurface at 70%, '
                'medium. One line, ellipsis.',
          ),
          part('Icon', 'Optional, 18pt, leading, same color as the label.'),
          part(
            'Segments',
            'Equal widths across the track; the whole segment is the tap '
                'target.',
          ),
        ],
      ),
    );
  }
}

/// The ramp as one plank, and the accent pairings the palette promises
/// (text on fill) with their measured contrast, so a change to a token
/// shows its effect on this page before it reaches a screen.
class _WoodRampStrip extends StatelessWidget {
  const _WoodRampStrip();

  static String _ratio(Color fg, Color bg) {
    final a = fg.computeLuminance() + 0.05;
    final b = bg.computeLuminance() + 0.05;
    return '${(a > b ? a / b : b / a).toStringAsFixed(1)}:1';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surface = Theme.of(context).colorScheme.surface;
    final accent = KaatoPalette.woodAccent(brightness);
    Widget pairing(String label, Color fg, Color bg) => Container(
      padding: const EdgeInsets.symmetric(
        horizontal: KaatoSpacing.md,
        vertical: KaatoSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(KaatoRadius.sm),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface
              .withValues(alpha: KaatoAlpha.dotIdle),
        ),
      ),
      child: Text(
        '$label  ${_ratio(fg, bg)}',
        style: KaatoType.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: KaatoSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KaatoRadius.sm),
              gradient: const LinearGradient(
                colors: [
                  KaatoPalette.birchLight,
                  KaatoPalette.birch,
                  KaatoPalette.oakLight,
                  KaatoPalette.oak,
                  KaatoPalette.walnut,
                  KaatoPalette.bark,
                ],
              ),
            ),
          ),
          const SizedBox(height: KaatoSpacing.sm),
          Wrap(
            spacing: KaatoSpacing.sm,
            runSpacing: KaatoSpacing.sm,
            children: [
              pairing('ink on oak', KaatoPalette.ink, KaatoPalette.oak),
              pairing(
                'ink on oakLight',
                KaatoPalette.ink,
                KaatoPalette.oakLight,
              ),
              pairing(
                'birch on walnut',
                KaatoPalette.birchLight,
                KaatoPalette.walnut,
              ),
              pairing('woodAccent on surface', accent, surface),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwatchGrid extends StatelessWidget {
  const _SwatchGrid({required this.title, required this.entries});

  final String title;
  final List<(String, Color)> entries;

  @override
  Widget build(BuildContext context) {
    String hex(Color c) =>
        '#${c.toARGB32().toRadixString(16).toUpperCase().substring(2)}';
    return Padding(
      padding: const EdgeInsets.only(bottom: KaatoSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KaatoType.emphasis),
          const SizedBox(height: KaatoSpacing.xs),
          Wrap(
            spacing: KaatoSpacing.md,
            runSpacing: KaatoSpacing.sm,
            children: [
              for (final (name, color) in entries)
                SizedBox(
                  width: 108,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(KaatoRadius.sm),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface
                                .withValues(alpha: KaatoAlpha.dotIdle),
                          ),
                        ),
                      ),
                      Text(name, style: KaatoType.caption),
                      Text(hex(color), style: KaatoType.caption),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
