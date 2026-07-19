import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import 'rule_illustrations.dart';
import 'rules_content.dart';

/// Opens the rules reference as a slide-over panel — reachable from any
/// screen so nobody leaves a game to settle an argument (SPEC.md §3.6).
/// [categoryId] deep-links to a category, arriving with it expanded.
Future<void> showRulesPanel(BuildContext context, {String? categoryId}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 640),
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.4,
      builder: (context, scrollController) => RulesView(
        scrollController: scrollController,
        initialCategoryId: categoryId,
      ),
    ),
  );
}

/// The categorized rules reference. Progressive disclosure throughout:
/// collapsed category rows → short rule cards → edge-case details.
/// Search flattens everything into matching cards only.
class RulesView extends ConsumerStatefulWidget {
  const RulesView({super.key, this.scrollController, this.initialCategoryId});

  final ScrollController? scrollController;
  final String? initialCategoryId;

  @override
  ConsumerState<RulesView> createState() => _RulesViewState();
}

class _RulesViewState extends ConsumerState<RulesView> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = buildRulesContent(l10n);
    final game = ref.watch(gameControllerProvider);
    final query = _query.trim().toLowerCase();

    bool matches(RuleCard c) =>
        c.title.toLowerCase().contains(query) ||
        c.body.toLowerCase().contains(query) ||
        (c.detail?.toLowerCase().contains(query) ?? false);

    final searchResults = query.isEmpty
        ? const <RuleCard>[]
        : [for (final cat in categories) ...cat.cards.where(matches)];

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: l10n.rulesSearchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 12),
        _ActiveRulesChips(rules: game.rules, l10n: l10n),
        const SizedBox(height: 8),
        if (query.isNotEmpty) ...[
          if (searchResults.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.rulesNoResults, textAlign: TextAlign.center),
            )
          else
            for (final card in searchResults) _RuleCardTile(card: card),
        ] else
          for (final category in categories)
            ExpansionTile(
              key: PageStorageKey(category.id),
              leading: Icon(
                category.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                category.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              initiallyExpanded: category.id == widget.initialCategoryId,
              children: [
                for (final card in category.cards) _RuleCardTile(card: card),
              ],
            ),
      ],
    );
  }
}

/// The house rules of the current game, inline — the reference always
/// matches the game being played.
class _ActiveRulesChips extends StatelessWidget {
  const _ActiveRulesChips({required this.rules, required this.l10n});

  final GameRules rules;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final policyLabel = switch (rules.overshootPolicy) {
      OvershootPolicy.resetToFixed =>
        '${l10n.policyReset} ${rules.overshootResult()}',
      OvershootPolicy.resetToHalfTarget =>
        '${l10n.policyHalf} (${rules.overshootResult()})',
      OvershootPolicy.none => l10n.policyNone,
    };
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.activeRulesLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Chip(label: Text('${l10n.targetScore}: ${rules.targetScore}')),
        Chip(label: Text(policyLabel)),
        Chip(
          label: Text(
            rules.eliminationEnabled
                ? '${l10n.eliminationRule}: ${rules.missLimit}'
                : '${l10n.eliminationRule}: —',
          ),
        ),
      ],
    );
  }
}

class _RuleCardTile extends StatelessWidget {
  const _RuleCardTile({required this.card});

  final RuleCard card;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ruleIllustration(card.id) case final illustration?)
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 2),
                child: Center(child: illustration),
              ),
            Text(
              card.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(card.body),
            if (card.detail != null)
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  dense: true,
                  title: Icon(Icons.more_horiz, color: scheme.primary),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(card.detail!),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
