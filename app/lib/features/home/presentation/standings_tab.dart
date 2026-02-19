import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/team_flag.dart';
import '../domain/standing_model.dart';
import 'providers/standings_providers.dart';

class StandingsTab extends ConsumerWidget {
  const StandingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(standingsProvider);

    return standingsAsync.when(
      loading: () => const AppLoadingIndicator(message: 'Loading standings...'),
      error: (error, _) => AppErrorWidget(
        message: 'Could not load standings.\n$error',
        onRetry: () => ref.invalidate(standingsProvider),
      ),
      data: (groups) {
        if (groups.isEmpty) {
          return const AppEmptyState(
            icon: Icons.table_chart,
            title: 'No standings available',
            subtitle: 'Standings will appear once the tournament begins.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(standingsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: groups.length,
            itemBuilder: (context, index) =>
                _GroupTable(group: groups[index]),
          ),
        );
      },
    );
  }
}

class _GroupTable extends StatelessWidget {
  const _GroupTable({required this.group});

  final GroupStanding group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.md,
              ),
              child: Text(
                group.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(28),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(28),
                3: FixedColumnWidth(28),
                4: FixedColumnWidth(28),
                5: FixedColumnWidth(28),
                6: FixedColumnWidth(34),
                7: FixedColumnWidth(32),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header
                TableRow(
                  children: [
                    _headerCell('#'),
                    _headerCell('Team'),
                    _headerCell('P'),
                    _headerCell('W'),
                    _headerCell('D'),
                    _headerCell('L'),
                    _headerCell('GD'),
                    _headerCell('Pts'),
                  ],
                ),
                // Team rows
                ...group.teams.map((entry) => TableRow(
                      decoration: entry.rank <= 2
                          ? BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.05),
                            )
                          : null,
                      children: [
                        _cell('${entry.rank}'),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              TeamFlag(logoUrl: entry.team.logo, size: 20),
                              const SizedBox(width: AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  entry.team.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _cell('${entry.played}'),
                        _cell('${entry.won}'),
                        _cell('${entry.drawn}'),
                        _cell('${entry.lost}'),
                        _cell('${entry.goalDiff > 0 ? '+' : ''}${entry.goalDiff}'),
                        _boldCell('${entry.points}'),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _boldCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
