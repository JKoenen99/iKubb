import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/tokens.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/settings_tiles.dart';
import 'settings_controller.dart';

/// Language names shown as endonyms — they must never be translated.
const _languageNames = {
  'en': 'English',
  'sv': 'Svenska',
  'de': 'Deutsch',
  'nl': 'Nederlands',
  'fr': 'Français',
  'da': 'Dansk',
  'nb': 'Norsk',
  'fi': 'Suomi',
  'it': 'Italiano',
  'es': 'Español',
};

/// Settings (SPEC.md §3.8): appearance, play preferences, and quick
/// paths to the rules and the tour — built from the shared tiles.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), leading: homeLeading(context)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: IKubbLayout.maxContent),
          child: ListView(
            padding: const EdgeInsets.all(IKubbSpacing.lg),
            children: [
              SettingsChoiceTile(
                icon: Icons.brightness_6_outlined,
                title: l10n.theme,
                below: SegmentedButton<ThemeMode>(
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
              ),
              SettingsChoiceTile(
                icon: Icons.language,
                title: l10n.language,
                trailing: DropdownButton<String>(
                  value: locale?.languageCode ?? '',
                  onChanged: (code) => ref
                      .read(localeControllerProvider.notifier)
                      .set(code == null || code.isEmpty ? null : Locale(code)),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(l10n.systemDefault),
                    ),
                    for (final entry in _languageNames.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                  ],
                ),
              ),
              SettingsSwitchTile(
                icon: Icons.vibration,
                title: l10n.haptics,
                value: ref.watch(hapticsEnabledProvider),
                onChanged: ref.read(hapticsEnabledProvider.notifier).set,
              ),
              SettingsSwitchTile(
                icon: Icons.visibility_outlined,
                title: l10n.keepAwake,
                value: ref.watch(keepAwakeProvider),
                onChanged: ref.read(keepAwakeProvider.notifier).set,
              ),
              const Divider(height: IKubbSpacing.xxl),
              SettingsNavTile(
                icon: Icons.menu_book_outlined,
                title: l10n.rules,
                onTap: () => context.push('/rules'),
              ),
              SettingsNavTile(
                icon: Icons.school_outlined,
                title: l10n.teachMe,
                onTap: () => context.push('/tour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
