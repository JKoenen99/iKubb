import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// One rule: a short scannable card, with edge cases behind [detail]
/// (second level of disclosure) and an optional pin-formation diagram.
class RuleCard {
  const RuleCard({
    required this.id,
    required this.title,
    required this.body,
    this.detail,
  });

  final String id;
  final String title;
  final String body;
  final String? detail;
}

/// A collapsed category row: icon + title, expanding to its rule cards.
class RuleCategory {
  const RuleCategory({
    required this.id,
    required this.icon,
    required this.title,
    required this.cards,
  });

  final String id;
  final IconData icon;
  final String title;
  final List<RuleCard> cards;
}

/// Category ids used for contextual deep links from the game screen.
abstract final class RuleCategoryIds {
  static const setup = 'setup';
  static const throwing = 'throwing';
  static const scoring = 'scoring';
  static const overshoot = 'overshoot';
  static const misses = 'misses';
  static const winning = 'winning';
  static const teams = 'teams';
}

/// The full, categorized rules reference (SPEC.md §3.6). One source of
/// truth: the onboarding tour will reuse this same content.
List<RuleCategory> buildRulesContent(AppLocalizations l10n) => [
  RuleCategory(
    id: RuleCategoryIds.setup,
    icon: Icons.grid_view_rounded,
    title: l10n.catSetup,
    cards: [
      RuleCard(
        id: 'formation',
        title: l10n.ruleFormationTitle,
        body: l10n.ruleFormationBody,
      ),
      RuleCard(
        id: 'pinsStand',
        title: l10n.rulePinsStandTitle,
        body: l10n.rulePinsStandBody,
      ),
    ],
  ),
  RuleCategory(
    id: RuleCategoryIds.throwing,
    icon: Icons.sports_handball,
    title: l10n.catThrowing,
    cards: [
      RuleCard(
        id: 'turns',
        title: l10n.ruleTurnsTitle,
        body: l10n.ruleTurnsBody,
      ),
      RuleCard(
        id: 'underhand',
        title: l10n.ruleUnderhandTitle,
        body: l10n.ruleUnderhandBody,
      ),
    ],
  ),
  RuleCategory(
    id: RuleCategoryIds.scoring,
    icon: Icons.tag,
    title: l10n.catScoring,
    cards: [
      RuleCard(
        id: 'onePin',
        title: l10n.ruleOnePinTitle,
        body: l10n.ruleOnePinBody,
      ),
      RuleCard(
        id: 'manyPins',
        title: l10n.ruleManyPinsTitle,
        body: l10n.ruleManyPinsBody,
        detail: l10n.ruleManyPinsDetail,
      ),
      RuleCard(
        id: 'leaning',
        title: l10n.ruleLeaningTitle,
        body: l10n.ruleLeaningBody,
      ),
    ],
  ),
  RuleCategory(
    id: RuleCategoryIds.overshoot,
    icon: Icons.u_turn_left,
    title: l10n.catOvershoot,
    cards: [
      RuleCard(
        id: 'overshoot',
        title: l10n.ruleOvershootTitle,
        body: l10n.ruleOvershootBody,
        detail: l10n.ruleOvershootDetail,
      ),
    ],
  ),
  RuleCategory(
    id: RuleCategoryIds.misses,
    icon: Icons.do_not_disturb_on_outlined,
    title: l10n.catMisses,
    cards: [
      RuleCard(
        id: 'misses',
        title: l10n.ruleMissesTitle,
        body: l10n.ruleMissesBody,
        detail: l10n.ruleMissesDetail,
      ),
    ],
  ),
  RuleCategory(
    id: RuleCategoryIds.winning,
    icon: Icons.emoji_events_outlined,
    title: l10n.catWinning,
    cards: [
      RuleCard(
        id: 'exact',
        title: l10n.ruleExactTitle,
        body: l10n.ruleExactBody,
      ),
      RuleCard(
        id: 'lastStanding',
        title: l10n.ruleLastStandingTitle,
        body: l10n.ruleLastStandingBody,
      ),
    ],
  ),
  RuleCategory(
    id: RuleCategoryIds.teams,
    icon: Icons.groups_outlined,
    title: l10n.catTeams,
    cards: [
      RuleCard(
        id: 'teams',
        title: l10n.ruleTeamsTitle,
        body: l10n.ruleTeamsBody,
      ),
    ],
  ),
];
