// TEMPORARY: design review (remove the route, the settings entry and this
// file once the design-system review is done).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/celebration.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/dot_row.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/rolling_number.dart';
import '../../widgets/section_header.dart';
import '../../widgets/settings_tiles.dart';
import '../../widgets/share_card.dart';
import '../../widgets/side_card.dart';
import '../../widgets/viking_mascot.dart';
import '../game/pin_diagram.dart';
import '../kubb/kubb_field.dart';
import '../settings/settings_controller.dart';

/// The living design system: every token and every component with its
/// states, viewable in both themes. Review surface only — not linked from
/// the product flows (reachable via /designsystem and Settings).
class DesignSystemScreen extends ConsumerStatefulWidget {
  const DesignSystemScreen({super.key});

  @override
  ConsumerState<DesignSystemScreen> createState() => _DesignSystemScreenState();
}

class _DesignSystemScreenState extends ConsumerState<DesignSystemScreen> {
  var _rolling = 42;
  var _motionOn = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.designSystemLabel),
        leading: homeLeading(context),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: IKubbLayout.maxPanel),
          child: ListView(
            padding: const EdgeInsets.all(IKubbSpacing.lg),
            children: [
              // Theme switch: everything below re-renders live.
              SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.systemDefault),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                  ),
                ],
                selected: {ref.watch(themeModeProvider)},
                onSelectionChanged: (s) =>
                    ref.read(themeModeProvider.notifier).set(s.first),
              ),
              const _Gap(),
              const SectionHeader('Color tokens'),
              const _SwatchGrid(
                title: 'Neutrals (birchwood)',
                entries: [
                  ('birchLight', IKubbPalette.birchLight),
                  ('birch', IKubbPalette.birch),
                  ('ink', IKubbPalette.ink),
                ],
              ),
              const _SwatchGrid(
                title: 'Brand greens',
                entries: [
                  ('forest', IKubbPalette.forest),
                  ('forestDeep', IKubbPalette.forestDeep),
                  ('pine', IKubbPalette.pine),
                  ('sage', IKubbPalette.sage),
                ],
              ),
              const _SwatchGrid(
                title: 'Wood accents',
                entries: [
                  ('oak', IKubbPalette.oak),
                  ('walnut', IKubbPalette.walnut),
                ],
              ),
              const _SwatchGrid(
                title: 'Signals',
                entries: [
                  ('amber', IKubbPalette.amber),
                  ('berry', IKubbPalette.berry),
                  ('berryLight', IKubbPalette.berryLight),
                ],
              ),
              const _SwatchGrid(
                title: 'Dark surfaces',
                entries: [
                  ('charcoalWood', IKubbPalette.charcoalWood),
                  ('nightSurface', IKubbPalette.nightSurface),
                ],
              ),
              const _SwatchGrid(
                title: 'Player identity',
                entries: [
                  ('oak', IKubbPalette.oak),
                  ('fjord', IKubbPalette.fjord),
                  ('berry', IKubbPalette.berry),
                  ('amber', IKubbPalette.amber),
                  ('plum', IKubbPalette.plum),
                  ('copper', IKubbPalette.copper),
                  ('slate', IKubbPalette.slate),
                  ('indigo', IKubbPalette.indigo),
                ],
              ),
              const _Gap(),
              const SectionHeader('Type scale (Baloo 2 + platform font)'),
              for (final (name, size) in const [
                ('stepChip', IKubbType.stepChip),
                ('stepLabel', IKubbType.stepLabel),
                ('stepBody', IKubbType.stepBody),
                ('stepTitle', IKubbType.stepTitle),
                ('stepHeadline', IKubbType.stepHeadline),
                ('stepScoreCard', IKubbType.stepScoreCard),
                ('stepScoreLg', IKubbType.stepScoreLg),
                ('stepHero', IKubbType.stepHero),
                ('stepDisplay', IKubbType.stepDisplay),
                ('stepWordmark', IKubbType.stepWordmark),
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: IKubbSpacing.xs,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$name\n${size.toInt()}px',
                          style: IKubbType.caption,
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kubb 21',
                            style: IKubbType.heading(size: size),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const _Gap(),
              const SectionHeader('Companion text styles'),
              Text('emphasis — side names', style: IKubbType.emphasis),
              Text('strong — card titles in lists', style: IKubbType.strong),
              Text(
                'reading — long-form tour/rule text',
                style: IKubbType.reading,
              ),
              Text(
                'statValue — stat and stepper values',
                style: IKubbType.statValue,
              ),
              Text('cardTitle — player card names', style: IKubbType.cardTitle),
              Text('caption — dates and footnotes', style: IKubbType.caption),
              const _Gap(),
              const SectionHeader('Spacing'),
              for (final (name, v) in const [
                ('xxs', IKubbSpacing.xxs),
                ('xs', IKubbSpacing.xs),
                ('sm', IKubbSpacing.sm),
                ('md', IKubbSpacing.md),
                ('lg', IKubbSpacing.lg),
                ('xl', IKubbSpacing.xl),
                ('xxl', IKubbSpacing.xxl),
                ('huge', IKubbSpacing.huge),
              ])
                _ScaleBar(name: name, value: v),
              const _Gap(),
              const SectionHeader('Radius'),
              Wrap(
                spacing: IKubbSpacing.md,
                runSpacing: IKubbSpacing.md,
                children: [
                  for (final (name, r) in const [
                    ('xs', IKubbRadius.xs),
                    ('sm', IKubbRadius.sm),
                    ('chip', IKubbRadius.chip),
                    ('md', IKubbRadius.md),
                    ('lg', IKubbRadius.lg),
                    ('xl', IKubbRadius.xl),
                  ])
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 48,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(r),
                          ),
                        ),
                        Text('$name ${r.toInt()}', style: IKubbType.caption),
                      ],
                    ),
                ],
              ),
              const _Gap(),
              const SectionHeader('Alpha steps'),
              Wrap(
                spacing: IKubbSpacing.md,
                children: [
                  for (final (name, a) in const [
                    ('grain', IKubbAlpha.grain),
                    ('dotIdle', IKubbAlpha.dotIdle),
                    ('activeTint', IKubbAlpha.activeTint),
                    ('faded', IKubbAlpha.faded),
                    ('scrim', IKubbAlpha.scrim),
                  ])
                    Column(
                      children: [
                        Container(
                          width: 56,
                          height: 40,
                          color: scheme.primary.withValues(alpha: a),
                        ),
                        Text(name, style: IKubbType.caption),
                      ],
                    ),
                ],
              ),
              const _Gap(),
              const SectionHeader('Motion'),
              Text(
                'quick 200 · base 250 · entrance 300 · gentle 350 — all '
                'collapse to zero under Reduce Motion.',
                style: IKubbType.caption,
              ),
              const SizedBox(height: IKubbSpacing.sm),
              Row(
                children: [
                  FilledButton.tonal(
                    onPressed: () => setState(() => _motionOn = !_motionOn),
                    child: const Text('Play'),
                  ),
                  const SizedBox(width: IKubbSpacing.lg),
                  AnimatedContainer(
                    duration: IKubbMotion.resolve(context, IKubbMotion.base),
                    curve: IKubbMotion.emphasized,
                    width: _motionOn ? 120 : 48,
                    height: 32,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(IKubbRadius.lg),
                    ),
                  ),
                ],
              ),
              const _Gap(),
              const SectionHeader('Buttons'),
              Wrap(
                spacing: IKubbSpacing.md,
                runSpacing: IKubbSpacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton(onPressed: () {}, child: const Text('Filled')),
                  const FilledButton(onPressed: null, child: Text('Disabled')),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Tonal'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Text')),
                ],
              ),
              const SizedBox(height: IKubbSpacing.md),
              Container(
                padding: const EdgeInsets.all(IKubbSpacing.lg),
                decoration: BoxDecoration(
                  color: IKubbPalette.forestDeep,
                  borderRadius: BorderRadius.circular(IKubbRadius.lg),
                ),
                child: Wrap(
                  spacing: IKubbSpacing.md,
                  runSpacing: IKubbSpacing.md,
                  children: [
                    OverlayFilledButton(
                      onPressed: () {},
                      child: const Text('Overlay filled'),
                    ),
                    OverlayOutlinedButton(
                      onPressed: () {},
                      child: const Text('Overlay outlined'),
                    ),
                  ],
                ),
              ),
              const _Gap(),
              const SectionHeader('Chips & dots'),
              Wrap(
                spacing: IKubbSpacing.md,
                runSpacing: IKubbSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Chip(label: Text('Rule chip')),
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
                ],
              ),
              const SizedBox(height: IKubbSpacing.sm),
              Row(
                children: [
                  DotRow(
                    count: 3,
                    filled: 2,
                    activeColor: IKubbPalette.berry,
                    idleColor: scheme.onSurface.withValues(
                      alpha: IKubbAlpha.dotIdle,
                    ),
                    semanticLabel: 'misses 2/3',
                  ),
                  const SizedBox(width: IKubbSpacing.xl),
                  DotRow(
                    count: 2,
                    filled: 1,
                    activeColor: IKubbPalette.amber,
                    idleColor: scheme.onSurface.withValues(
                      alpha: IKubbAlpha.dotIdle,
                    ),
                    semanticLabel: 'match 1/2',
                  ),
                  const SizedBox(width: IKubbSpacing.xl),
                  DotRow(
                    count: 6,
                    filled: 4,
                    activeColor: IKubbPalette.walnut,
                    idleColor: IKubbPalette.walnut.withValues(
                      alpha: IKubbAlpha.dotIdle,
                    ),
                    size: IKubbIconSize.md,
                    semanticLabel: 'batons 4/6',
                  ),
                ],
              ),
              const _Gap(),
              const SectionHeader('Game pieces'),
              Row(
                children: [
                  const Column(
                    children: [
                      KubbBlock(),
                      Text('standing', style: IKubbType.caption),
                    ],
                  ),
                  const SizedBox(width: IKubbSpacing.lg),
                  const Column(
                    children: [
                      KubbBlock(selected: true),
                      Text('selected', style: IKubbType.caption),
                    ],
                  ),
                  const SizedBox(width: IKubbSpacing.lg),
                  const Column(
                    children: [
                      KubbBlock(felled: true),
                      Text('down', style: IKubbType.caption),
                    ],
                  ),
                  const SizedBox(width: IKubbSpacing.xl),
                  const Column(
                    children: [
                      KubbKing(),
                      Text('king', style: IKubbType.caption),
                    ],
                  ),
                  const SizedBox(width: IKubbSpacing.xl),
                  Column(
                    children: [
                      PinDiagram(
                        selected: const {10},
                        onToggle: (_) {},
                        pinSize: 34,
                      ),
                      const Text('pins', style: IKubbType.caption),
                    ],
                  ),
                ],
              ),
              const _Gap(),
              const SectionHeader('Standings card'),
              Row(
                children: [
                  Expanded(
                    child: ActiveSideCard(
                      isActive: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColorDotName(
                            color: IKubbPalette.oak,
                            name: 'Active side',
                            textColor: scheme.onPrimary,
                          ),
                          RollingNumber(
                            value: _rolling,
                            style: IKubbType.score(
                              size: IKubbType.stepScoreLg,
                              color: scheme.onPrimary,
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
                            color: IKubbPalette.fjord,
                            name: 'Waiting side',
                            textColor: scheme.onSurface,
                          ),
                          Text(
                            '17',
                            style: IKubbType.score(
                              size: IKubbType.stepScoreLg,
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: IKubbSpacing.sm),
              FilledButton.tonal(
                onPressed: () => setState(() => _rolling += 3),
                child: const Text('Roll the number'),
              ),
              const _Gap(),
              const SectionHeader('Mascot poses'),
              const Row(
                children: [
                  VikingMascot(size: 96),
                  VikingMascot(pose: MascotPose.cheer, size: 96),
                  VikingMascot(pose: MascotPose.oops, size: 96),
                ],
              ),
              const _Gap(),
              const SectionHeader('Share card'),
              Center(
                child: ShareCard(
                  banner: l10n.winnerBanner('Freya'),
                  rows: const [
                    ShareRow('Freya', '50', emphasized: true),
                    ShareRow('Björn', '42'),
                    ShareRow('Erik', '31', struck: true),
                  ],
                  winnerColor: IKubbPalette.oak,
                ),
              ),
              const _Gap(),
              const SectionHeader('Dialogs & tiles'),
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
              SettingsNavTile(
                icon: Icons.menu_book_outlined,
                title: 'Nav tile',
                onTap: () {},
              ),
              SettingsSwitchTile(
                icon: Icons.vibration,
                title: 'Switch tile',
                value: true,
                onChanged: (_) {},
              ),
              const SizedBox(height: IKubbSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: IKubbSpacing.xl);
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
      padding: const EdgeInsets.only(bottom: IKubbSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: IKubbType.emphasis),
          const SizedBox(height: IKubbSpacing.xs),
          Wrap(
            spacing: IKubbSpacing.md,
            runSpacing: IKubbSpacing.sm,
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
                          borderRadius: BorderRadius.circular(IKubbRadius.sm),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface
                                .withValues(alpha: IKubbAlpha.dotIdle),
                          ),
                        ),
                      ),
                      Text(name, style: IKubbType.caption),
                      Text(hex(color), style: IKubbType.caption),
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

class _ScaleBar extends StatelessWidget {
  const _ScaleBar({required this.name, required this.value});

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: IKubbSpacing.xxs),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text('$name ${value.toInt()}', style: IKubbType.caption),
          ),
          Container(
            width: value * 4,
            height: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
