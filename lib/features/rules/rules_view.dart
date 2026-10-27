import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import 'rule_illustrations.dart';
import 'rules_content.dart';
import '../../theme/glass.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';

/// Opens the rules reference as a slide-over panel — reachable from any
/// screen so nobody leaves a game to settle an argument (SPEC.md §3.6).
/// [categoryId] deep-links to a category, arriving with it expanded.
Future<void> showRulesPanel(BuildContext context, {String? categoryId}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: KaatoLayout.maxPanel),
    // On iOS the glass sheet draws its own grabber.
    showDragHandle: !LiquidGlass.isCupertino(context),
    builder: (context) => glassSheet(
      context,
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.4,
        builder: (context, scrollController) => RulesView(
          scrollController: scrollController,
          initialCategoryId: categoryId,
        ),
      ),
    ),
  );
}

/// The categorized rules reference. Progressive disclosure throughout:
/// collapsed category rows → short rule cards → edge-case details. Search
/// flattens everything into matching cards only.
class RulesView extends ConsumerStatefulWidget {
  const RulesView({super.key, this.scrollController, this.initialCategoryId});

  final ScrollController? scrollController;
  final String? initialCategoryId;

  @override
  ConsumerState<RulesView> createState() => _RulesViewState();
}

class _RulesViewState extends ConsumerState<RulesView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var categories = buildRulesContent(l10n);
    // A deep-linked category leads the list: it arrives expanded AND
    // in view, so the answer is on screen before anyone scrolls.
    if (widget.initialCategoryId case final target?) {
      categories = [
        for (final c in categories)
          if (c.id == target) c,
        for (final c in categories)
          if (c.id != target) c,
      ];
    }
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
      // Full-screen the bar is transparent on iOS: start below it. In the
      // sheet the safe area is already consumed, so this adds nothing.
      padding: EdgeInsets.fromLTRB(
        KaatoSpacing.lg,
        MediaQuery.paddingOf(context).top + KaatoSpacing.sm,
        KaatoSpacing.lg,
        KaatoSpacing.xl,
      ),
      children: [
        TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.rulesSearchHint,
            prefixIcon: const Icon(Icons.search),
            // A clear affordance, also the way out of "no results".
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    tooltip: l10n.clearSearch,
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: KaatoSpacing.md),
        _ActiveRulesChips(
          values: _numberRuleChips(
            ref.watch(gameControllerProvider).rules,
            l10n,
          ),
        ),
        const SizedBox(height: KaatoSpacing.sm),
        if (query.isNotEmpty) ...[
          if (searchResults.isEmpty)
            Padding(
              padding: const EdgeInsets.all(KaatoSpacing.xl),
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
              title: Text(category.title, style: KaatoType.strong),
              initiallyExpanded: category.id == widget.initialCategoryId,
              children: [
                for (final card in category.cards) _RuleCardTile(card: card),
              ],
            ),
      ],
    );
  }
}

/// The active house rules, inline — the reference always matches the
/// game being played.
List<String> _numberRuleChips(GameRules rules, AppLocalizations l10n) {
  final policyLabel = switch (rules.overshootPolicy) {
    OvershootPolicy.resetToFixed => l10n.policyReset(rules.overshootResetValue),
    OvershootPolicy.resetToHalfTarget =>
      '${l10n.policyHalf} (${rules.overshootResult()})',
    OvershootPolicy.none => l10n.policyNone,
  };
  return [
    '${l10n.targetScore}: ${rules.targetScore}',
    policyLabel,
    rules.eliminationEnabled
        ? '${l10n.eliminationRule}: ${rules.missLimit}'
        : '${l10n.eliminationRule}: ${l10n.offLabel}',
  ];
}

class _ActiveRulesChips extends StatelessWidget {
  const _ActiveRulesChips({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: KaatoSpacing.sm,
      runSpacing: KaatoSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.activeRulesLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        for (final value in values) Chip(label: Text(value)),
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
      margin: const EdgeInsets.symmetric(vertical: KaatoSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(KaatoSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Illustrations are decorative: the title and body carry the
            // rule, so VoiceOver skips the drawn numbers and initials.
            if (ruleIllustration(card.id) case final illustration?)
              ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: KaatoSpacing.md,
                    top: KaatoSpacing.xxs,
                  ),
                  child: Center(child: illustration),
                ),
              ),
            Text(card.title, style: KaatoType.strong),
            const SizedBox(height: KaatoSpacing.xs),
            Text(card.body),
            if (card.detail != null)
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  dense: true,
                  // A named control, not a bare icon (HIG / WCAG 4.1.2).
                  title: Text(
                    AppLocalizations.of(context)!.showDetails,
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: scheme.primary),
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: KaatoSpacing.sm),
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
