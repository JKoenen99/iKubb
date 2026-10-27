import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'form_cards.dart';
import 'section_header.dart';

/// Settings rows in the card language of the New game redesign: a titled
/// group of quiet cards, each with one control (chevron, switch, or a
/// control placed below the label).

/// A titled group of settings rows (HIG grouped-list pattern).
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: KaatoSpacing.lg,
            bottom: KaatoSpacing.sm,
          ),
          child: SectionHeader(title),
        ),
        ...children,
      ],
    );
  }
}

/// A navigation row: icon, title, optional subtitle, disclosure chevron.
class SettingsNavTile extends StatelessWidget {
  const SettingsNavTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SettingCard(
      leading: Icon(icon),
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}

/// A toggle row (platform-adaptive switch).
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchCard(
      leading: Icon(icon),
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
    );
  }
}

/// A row whose control doesn't fit the trailing slot: label on top, the
/// control right below, one card.
class SettingsChoiceTile extends StatelessWidget {
  const SettingsChoiceTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.below,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: KaatoSpacing.md),
              Expanded(child: FormLabel(title: title)),
              ?trailing,
            ],
          ),
          if (below != null) ...[
            const SizedBox(height: KaatoSpacing.md),
            below!,
          ],
        ],
      ),
    );
  }
}
