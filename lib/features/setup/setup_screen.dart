import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/glass.dart';
import '../../theme/palette.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/adaptive_choice.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/form_cards.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/ikubb_app_bar.dart';
import '../../widgets/section_header.dart';
import '../game/game_controller.dart';
import '../game/game_mode.dart';
import '../kubb/kubb_controller.dart';
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
    // Starting replaces the running game (either mode) — warn first.
    final active = ref.read(gameControllerProvider);
    final activeKubb = ref.read(kubbControllerProvider);
    final running =
        (active.throws.isNotEmpty && active.winner == null) ||
        (activeKubb.hasEvents && !activeKubb.isFinished);
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
    if (setup.mode == GameMode.classicKubb) {
      ref
          .read(kubbControllerProvider.notifier)
          .newMatch(sides: sides, rules: setup.kubbRules);
      context.go('/kubb');
    } else {
      ref
          .read(gameControllerProvider.notifier)
          .newGame(sides: sides, rules: setup.rules);
      context.go('/game');
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: LiquidGlass.isCupertino(context),
      appBar: IKubbAppBar(
        title: Text(l10n.newGame),
        leading: homeLeading(context),
        actions: [
          IconButton(
            tooltip: l10n.rules,
            // The panel opens on whichever mode is being set up.
            onPressed: () => showRulesPanel(context, mode: setup.mode),
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
                      IKubbSpacing.lg,
                      MediaQuery.paddingOf(context).top + IKubbSpacing.sm,
                      IKubbSpacing.lg,
                      IKubbSpacing.xl,
                    ),
                    // Dragging the list puts the keyboard away (HIG).
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: IKubbLayout.maxWide,
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
    final setup = ref.watch(setupControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(l10n.gameSection, padded: true),
        const _ModeCards(),
        const SizedBox(height: IKubbSpacing.xl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 11, child: _PlayersSection()),
            const SizedBox(width: IKubbSpacing.xxl),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TeamsSection(),
                  const SizedBox(height: IKubbSpacing.xl),
                  if (setup.mode == GameMode.numberKubb)
                    const _HouseRulesSection()
                  else
                    const _KubbOptionsSection(),
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
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdaptiveChoice<GameMode>(
          options: [
            ChoiceOption(value: GameMode.numberKubb, label: l10n.modeNumber),
            ChoiceOption(value: GameMode.classicKubb, label: l10n.modeKubb),
          ],
          selected: setup.mode,
          onSelected: controller.setMode,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: IKubbSpacing.sm),
          child: Text(
            setup.mode == GameMode.numberKubb
                ? l10n.modeNumberHint(setup.targetScore)
                : l10n.modeKubbDesc,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: IKubbAlpha.faded),
            ),
          ),
        ),
        const SizedBox(height: IKubbSpacing.sm),
        const _PlayersSection(compact: true),
        const SizedBox(height: IKubbSpacing.lg),
        const _TeamsSection(compact: true),
        if (setup.mode == GameMode.numberKubb)
          SettingCard(
            title: l10n.houseRules,
            subtitle: houseRulesSummary(l10n, setup),
            onTap: () => _showSheet(context, const _HouseRulesSection()),
          )
        else
          SettingCard(
            title: l10n.matchLabel,
            subtitle: kubbSummary(l10n, setup, withMode: false),
            onTap: () => _showSheet(context, const _KubbOptionsSection()),
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
        constraints: const BoxConstraints(maxWidth: IKubbLayout.maxPanel),
        builder: (context) => glassSheet(
          context,
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              IKubbSpacing.lg,
              IKubbSpacing.sm,
              IKubbSpacing.lg,
              IKubbSpacing.xl,
            ),
            child: child,
          ),
        ),
      );
}

// ---------------------------------------------------------------------------
// Sections

/// The game picker: two selection cards side by side.
class _ModeCards extends ConsumerWidget {
  const _ModeCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    // IntrinsicHeight: both cards share the taller one's height, which a
    // stretched Row cannot do inside a scroll view's unbounded height.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ChoiceCard(
              title: l10n.modeNumber,
              subtitle: l10n.modeNumberDesc,
              selected: setup.mode == GameMode.numberKubb,
              onTap: () => controller.setMode(GameMode.numberKubb),
            ),
          ),
          const SizedBox(width: IKubbSpacing.md),
          Expanded(
            child: ChoiceCard(
              title: l10n.modeKubb,
              subtitle: l10n.modeKubbDesc,
              selected: setup.mode == GameMode.classicKubb,
              onTap: () => controller.setMode(GameMode.classicKubb),
            ),
          ),
        ],
      ),
    );
  }
}

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
                  icon: const Icon(Icons.shuffle, size: IKubbIconSize.sm),
                  label: Text(l10n.shuffleOrder),
                ),
        ),
        if (!widget.compact)
          Padding(
            padding: const EdgeInsets.only(bottom: IKubbSpacing.md),
            child: Text(
              l10n.namesOptionalHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: IKubbAlpha.faded),
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
          const SizedBox(height: IKubbSpacing.lg),
          if (widget.compact)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _RecentLabel(l10n.recentLabel),
                const SizedBox(width: IKubbSpacing.md),
                Expanded(child: _RecentChips(setup: setup)),
              ],
            )
          else ...[
            _RecentLabel(l10n.recentLabel),
            const SizedBox(height: IKubbSpacing.sm),
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
          .withValues(alpha: IKubbAlpha.faded),
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
      spacing: IKubbSpacing.sm,
      runSpacing: IKubbSpacing.sm,
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
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: IKubbType.emphasis,
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
          borderRadius: BorderRadius.circular(IKubbRadius.sm),
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
                  style: IKubbType.emphasis,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return FormCard(
      padding: const EdgeInsets.fromLTRB(
        IKubbSpacing.md,
        IKubbSpacing.sm,
        IKubbSpacing.sm,
        IKubbSpacing.sm,
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
          const SizedBox(width: IKubbSpacing.md),
          Expanded(child: name),
          if (widget.teamMode) ...[
            const SizedBox(width: IKubbSpacing.sm),
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
              color: scheme.onSurface.withValues(alpha: IKubbAlpha.faded),
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
    team == Team.a ? IKubbPalette.walnut : IKubbPalette.fjord;

class _TeamsSection extends ConsumerWidget {
  const _TeamsSection({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final forced = setup.mode == GameMode.classicKubb; // kubb = teams
    final desc = setup.teamMode ? l10n.teamsOnDesc : l10n.teamsOffDesc;
    final toggle = Switch.adaptive(
      value: setup.teamMode,
      onChanged: forced ? null : controller.setTeamMode,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compact)
          SettingCard(
            title: l10n.teams,
            subtitle: desc,
            trailing: toggle,
            onTap: forced
                ? null
                : () => controller.setTeamMode(!setup.teamMode),
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
                              .withValues(alpha: IKubbAlpha.faded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: IKubbSpacing.md),
                Padding(
                  padding: const EdgeInsets.only(top: IKubbSpacing.sm),
                  child: toggle,
                ),
              ],
            ),
          ),
        if (setup.teamMode) ...[
          const SizedBox(height: IKubbSpacing.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _TeamCard(team: Team.a, setup: setup),
                ),
                const SizedBox(width: IKubbSpacing.md),
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
              icon: const Icon(Icons.swap_vert, size: IKubbIconSize.sm),
              label: Text(l10n.swapTeams),
            ),
          ),
          if (compact) const SizedBox(height: IKubbSpacing.sm),
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
        color.withValues(alpha: IKubbAlpha.activeTint),
        Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      borderColor: color,
      padding: const EdgeInsets.all(IKubbSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: IKubbType.emphasis.copyWith(
              fontSize: IKubbType.stepChip + 1,
            ),
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            inputFormatters: [LengthLimitingTextInputFormatter(maxNameLength)],
            onChanged: (v) => controller.setTeamName(team, v),
          ),
          const SizedBox(height: IKubbSpacing.xxs),
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

/// Classic-kubb match options on the same cards.
class _KubbOptionsSection extends ConsumerWidget {
  const _KubbOptionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(l10n.matchLabel, padded: true),
        FormCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormLabel(title: l10n.matchLabel),
              const SizedBox(height: IKubbSpacing.sm),
              AdaptiveChoice<int>(
                options: [
                  ChoiceOption(value: 1, label: l10n.bestOfSingle),
                  ChoiceOption(value: 3, label: l10n.bestOfThree),
                ],
                selected: setup.kubbBestOf,
                onSelected: controller.setKubbBestOf,
              ),
            ],
          ),
        ),
        FormCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormLabel(title: l10n.turnClockLabel),
              const SizedBox(height: IKubbSpacing.sm),
              AdaptiveChoice<int>(
                options: [
                  ChoiceOption(value: 0, label: l10n.offLabel),
                  ChoiceOption(value: 30, label: l10n.secondsShort(30)),
                  ChoiceOption(value: 60, label: l10n.secondsShort(60)),
                ],
                selected: setup.kubbClockSeconds ?? 0,
                onSelected: (v) => controller.setKubbClock(v == 0 ? null : v),
              ),
            ],
          ),
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
    final line = setup.mode == GameMode.numberKubb
        ? [
            l10n.modeNumber,
            l10n.summaryFirstTo(setup.targetScore),
            if (setup.teamMode) l10n.summaryInTeams,
          ].join(', ')
        : kubbSummary(l10n, setup);
    final problemText = switch (problem) {
      null => null,
      SetupProblem.needTwoPlayers => l10n.needTwoPlayers,
      SetupProblem.needBothTeams => l10n.needBothTeams,
    };
    final faded = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: scheme.onSurface.withValues(alpha: IKubbAlpha.faded));
    final start = FilledButton.icon(
      onPressed: problem == null ? onStart : null,
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_forward, size: IKubbIconSize.md),
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
                      Text(count, style: IKubbType.emphasis),
                      Text(problemText ?? line, style: faded),
                    ],
                  ),
                ),
                const SizedBox(width: IKubbSpacing.lg),
                start,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: IKubbSpacing.sm),
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

/// "Kubb, best of three, turn clock 60 s" — the match summary.
String kubbSummary(
  AppLocalizations l10n,
  SetupState setup, {
  bool withMode = true,
}) {
  final parts = [
    if (withMode) l10n.modeKubb,
    setup.kubbBestOf > 1 ? l10n.bestOfThree : l10n.bestOfSingle,
    if (setup.kubbClockSeconds case final s?)
      '${l10n.turnClockLabel} ${l10n.secondsShort(s)}',
  ].join(', ');
  return withMode ? parts : parts[0].toUpperCase() + parts.substring(1);
}
