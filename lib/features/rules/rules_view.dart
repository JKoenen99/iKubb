import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import '../game/game_mode.dart';
import '../kubb/kubb_controller.dart';
import 'rule_illustrations.dart';
import 'rules_content.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';

/// Opens the rules reference as a slide-over panel — reachable from any
/// screen so nobody leaves a game to settle an argument (SPEC.md §3.6).
/// [categoryId] deep-links to a category, arriving with it expanded.
/// [mode] opens the panel on that game's rule set; without it the panel
/// opens on the last-played mode, so it always matches the game at hand.
Future<void> showRulesPanel(
  BuildContext context, {
  String? categoryId,
  GameMode? mode,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: IKubbLayout.maxPanel),
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.4,
      builder: (context, scrollController) => RulesView(
        scrollController: scrollController,
        initialCategoryId: categoryId,
        initialMode: mode,
      ),
    ),
  );
}

/// The categorized rules reference for both game modes. Progressive
/// disclosure throughout: collapsed category rows → short rule cards →
/// edge-case details. Search flattens everything into matching cards
/// only — across BOTH modes, tagged so "king" and "overshoot" never mix.
class RulesView extends ConsumerStatefulWidget {
  const RulesView({
    super.key,
    this.scrollController,
    this.initialCategoryId,
    this.initialMode,
  });

  final ScrollController? scrollController;
  final String? initialCategoryId;
  final GameMode? initialMode;

  @override
  ConsumerState<RulesView> createState() => _RulesViewState();
}

class _RulesViewState extends ConsumerState<RulesView> {
  String _query = '';
  GameMode? _modeOverride;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mode =
        _modeOverride ??
        widget.initialMode ??
        ref.watch(lastModeProvider) ??
        GameMode.numberKubb;
    var categories = mode == GameMode.classicKubb
        ? buildKubbRulesContent(l10n)
        : buildRulesContent(l10n);
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
        ? const <(GameMode, RuleCard)>[]
        : [
            for (final cat in buildRulesContent(l10n))
              ...cat.cards.where(matches).map((c) => (GameMode.numberKubb, c)),
            for (final cat in buildKubbRulesContent(l10n))
              ...cat.cards.where(matches).map((c) => (GameMode.classicKubb, c)),
          ];

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(
        IKubbSpacing.lg,
        IKubbSpacing.sm,
        IKubbSpacing.lg,
        IKubbSpacing.xl,
      ),
      children: [
        SegmentedButton<GameMode>(
          segments: [
            ButtonSegment(
              value: GameMode.numberKubb,
              label: Text(l10n.modeNumber),
            ),
            ButtonSegment(
              value: GameMode.classicKubb,
              label: Text(l10n.modeKubb),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (s) => setState(() => _modeOverride = s.first),
        ),
        const SizedBox(height: IKubbSpacing.md),
        TextField(
          decoration: InputDecoration(
            hintText: l10n.rulesSearchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(IKubbRadius.lg),
            ),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: IKubbSpacing.md),
        _ActiveRulesChips(
          values: mode == GameMode.classicKubb
              ? _kubbRuleChips(ref.watch(kubbControllerProvider).rules, l10n)
              : _numberRuleChips(ref.watch(gameControllerProvider).rules, l10n),
        ),
        const SizedBox(height: IKubbSpacing.sm),
        if (query.isNotEmpty) ...[
          if (searchResults.isEmpty)
            Padding(
              padding: const EdgeInsets.all(IKubbSpacing.xl),
              child: Text(l10n.rulesNoResults, textAlign: TextAlign.center),
            )
          else
            for (final (cardMode, card) in searchResults)
              _RuleCardTile(
                card: card,
                modeLabel: cardMode == GameMode.classicKubb
                    ? l10n.modeKubb
                    : l10n.modeNumber,
              ),
        ] else
          for (final category in categories)
            ExpansionTile(
              key: PageStorageKey(category.id),
              leading: Icon(
                category.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(category.title, style: IKubbType.strong),
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
/// game being played. Both modes feed the same chip strip.
List<String> _numberRuleChips(GameRules rules, AppLocalizations l10n) {
  final policyLabel = switch (rules.overshootPolicy) {
    OvershootPolicy.resetToFixed => l10n.policyReset(
      rules.overshootResetValue,
    ),
    OvershootPolicy.resetToHalfTarget =>
      '${l10n.policyHalf} (${rules.overshootResult()})',
    OvershootPolicy.none => l10n.policyNone,
  };
  return [
    '${l10n.targetScore}: ${rules.targetScore}',
    policyLabel,
    rules.eliminationEnabled
        ? '${l10n.eliminationRule}: ${rules.missLimit}'
        : '${l10n.eliminationRule}: —',
  ];
}

List<String> _kubbRuleChips(KubbRules rules, AppLocalizations l10n) {
  final clock = rules.turnClockSeconds;
  return [
    rules.bestOf > 1 ? l10n.bestOfThree : l10n.bestOfSingle,
    '${l10n.turnClockLabel}: ${clock == null ? l10n.offLabel : '${clock}s'}',
  ];
}

class _ActiveRulesChips extends StatelessWidget {
  const _ActiveRulesChips({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: IKubbSpacing.sm,
      runSpacing: IKubbSpacing.xs,
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
  const _RuleCardTile({required this.card, this.modeLabel});

  final RuleCard card;

  /// Shown on search results, where both modes mix.
  final String? modeLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(vertical: IKubbSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(IKubbSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (modeLabel != null)
              Padding(
                padding: const EdgeInsets.only(bottom: IKubbSpacing.sm),
                child: Chip(
                  label: Text(modeLabel!),
                  visualDensity: VisualDensity.compact,
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            if (ruleIllustration(card.id) case final illustration?)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: IKubbSpacing.md,
                  top: IKubbSpacing.xxs,
                ),
                child: Center(child: illustration),
              ),
            Text(card.title, style: IKubbType.strong),
            const SizedBox(height: IKubbSpacing.xs),
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
                        padding: const EdgeInsets.only(bottom: IKubbSpacing.sm),
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
