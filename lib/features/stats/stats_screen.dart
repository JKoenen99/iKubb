import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/home_leading.dart';
import '../../widgets/section_header.dart';
import '../../theme/palette.dart';
import '../../widgets/viking_mascot.dart';
import 'game_records_repository.dart';
import 'stats.dart';
import '../../theme/glass.dart';
import '../../theme/tokens.dart';
import '../../widgets/kaato_app_bar.dart';
import '../../theme/typography.dart';
import '../../widgets/confirm_dialog.dart';

import 'package:go_router/go_router.dart';

/// Player statistics and game history (SPEC.md §3.5), computed by
/// replaying the stored logs through the engine.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  /// Ids swiped away but not yet removed from storage: a dismissed
  /// Dismissible must leave the tree in the same frame.
  final Set<String> _dismissed = {};

  Future<void> _delete(String id) async {
    setState(() => _dismissed.add(id));
    await ref.read(gameRecordsRepositoryProvider).deleteFinished(id);
    ref.invalidate(gameHistoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final history = ref.watch(gameHistoryProvider);
    return Scaffold(
      extendBodyBehindAppBar: LiquidGlass.isCupertino(context),
      appBar: KaatoAppBar(
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
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VikingMascot(pose: MascotPose.oops, size: 120),
              const SizedBox(height: KaatoSpacing.lg),
              Text(l10n.statsErrorBody),
              const SizedBox(height: KaatoSpacing.md),
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
                  const SizedBox(height: KaatoSpacing.lg),
                  Text(l10n.noGamesYet),
                  const SizedBox(height: KaatoSpacing.lg),
                  FilledButton(
                    onPressed: () => context.push('/setup'),
                    child: Text(l10n.newGame),
                  ),
                ],
              ),
            );
          }
          final stats = aggregateStats(games);
          final names = stats.keys.toList()
            ..sort((a, b) => stats[b]!.wins.compareTo(stats[a]!.wins));
          final visible = [
            for (final g in games)
              if (!_dismissed.contains(g.id)) g,
          ];
          // SafeArea: the explicit ListView padding disables the automatic
          // inset, so the last history row would hide under the home bar.
          return SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: KaatoLayout.maxPanel,
                ),
                child: Builder(
                  builder: (context) => ListView(
                    padding: EdgeInsets.fromLTRB(
                      KaatoSpacing.lg,
                      MediaQuery.paddingOf(context).top + KaatoSpacing.lg,
                      KaatoSpacing.lg,
                      KaatoSpacing.lg,
                    ),
                    children: [
                      SectionHeader(l10n.players, padded: true),
                      for (final name in names)
                        _PlayerCard(stats: stats[name]!),
                      const SizedBox(height: KaatoSpacing.lg),
                      SectionHeader(l10n.historyTitle, padded: true),
                      for (final finished in visible)
                        Dismissible(
                          key: ValueKey(finished.id),
                          direction: DismissDirection.endToStart,
                          // Swipe and long-press share one destructive confirm
                          // (HIG: destructive actions need consent or undo).
                          confirmDismiss: (_) => confirmAdaptive(
                            context,
                            title: l10n.deleteGameLabel,
                            body: l10n.deleteGameConfirmBody,
                            confirmLabel: l10n.delete,
                            isDestructive: true,
                          ),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              right: KaatoSpacing.lg,
                            ),
                            decoration: BoxDecoration(
                              color: KaatoPalette.berry,
                              borderRadius: BorderRadius.circular(
                                KaatoRadius.md,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: KaatoPalette.birchLight,
                            ),
                          ),
                          onDismissed: (_) => _delete(finished.id),
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
                              await _delete(finished.id);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
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

/// One card per name: games, wins and win rate, then the scoring
/// numbers.
class _PlayerCard extends StatelessWidget {
  const _PlayerCard({required this.stats});

  final PlayerStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final m = stats;
    final header = <(String, String)>[
      (l10n.gamesPlayed, '${m.games}'),
      (l10n.wins, '${m.wins}'),
      (l10n.winRate, '${(m.winRate * 100).round()}%'),
    ];
    final numberChips = <(String, String)>[
      (l10n.avgPerThrow, m.avgPerThrow.toStringAsFixed(1)),
      if (m.favoritePin != null) (l10n.mostHitPin, '${m.favoritePin}'),
      (l10n.statMisses, '${m.misses}'),
      if (m.overshoots > 0) (l10n.statOvershoots, '${m.overshoots}'),
      if (m.eliminations > 0) (l10n.statEliminations, '${m.eliminations}'),
    ];
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(vertical: KaatoSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(KaatoSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.name, style: KaatoType.cardTitle),
            const SizedBox(height: KaatoSpacing.sm),
            _ChipWrap(chips: header),
            const SizedBox(height: KaatoSpacing.sm),
            _ChipWrap(chips: numberChips),
          ],
        ),
      ),
    );
  }
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
                style: KaatoType.statValue.copyWith(color: scheme.primary),
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
    final summary = game.sideStates
        .map((s) => '${s.side.name} ${s.score}')
        .join(' · ');
    final winnerName = game.winner?.name ?? '';
    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.deleteGameLabel): onDelete,
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          Icons.emoji_events,
          color: KaatoPalette.woodAccent(Theme.of(context).brightness),
        ),
        title: Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${DateFormat.yMMMd(locale).add_Hm().format(finished.finishedAt)}'
          ' · $winnerName',
        ),
        onLongPress: onDelete,
      ),
    );
  }
}
