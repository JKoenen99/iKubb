import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/glass.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/kaato_app_bar.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/adaptive_choice.dart';
import '../../widgets/form_cards.dart';
import '../../widgets/settings_tiles.dart';
import '../feedback/feedback_controller.dart';
import '../feedback/feedback_event.dart';
import '../feedback/feedback_sheet.dart';
import 'app_version.dart';
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
      extendBodyBehindAppBar: LiquidGlass.isCupertino(context),
      appBar: KaatoAppBar(
        title: Text(l10n.settings),
        leading: homeLeading(context),
      ),
      // Top inset by hand (the bar is transparent on iOS and content
      // scrolls beneath it; the body's MediaQuery carries the bar height);
      // SafeArea keeps the bottom clear of the home indicator since an
      // explicit padding disables the automatic inset.
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: KaatoLayout.maxContent),
            child: Builder(
              builder: (context) => ListView(
                padding: EdgeInsets.fromLTRB(
                  KaatoSpacing.lg,
                  MediaQuery.paddingOf(context).top + KaatoSpacing.lg,
                  KaatoSpacing.lg,
                  KaatoSpacing.lg,
                ),
                children: [
                  SettingsSection(
                    title: l10n.settingsAppearance,
                    children: [
                      SettingsChoiceTile(
                        icon: Icons.brightness_6_outlined,
                        title: l10n.theme,
                        below: AdaptiveChoice<ThemeMode>(
                          options: [
                            ChoiceOption(
                              value: ThemeMode.system,
                              label: l10n.systemDefault,
                            ),
                            ChoiceOption(
                              value: ThemeMode.light,
                              label: l10n.themeLight,
                            ),
                            ChoiceOption(
                              value: ThemeMode.dark,
                              label: l10n.themeDark,
                            ),
                          ],
                          selected: ref.watch(themeModeProvider),
                          onSelected: ref.read(themeModeProvider.notifier).set,
                        ),
                      ),
                      SettingsChoiceTile(
                        icon: Icons.language,
                        title: l10n.language,
                        below: SelectField<String>(
                          value: locale?.languageCode ?? '',
                          semanticLabel: l10n.language,
                          onChanged: (code) => ref
                              .read(localeControllerProvider.notifier)
                              .set(code.isEmpty ? null : Locale(code)),
                          options: [
                            ChoiceOption(value: '', label: l10n.systemDefault),
                            for (final entry in _languageNames.entries)
                              ChoiceOption(
                                value: entry.key,
                                label: entry.value,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.settingsDuringPlay,
                    children: [
                      SettingsSwitchTile(
                        icon: Icons.vibration,
                        title: l10n.haptics,
                        value: ref.watch(hapticsEnabledProvider),
                        onChanged: ref
                            .read(hapticsEnabledProvider.notifier)
                            .set,
                      ),
                      SettingsSwitchTile(
                        icon: Icons.visibility_outlined,
                        title: l10n.keepAwake,
                        value: ref.watch(keepAwakeProvider),
                        onChanged: ref.read(keepAwakeProvider.notifier).set,
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.settingsLearn,
                    children: [
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
                  SettingsSection(
                    title: l10n.feedbackSection,
                    children: [
                      SettingsNavTile(
                        icon: Icons.rate_review_outlined,
                        title: l10n.feedbackGive,
                        subtitle: l10n.feedbackGiveSubtitle,
                        onTap: () async {
                          final result = await showFeedbackSheet(
                            context,
                            trigger: FeedbackTrigger.settings,
                          );
                          if (result?.storeReview ?? false) {
                            await ref
                                .read(feedbackControllerProvider.notifier)
                                .requestStoreReview();
                          }
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.settingsAbout,
                    children: [
                      SettingsNavTile(
                        icon: Icons.description_outlined,
                        title: l10n.licensesLabel,
                        onTap: () => showLicensePage(
                          context: context,
                          applicationName: l10n.appTitle,
                          applicationVersion: ref
                              .read(appVersionProvider)
                              .value
                              ?.short,
                        ),
                      ),
                      // TEMPORARY: design review.
                      SettingsNavTile(
                        icon: Icons.palette_outlined,
                        title: l10n.designSystemLabel,
                        onTap: () => context.push('/designsystem'),
                      ),
                    ],
                  ),
                  const _VersionFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Version 0.2.0 (2), commit abc1234" under the last section: which
/// build is on this device. Long-press selects it for a bug report.
class _VersionFooter extends ConsumerWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final version = ref.watch(appVersionProvider).value;
    if (version == null) return const SizedBox.shrink();
    final text = version.commit.isEmpty
        ? l10n.appVersionLabel(version.short)
        : l10n.appVersionWithCommit(version.short, version.commit);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KaatoSpacing.lg),
      child: SelectableText(
        text,
        textAlign: TextAlign.center,
        style: KaatoType.caption.copyWith(
          color: scheme.onSurface.withValues(alpha: KaatoAlpha.faded),
        ),
      ),
    );
  }
}
