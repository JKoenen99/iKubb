import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/home_leading.dart';
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

/// Settings (SPEC.md §3.8): language override, haptics, screen wake,
/// plus quick paths to the rules and the tour.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: homeLeading(context),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                trailing: DropdownButton<String>(
                  value: locale?.languageCode ?? '',
                  onChanged: (code) => ref
                      .read(localeControllerProvider.notifier)
                      .set(code == null || code.isEmpty ? null : Locale(code)),
                  items: [
                    DropdownMenuItem(
                        value: '', child: Text(l10n.systemDefault)),
                    for (final entry in _languageNames.entries)
                      DropdownMenuItem(
                          value: entry.key, child: Text(entry.value)),
                  ],
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.vibration),
                title: Text(l10n.haptics),
                value: ref.watch(hapticsEnabledProvider),
                onChanged: ref.read(hapticsEnabledProvider.notifier).set,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.light_mode_outlined),
                title: Text(l10n.keepAwake),
                value: ref.watch(keepAwakeProvider),
                onChanged: ref.read(keepAwakeProvider.notifier).set,
              ),
              const Divider(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(l10n.rules),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/rules'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.school_outlined),
                title: Text(l10n.teachMe),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/tour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
