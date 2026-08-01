import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/section_header.dart';
import '../../theme/palette.dart';
import '../../widgets/viking_mascot.dart';
import '../game/game_mode.dart';
import 'game_records_repository.dart';
import 'stats.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../../widgets/confirm_dialog.dart';
import 'package:go_router/go_router.dart';

/// Player statistics and game history (SPEC.md §3.5), computed by
/// replaying the stored logs through the engine. One evening, one log:
/// both modes mix chronologically in the history (filterable), while a
/// player card shares only what is honestly comparable — games, wins,
/// win rate — and keeps each mode's own numbers in its own section.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  GameMode? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final history = ref.watch(gameHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stats),
        leading: homeLeading(context),
        actions: [
          if (history.value?.isNotEmpty ?? false)
            IconButton(
              tooltip: l10n.clearHistory,
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _confirmClearHistory(context, ref, l10n),
            ),
        ],
      ),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VikingMascot(pose: MascotPose.oops, size: 120),
              const SizedBox(height: IKubbSpacing.lg),
              Text(l10n.statsErrorBody),
              const SizedBox(height: IKubbSpacing.md),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(gameHistoryProvider),
                child: Text(l10n.retryLabel),
              ),
            ],
          ),
        ),
        data: (games) {
          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const VikingMascot(size: 120),
                  const SizedBox(height: IKubbSpacing.lg),
                  Text(l10n.noGamesYet),
                  const SizedBox(height: IKubbSpacing.lg),
                  FilledButton(
                    onPressed: () => context.push('/setup'),
                    child: Text(l10n.newGame),
                  ),
                ],
              ),
            );
          }
          final molkky = aggregateStats(games);
          final kubb = aggregateKubbStats(games);
          final names = {...molkky.keys, ...kubb.keys}.toList()
            ..sort((a, b) {
              int wins(String n) =>
                  (molkky[n]?.wins ?? 0) + (kubb[n]?.matchWins ?? 0);
              return wins(b).compareTo(wins(a));
            });
          final hasBothModes =
              games.any((g) => g.isKubb) && games.any((g) => !g.isKubb);
          final filtered = [
            for (final g in games)
              if (_filter == null ||
                  (_filter == GameMode.classicKubb) == g.isKubb)
                g,
          ];
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: IKubbLayout.maxPanel),
              child: ListView(
                padding: const EdgeInsets.all(IKubbSpacing.lg),
                children: [
                  SectionHeader(l10n.players, padded: true),
                  for (final name in names)
                    _PlayerCard(
                      name: name,
                      molkky: molkky[name],
                      kubb: kubb[name],
                      showSections: hasBothModes,
                    ),
                  const SizedBox(height: IKubbSpacing.lg),
                  SectionHeader(l10n.historyTitle, padded: true),
                  if (hasBothModes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: IKubbSpacing.sm),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          for (final (label, value) in [
                            (l10n.filterAll, null),
                            (l10n.modeNumber, GameMode.numberKubb),
                            (l10n.modeKubb, GameMode.classicKubb),
                          ])
                            FilterChip(
                              label: Text(label),
                              selected: _filter == value,
                              onSelected: (_) =>
                                  setState(() => _filter = value),
                            ),
                        ],
                      ),
                    ),
                  for (final finished in filtered)
                    Dismissible(
                      key: ValueKey(finished.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: IKubbSpacing.lg),
                        decoration: BoxDecoration(
                          color: IKubbPalette.berry,
                          borderRadius: BorderRadius.circular(IKubbRadius.md),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: IKubbPalette.birchLight,
                        ),
                      ),
                      onDismissed: (_) async {
                        await ref
                            .read(gameRecordsRepositoryProvider)
                            .deleteFinished(finished.id);
                        ref.invalidate(gameHistoryProvider);
                      },
                      child: _HistoryTile(
                        finished: finished,
                        onDelete: () async {
                          final confirmed = await confirmAdaptive(
                            context,
                            title: l10n.deleteGameLabel,
                            body: l10n.deleteGameConfirmBody,
                            confirmLabel: l10n.delete,
                            isDestructive: true,
                          );
                          if (!confirmed) return;
                          await ref
                              .read(gameRecordsRepositoryProvider)
                              .deleteFinished(finished.id);
                          ref.invalidate(gameHistoryProvider);
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> _confirmClearHistory(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  final confirmed = await confirmAdaptive(
    context,
    title: l10n.clearHistory,
    body: l10n.clearHistoryConfirmBody,
    confirmLabel: l10n.delete,
    isDestructive: true,
  );
  if (confirmed) {
    await ref.read(gameRecordsRepositoryProvider).clearHistory();
    ref.invalidate(gameHistoryProvider);
  }
}

/// One card per name. The header carries what both modes can honestly
/// share (games, wins, win rate); the mode sections never mix numbers.
class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.name,
    this.molkky,
    this.kubb,
    required this.showSections,
  });

  final String name;
  final PlayerStats? molkky;
  final KubbSideStats? kubb;

  /// Section labels only earn their space once both modes have history.
  final bool showSections;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final games = (molkky?.games ?? 0) + (kubb?.matches ?? 0);
    final wins = (molkky?.wins ?? 0) + (kubb?.matchWins ?? 0);
    final header = <(String, String)>[
      (l10n.gamesPlayed, '$games'),
      (l10n.wins, '$wins'),
      (l10n.winRate, '${games == 0 ? 0 : (wins / games * 100).round()}%'),
    ];
    final numberChips = <(String, String)>[
      if (molkky case final m?) ...[
        (l10n.avgPerThrow, m.avgPerThrow.toStringAsFixed(1)),
        if (m.favoritePin != null) (l10n.mostHitPin, '${m.favoritePin}'),
        (l10n.statMisses, '${m.misses}'),
        if (m.overshoots > 0) (l10n.statOvershoots, '${m.overshoots}'),
        if (m.eliminations > 0) (l10n.statEliminations, '${m.eliminations}'),
      ],
    ];
    final kubbChips = <(String, String)>[
      if (kubb case final k?) ...[
        (l10n.statKingsFelled, '${k.kingsFelled}'),
        (l10n.statKubbsPerBaton, k.kubbsPerBaton.toStringAsFixed(1)),
        if (k.advantageTurns > 0)
          (l10n.statAdvantageTurns, '${k.advantageTurns}'),
        if (k.earlyKings > 0) (l10n.statEarlyKings, '${k.earlyKings}'),
      ],
    ];
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(vertical: IKubbSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(IKubbSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: IKubbType.cardTitle),
            const SizedBox(height: IKubbSpacing.sm),
            _ChipWrap(chips: header),
            if (numberChips.isNotEmpty) ...[
              if (showSections) _ModeLabel(l10n.modeNumber),
              const SizedBox(height: IKubbSpacing.sm),
              _ChipWrap(chips: numberChips),
            ],
            if (kubbChips.isNotEmpty) ...[
              if (showSections) _ModeLabel(l10n.modeKubb),
              const SizedBox(height: IKubbSpacing.sm),
              _ChipWrap(chips: kubbChips),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModeLabel extends StatelessWidget {
  const _ModeLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: IKubbSpacing.md),
    child: Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.chips});

  final List<(String, String)> chips;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        for (final (label, value) in chips)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: IKubbType.statValue.copyWith(color: scheme.primary),
              ),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.finished, required this.onDelete});

  final FinishedGame finished;

  /// Accessible alternative to the swipe gesture (WCAG 2.5.7): exposed
  /// as a long-press and as a semantic action.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final game = finished.game;
    final kubb = finished.kubbMatch;
    final summary = game != null
        ? game.sideStates.map((s) => '${s.side.name} ${s.score}').join('  ·  ')
        : '${kubb!.sides[0].name} ${kubb.wins[0]} – '
              '${kubb.wins[1]} ${kubb.sides[1].name}';
    final winnerName = game?.winner?.name ?? kubb?.matchWinner?.name ?? '';
    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.deleteGameLabel): onDelete,
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          finished.isKubb ? Icons.crop_square : Icons.emoji_events,
          color: IKubbPalette.oak,
        ),
        title: Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${DateFormat.yMMMd(locale).add_Hm().format(finished.finishedAt)}'
          '  —  $winnerName',
        ),
        onLongPress: onDelete,
      ),
    );
  }
}
