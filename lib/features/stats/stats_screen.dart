import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/palette.dart';
import '../../widgets/viking_mascot.dart';
import 'game_records_repository.dart';
import 'stats.dart';

/// Player statistics and game history (SPEC.md §3.5), computed by
/// replaying the stored throw logs through the engine.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final history = ref.watch(gameHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.stats)),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (games) {
          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const VikingMascot(size: 120),
                  const SizedBox(height: 16),
                  Text(l10n.noGamesYet),
                ],
              ),
            );
          }
          final players = aggregateStats(games).values.toList()
            ..sort((a, b) => b.wins.compareTo(a.wins));
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionHeader(l10n.players),
                  for (final stats in players) _PlayerCard(stats: stats),
                  const SizedBox(height: 16),
                  _SectionHeader(l10n.historyTitle),
                  for (final finished in games) _HistoryTile(finished: finished),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      );
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({required this.stats});

  final PlayerStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final chips = <(String, String)>[
      (l10n.gamesPlayed, '${stats.games}'),
      (l10n.wins, '${stats.wins}'),
      (l10n.winRate, '${(stats.winRate * 100).round()}%'),
      (l10n.avgPerThrow, stats.avgPerThrow.toStringAsFixed(1)),
      if (stats.favoritePin != null)
        (l10n.mostHitPin, '${stats.favoritePin}'),
      (l10n.statMisses, '${stats.misses}'),
      if (stats.overshoots > 0) (l10n.statOvershoots, '${stats.overshoots}'),
      if (stats.eliminations > 0)
        (l10n.statEliminations, '${stats.eliminations}'),
    ];
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stats.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                for (final (label, value) in chips)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary)),
                      Text(label,
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.finished});

  final FinishedGame finished;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final game = finished.game;
    final summary = game.sideStates
        .map((s) => '${s.side.name} ${s.score}')
        .join('  ·  ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.emoji_events, color: IKubbPalette.oak),
      title: Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${DateFormat.yMMMd(locale).add_Hm().format(finished.finishedAt)}'
        '  —  ${game.winner?.name ?? ''}',
      ),
    );
  }
}
