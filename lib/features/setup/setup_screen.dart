import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/glass.dart';
import '../../theme/palette.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/form_cards.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/kaato_app_bar.dart';
import '../../widgets/section_header.dart';
import '../game/game_controller.dart';
import '../rules/rules_view.dart';
import 'player.dart';
import 'setup_controller.dart';

/// Longest player or team name the UI lays out for.
const int maxNameLength = 24;

/// Game setup, after the "New game" redesign: the game picker first, then
/// players (names optional, tap to rename, recents as chips), teams as a
/// toggle with two tinted team cards, and house rules as steppers. Wide
/// screens show players beside teams and rules; phones stack them and put
/// the rules behind a disclosure row. A summary bar with the one primary
/// action closes the screen.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  /// Two columns from this width (iPad, landscape phones).
  static const double twoColumnWidth = 720;

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context)!;
    // Starting replaces the running game — warn first.
    final active = ref.read(gameControllerProvider);
    final running = active.throws.isNotEmpty && active.winner == null;
    if (running) {
      final confirmed = await confirmAdaptive(
        context,
        title: l10n.newGameConfirmTitle,
        body: l10n.newGameConfirmBody,
        confirmLabel: l10n.startGame,
        isDestructive: true,
      );
      if (!confirmed || !mounted) return;
    }
    final setup = ref.read(setupControllerProvider);
    final sides = ref
        .read(setupControllerProvider.notifier)
        .buildSides(defaultTeamNames: (l10n.teamA, l10n.teamB));
    if (sides == null) return;
    // Side colors: individuals keep their profile color; a team takes the
    // color of its first player.
    ref
        .read(sideColorsProvider.notifier)
        .set(
          setup.teamMode
              ? {
                  for (final (i, team) in [Team.a, Team.b].indexed)
                    sides[i].id: setup.onTeam(team).first.colorIndex,
                }
              : {for (final p in setup.players) p.id: p.colorIndex},
        );
    ref
        .read(gameControllerProvider.notifier)
        .newGame(sides: sides, rules: setup.rules);
    context.go('/game');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: LiquidGlass.isCupertino(context),
      appBar: KaatoAppBar(
        title: Text(l10n.newGame),
        leading: homeLeading(context),
        actions: [
          IconButton(
            tooltip: l10n.rules,
            onPressed: () => showRulesPanel(context),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= twoColumnWidth;
          return Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) => ListView(
                    padding: EdgeInsets.fromLTRB(
                      KaatoSpacing.lg,
                      MediaQuery.paddingOf(context).top + KaatoSpacing.sm,
                      KaatoSpacing.lg,
                      KaatoSpacing.xl,
                    ),
                    // Dragging the list puts the keyboard away (HIG).
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: KaatoLayout.maxWide,
                          ),
                          child: wide
                              ? const _WideLayout()
                              : const _PhoneLayout(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _SummaryBar(wide: wide, onStart: _start),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Layouts

class _WideLayout extends ConsumerWidget {
  const _WideLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 11, child: _PlayersSection()),
            const SizedBox(width: KaatoSpacing.xxl),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TeamsSection(),
                  const SizedBox(height: KaatoSpacing.xl),
                  const _HouseRulesSection(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PhoneLayout extends ConsumerWidget {
  const _PhoneLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PlayersSection(compact: true),
        const SizedBox(height: KaatoSpacing.lg),
        const _TeamsSection(compact: true),
        SettingCard(
          title: l10n.houseRules,
          subtitle: houseRulesSummary(l10n, setup),
          onTap: () => _showSheet(context, const _HouseRulesSection()),
        ),
      ],
    );
  }

  Future<void> _showSheet(BuildContext context, Widget child) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: !LiquidGlass.isCupertino(context),
        constraints: const BoxConstraints(maxWidth: KaatoLayout.maxPanel),
        builder: (context) => glassSheet(
          context,
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              KaatoSpacing.lg,
              KaatoSpacing.sm,
              KaatoSpacing.lg,
              KaatoSpacing.xl,
            ),
            child: child,
          ),
        ),
      );
}

// ---------------------------------------------------------------------------
// Sections

class _PlayersSection extends ConsumerStatefulWidget {
  const _PlayersSection({this.compact = false});

  /// Phone: an icon for shuffle, recents inline with their label.
  final bool compact;

  @override
  ConsumerState<_PlayersSection> createState() => _PlayersSectionState();
}

class _PlayersSectionState extends ConsumerState<_PlayersSection> {
  String? _editingId;

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final canShuffle = setup.players.length >= 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          l10n.players,
          padded: true,
          detail: widget.compact
              ? '${setup.players.length}'
              : l10n.playersCount(setup.players.length),
          trailing: widget.compact
              ? IconButton(
                  tooltip: l10n.shuffleOrder,
                  onPressed: canShuffle ? controller.shuffleOrder : null,
                  icon: const Icon(Icons.shuffle),
                )
              : TextButton.icon(
                  onPressed: canShuffle ? controller.shuffleOrder : null,
                  icon: const Icon(Icons.shuffle, size: KaatoIconSize.sm),
                  label: Text(l10n.shuffleOrder),
                ),
        ),
        if (!widget.compact)
          Padding(
            padding: const EdgeInsets.only(bottom: KaatoSpacing.md),
            child: Text(
              l10n.namesOptionalHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: KaatoAlpha.faded),
              ),
            ),
          ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: controller.reorder,
          children: [
            for (final (i, player) in setup.players.indexed)
              _PlayerRow(
                key: ValueKey(player.id),
                index: i,
                player: player,
                teamMode: setup.teamMode,
                team: setup.teamFor(player),
                editing: _editingId == player.id,
                onEdit: () => setState(() => _editingId = player.id),
                onRenamed: (name) {
                  controller.renamePlayer(player, name);
                  setState(() => _editingId = null);
                },
                onTeamTap: () => controller.assignTeam(
                  player,
                  setup.teamFor(player) == Team.a ? Team.b : Team.a,
                ),
                onRemove: () => controller.removePlayer(player),
              ),
          ],
        ),
        DashedAddButton(
          label: l10n.addPlayer,
          onPressed: () => controller.addAutoPlayer(l10n.playerN),
        ),
        if (setup.recents.isNotEmpty) ...[
          const SizedBox(height: KaatoSpacing.lg),
          if (widget.compact)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _RecentLabel(l10n.recentLabel),
                const SizedBox(width: KaatoSpacing.md),
                Expanded(child: _RecentChips(setup: setup)),
              ],
            )
          else ...[
            _RecentLabel(l10n.recentLabel),
            const SizedBox(height: KaatoSpacing.sm),
            _RecentChips(setup: setup),
          ],
        ],
      ],
    );
  }
}

class _RecentLabel extends StatelessWidget {
  const _RecentLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Theme.of(context).colorScheme.onSurface
          .withValues(alpha: KaatoAlpha.faded),
    ),
  );
}

class _RecentChips extends ConsumerWidget {
  const _RecentChips({required this.setup});

  final SetupState setup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(setupControllerProvider.notifier);
    return Wrap(
      spacing: KaatoSpacing.sm,
      runSpacing: KaatoSpacing.sm,
      children: [
        for (final recent in setup.recents)
          () {
            final picked = setup.players.any((p) => p.id == recent.id);
            return RecentChip(
              name: recent.name,
              color: recent.color,
              initial: recent.avatarLabel,
              dimmed: picked,
              onPressed: picked ? null : () => controller.addRecent(recent),
            );
          }(),
      ],
    );
  }
}

/// One player: avatar (drag handle for reordering), name (tap to rename),
/// team pill in team mode, remove.
class _PlayerRow extends StatefulWidget {
  const _PlayerRow({
    super.key,
    required this.index,
    required this.player,
    required this.teamMode,
    required this.team,
    required this.editing,
    required this.onEdit,
    required this.onRenamed,
    required this.onTeamTap,
    required this.onRemove,
  });

  final int index;
  final Player player;
  final bool teamMode;
  final Team team;
  final bool editing;
  final VoidCallback onEdit;
  final ValueChanged<String> onRenamed;
  final VoidCallback onTeamTap;
  final VoidCallback onRemove;

  @override
  State<_PlayerRow> createState() => _PlayerRowState();
}

class _PlayerRowState extends State<_PlayerRow> {
  TextEditingController? _controller;

  @override
  void didUpdateWidget(covariant _PlayerRow old) {
    super.didUpdateWidget(old);
    if (!widget.editing) {
      _controller?.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final teamLabel = widget.team == Team.a ? l10n.teamA : l10n.teamB;
    final otherLabel = widget.team == Team.a ? l10n.teamB : l10n.teamA;
    final Widget name;
    if (widget.editing) {
      _controller ??= TextEditingController(text: widget.player.name)
        ..selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.player.name.length,
        );
      name = TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: KaatoSpacing.md,
            vertical: KaatoSpacing.sm + KaatoSpacing.xxs,
          ),
        ),
        style: KaatoType.emphasis,
        textCapitalization: TextCapitalization.words,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        inputFormatters: [LengthLimitingTextInputFormatter(maxNameLength)],
        onSubmitted: widget.onRenamed,
        onTapOutside: (_) => widget.onRenamed(_controller!.text),
      );
    } else {
      name = Semantics(
        button: true,
        label: l10n.renamePlayer(widget.player.name),
        child: InkWell(
          borderRadius: BorderRadius.circular(KaatoRadius.sm),
          onTap: widget.onEdit,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ExcludeSemantics(
                child: Text(
                  widget.player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: KaatoType.emphasis,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return FormCard(
      padding: const EdgeInsets.fromLTRB(
        KaatoSpacing.md,
        KaatoSpacing.sm,
        KaatoSpacing.sm,
        KaatoSpacing.sm,
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: widget.index,
            child: AvatarCircle(
              color: widget.player.color,
              label: widget.player.avatarLabel,
            ),
          ),
          const SizedBox(width: KaatoSpacing.md),
          Expanded(child: name),
          if (widget.teamMode) ...[
            const SizedBox(width: KaatoSpacing.sm),
            TintPill(
              label: teamLabel,
              color: teamColor(widget.team),
              semanticLabel: l10n.moveToTeam(widget.player.name, otherLabel),
              onTap: widget.onTeamTap,
            ),
          ],
          IconButton(
            tooltip: l10n.removePlayer(widget.player.name),
            onPressed: widget.onRemove,
            icon: Icon(
              Icons.close,
              color: scheme.onSurface.withValues(alpha: KaatoAlpha.faded),
            ),
          ),
        ],
      ),
    );
  }
}

/// Team identity: warm walnut for A, cool fjord for B — distinct from the
/// player colors so a pill never matches its avatar.
Color teamColor(Team team) =>
    team == Team.a ? KaatoPalette.walnut : KaatoPalette.fjord;

class _TeamsSection extends ConsumerWidget {
  const _TeamsSection({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final desc = setup.teamMode ? l10n.teamsOnDesc : l10n.teamsOffDesc;
    final toggle = Switch.adaptive(
      value: setup.teamMode,
      onChanged: controller.setTeamMode,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compact)
          SettingCard(
            title: l10n.teams,
            subtitle: desc,
            trailing: toggle,
            onTap: () => controller.setTeamMode(!setup.teamMode),
          )
        else
          MergeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(l10n.teams, padded: true),
                      Text(
                        desc,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(alpha: KaatoAlpha.faded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: KaatoSpacing.md),
                Padding(
                  padding: const EdgeInsets.only(top: KaatoSpacing.sm),
                  child: toggle,
                ),
              ],
            ),
          ),
        if (setup.teamMode) ...[
          const SizedBox(height: KaatoSpacing.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _TeamCard(team: Team.a, setup: setup),
                ),
                const SizedBox(width: KaatoSpacing.md),
                Expanded(
                  child: _TeamCard(team: Team.b, setup: setup),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: setup.players.isEmpty ? null : controller.swapTeams,
              icon: const Icon(Icons.swap_vert, size: KaatoIconSize.sm),
              label: Text(l10n.swapTeams),
            ),
          ),
          if (compact) const SizedBox(height: KaatoSpacing.sm),
        ],
      ],
    );
  }
}

/// A tinted team card: editable team name on top, its members below.
class _TeamCard extends ConsumerWidget {
  const _TeamCard({required this.team, required this.setup});

  final Team team;
  final SetupState setup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final color = teamColor(team);
    final hint = team == Team.a ? l10n.teamA : l10n.teamB;
    final members = setup.onTeam(team).map((p) => p.name).join(', ');
    return FormCard(
      margin: EdgeInsets.zero,
      color: Color.alphaBlend(
        color.withValues(alpha: KaatoAlpha.activeTint),
        Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      borderColor: color,
      padding: const EdgeInsets.all(KaatoSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: KaatoSpacing.md,
                vertical: KaatoSpacing.sm + KaatoSpacing.xxs,
              ),
            ),
            style: KaatoType.emphasis.copyWith(
              fontSize: KaatoType.stepChip + 1,
            ),
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            inputFormatters: [LengthLimitingTextInputFormatter(maxNameLength)],
            onChanged: (v) => controller.setTeamName(team, v),
          ),
          const SizedBox(height: KaatoSpacing.xxs),
          Text(
            members.isEmpty ? '—' : members,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// House rules as three steppers with a Reset to the classic sheet.
class _HouseRulesSection extends ConsumerWidget {
  const _HouseRulesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    String off(int v) => v == 0 ? l10n.offLabel : '$v';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          l10n.houseRules,
          padded: true,
          trailing: TextButton(
            onPressed: setup.isClassic ? null : controller.resetHouseRules,
            child: Text(l10n.resetLabel),
          ),
        ),
        StepperCard(
          title: l10n.targetScore,
          subtitle: l10n.targetScoreDesc,
          value: setup.targetScore,
          min: SetupController.minTarget,
          max: SetupController.maxTarget,
          step: 5,
          onChanged: controller.setTargetScore,
          editTitle: l10n.editValueTitle,
          decreaseLabel: l10n.decreaseLabel,
          increaseLabel: l10n.increaseLabel,
          cancelLabel: l10n.cancel,
          doneLabel: l10n.done,
        ),
        StepperCard(
          title: l10n.backToLabel,
          subtitle: l10n.backToDesc,
          value: setup.overshootResetValue,
          min: 0,
          max: setup.targetScore - 1,
          step: 5,
          format: off,
          onChanged: controller.setOvershootReset,
          editTitle: l10n.editValueTitle,
          decreaseLabel: l10n.decreaseLabel,
          increaseLabel: l10n.increaseLabel,
          cancelLabel: l10n.cancel,
          doneLabel: l10n.done,
        ),
        StepperCard(
          title: l10n.eliminationRule,
          subtitle: l10n.eliminationDesc,
          value: setup.missLimit,
          min: 0,
          max: SetupController.maxMissLimit,
          format: off,
          onChanged: controller.setMissLimit,
          decreaseLabel: l10n.decreaseLabel,
          increaseLabel: l10n.increaseLabel,
        ),
      ],
    );
  }
}

/// The closing bar: what will be played, and the one primary action.
class _SummaryBar extends ConsumerWidget {
  const _SummaryBar({required this.wide, required this.onStart});

  final bool wide;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final problem = setup.problem;
    final count = l10n.playersCount(setup.players.length);
    final rules = [
      l10n.summaryFirstTo(setup.targetScore),
      if (setup.teamMode) l10n.summaryInTeams,
    ].join(', ');
    final line = rules[0].toUpperCase() + rules.substring(1);
    final problemText = switch (problem) {
      null => null,
      SetupProblem.needTwoPlayers => l10n.needTwoPlayers,
      SetupProblem.needBothTeams => l10n.needBothTeams,
    };
    final faded = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: scheme.onSurface.withValues(alpha: KaatoAlpha.faded));
    final start = FilledButton.icon(
      onPressed: problem == null ? onStart : null,
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_forward, size: KaatoIconSize.md),
      label: Text(l10n.startGame),
    );
    return BottomActionBar(
      child: wide
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(count, style: KaatoType.emphasis),
                      Text(problemText ?? line, style: faded),
                    ],
                  ),
                ),
                const SizedBox(width: KaatoSpacing.lg),
                start,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: KaatoSpacing.sm),
                  child: Text(
                    problemText ?? '$count, $line',
                    textAlign: TextAlign.center,
                    style: faded,
                  ),
                ),
                start,
              ],
            ),
    );
  }
}

/// "First to 50, back to 25, out after 3 misses" — the house-rules row.
String houseRulesSummary(AppLocalizations l10n, SetupState setup) {
  final parts = [
    l10n.summaryFirstTo(setup.targetScore),
    setup.overshootResetValue == 0
        ? l10n.summaryNoPenalty
        : l10n.summaryBackTo(setup.overshootResetValue),
    setup.missLimit == 0
        ? l10n.summaryNoElimination
        : l10n.summaryOutAfter(setup.missLimit),
  ].join(', ');
  return parts[0].toUpperCase() + parts.substring(1);
}
