import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_engine/scoring_engine.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/home_leading.dart';
import '../../theme/palette.dart';
import '../game/game_controller.dart';
import '../rules/rules_view.dart';
import 'player.dart';
import 'setup_controller.dart';

/// Game setup (SPEC.md §3.2): players with recent-player recall, team mode,
/// house rules behind progressive disclosure, turn order, start.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  bool _customTarget = false;

  void _start() {
    final l10n = AppLocalizations.of(context)!;
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
    final setup = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final problem = setup.problem;

    final unselectedRecents = [
      for (final r in setup.recents)
        if (!setup.players.any((p) => p.id == r.id)) r,
    ];

    return Scaffold(
      appBar: AppBar(
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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (unselectedRecents.isNotEmpty) ...[
                        _SectionHeader(l10n.recentPlayers),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final player in unselectedRecents)
                              ActionChip(
                                avatar: _Avatar(player: player, size: 24),
                                label: Text(player.name),
                                onPressed: () => controller.addRecent(player),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Expanded(child: _SectionHeader(l10n.players)),
                          IconButton(
                            tooltip: l10n.shuffleOrder,
                            onPressed: setup.players.length < 2
                                ? null
                                : controller.shuffleOrder,
                            icon: const Icon(Icons.shuffle),
                          ),
                        ],
                      ),
                      ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        buildDefaultDragHandles: setup.players.length > 1,
                        onReorderItem: controller.reorder,
                        children: [
                          for (final player in setup.players)
                            _PlayerRow(
                              key: ValueKey(player.id),
                              player: player,
                              teamMode: setup.teamMode,
                              team: setup.teamFor(player),
                              onTeamChanged: (t) =>
                                  controller.assignTeam(player, t),
                              onRemove: () => controller.removePlayer(player),
                            ),
                        ],
                      ),
                      _AddPlayerRow(
                        hint: l10n.playerName,
                        buttonLabel: l10n.addPlayer,
                        onAdd: controller.addPlayer,
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: _SectionHeader(l10n.teams),
                        value: setup.teamMode,
                        onChanged: controller.setTeamMode,
                      ),
                      if (setup.teamMode) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _TeamNameField(
                                hint: l10n.teamA,
                                onChanged: (v) =>
                                    controller.setTeamName(Team.a, v),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TeamNameField(
                                hint: l10n.teamB,
                                onChanged: (v) =>
                                    controller.setTeamName(Team.b, v),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: setup.players.isEmpty
                                ? null
                                : controller.autoBalance,
                            icon: const Icon(Icons.balance),
                            label: Text(l10n.autoBalance),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      _HouseRules(
                        setup: setup,
                        controller: controller,
                        customTarget: _customTarget,
                        onCustomTargetChanged: (v) =>
                            setState(() => _customTarget = v),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: problem == null
                            ? const SizedBox(height: 20)
                            : Padding(
                                key: ValueKey(problem),
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(switch (problem) {
                                  SetupProblem.needTwoPlayers =>
                                    l10n.needTwoPlayers,
                                  SetupProblem.needBothTeams =>
                                    l10n.needBothTeams,
                                }, textAlign: TextAlign.center),
                              ),
                      ),
                      FilledButton(
                        onPressed: problem == null ? _start : null,
                        child: Text(l10n.startGame),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
  );
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.player, this.size = 36});

  final Player player;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: player.color,
      shape: BoxShape.circle,
      // Contrast ring so identity reads on any surface (audit #1).
      border: Border.all(color: IKubbPalette.birchLight, width: 1.5),
    ),
    // TODO(assets): Viking avatar illustrations replace the initial.
    child: Center(
      child: Text(
        player.name.isEmpty ? '?' : player.name[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.45,
        ),
      ),
    ),
  );
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    super.key,
    required this.player,
    required this.teamMode,
    required this.team,
    required this.onTeamChanged,
    required this.onRemove,
  });

  final Player player;
  final bool teamMode;
  final Team team;
  final ValueChanged<Team> onTeamChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _Avatar(player: player),
      title: Text(player.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (teamMode)
            SegmentedButton<Team>(
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              segments: [
                ButtonSegment(value: Team.a, label: Text(l10n.teamA)),
                ButtonSegment(value: Team.b, label: Text(l10n.teamB)),
              ],
              selected: {team},
              onSelectionChanged: (s) => onTeamChanged(s.first),
            ),
          IconButton(onPressed: onRemove, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}

class _AddPlayerRow extends StatefulWidget {
  const _AddPlayerRow({
    required this.hint,
    required this.buttonLabel,
    required this.onAdd,
  });

  final String hint;
  final String buttonLabel;
  final ValueChanged<String> onAdd;

  @override
  State<_AddPlayerRow> createState() => _AddPlayerRowState();
}

class _AddPlayerRowState extends State<_AddPlayerRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onAdd(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: widget.hint),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.tonalIcon(
          onPressed: _submit,
          icon: const Icon(Icons.person_add),
          label: Text(widget.buttonLabel),
        ),
      ],
    );
  }
}

class _TeamNameField extends StatelessWidget {
  const _TeamNameField({required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(hintText: hint),
    onChanged: onChanged,
  );
}

/// House rules behind progressive disclosure: a one-line summary that
/// expands to the full controls (SPEC.md §3.2, §3.6).
class _HouseRules extends StatelessWidget {
  const _HouseRules({
    required this.setup,
    required this.controller,
    required this.customTarget,
    required this.onCustomTargetChanged,
  });

  final SetupState setup;
  final SetupController controller;
  final bool customTarget;
  final ValueChanged<bool> onCustomTargetChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final policyLabel = switch (setup.overshootPolicy) {
      OvershootPolicy.resetToFixed => l10n.policyReset,
      OvershootPolicy.resetToHalfTarget => l10n.policyHalf,
      OvershootPolicy.none => l10n.policyNone,
    };
    final summary = [
      '${l10n.targetScore}: ${setup.targetScore}',
      policyLabel,
      if (setup.eliminationEnabled)
        '${l10n.eliminationRule}: ${setup.missLimit}',
    ].join(' · ');

    final presetTargets = {25, 50, 100};
    final isCustom = customTarget || !presetTargets.contains(setup.targetScore);

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: _SectionHeader(l10n.houseRules),
      subtitle: Text(summary, maxLines: 2, overflow: TextOverflow.ellipsis),
      children: [
        _RuleLabel(l10n.targetScore),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: [
            for (final t in presetTargets)
              ButtonSegment(value: t, label: Text('$t')),
            ButtonSegment(value: -1, label: Text(l10n.custom)),
          ],
          selected: {isCustom ? -1 : setup.targetScore},
          onSelectionChanged: (s) {
            final v = s.first;
            onCustomTargetChanged(v == -1);
            if (v != -1) controller.setTargetScore(v);
          },
        ),
        if (isCustom)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              initialValue: '${setup.targetScore}',
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.custom),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) controller.setTargetScore(parsed);
              },
            ),
          ),
        _RuleLabel(l10n.overshootRule),
        SegmentedButton<OvershootPolicy>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: OvershootPolicy.resetToFixed,
              label: Text(l10n.policyReset),
            ),
            ButtonSegment(
              value: OvershootPolicy.resetToHalfTarget,
              label: Text(l10n.policyHalf),
            ),
            ButtonSegment(
              value: OvershootPolicy.none,
              label: Text(l10n.policyNone),
            ),
          ],
          selected: {setup.overshootPolicy},
          onSelectionChanged: (s) => controller.setOvershootPolicy(s.first),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.eliminationRule),
          value: setup.eliminationEnabled,
          onChanged: controller.setElimination,
        ),
        if (setup.eliminationEnabled)
          Row(
            children: [
              Expanded(child: Text(l10n.missLimit)),
              IconButton(
                onPressed: () => controller.setMissLimit(setup.missLimit - 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '${setup.missLimit}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () => controller.setMissLimit(setup.missLimit + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _RuleLabel extends StatelessWidget {
  const _RuleLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}
