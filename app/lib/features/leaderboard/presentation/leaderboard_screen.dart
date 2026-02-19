import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/token_formatter.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../domain/leaderboard_entry.dart';
import 'providers/leaderboard_providers.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Global'),
              Tab(text: 'My School'),
              Tab(text: 'By School'),
              Tab(text: 'By State'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PlayerLeaderboardList(provider: globalLeaderboardProvider),
            _PlayerLeaderboardList(provider: schoolLeaderboardProvider),
            _AggregateLeaderboardList(provider: schoolAggregatesProvider, entityLabel: 'School'),
            _AggregateLeaderboardList(provider: stateAggregatesProvider, entityLabel: 'State'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Player Leaderboard (Global / School)
// ---------------------------------------------------------------------------
class _PlayerLeaderboardList extends ConsumerWidget {
  const _PlayerLeaderboardList({required this.provider});

  final FutureProvider<List<LeaderboardEntry>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(provider);
    final currentUid = ref.watch(currentUidProvider);

    return dataAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (error, _) => AppErrorWidget(
        message: 'Could not load leaderboard.',
        onRetry: () => ref.invalidate(provider),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return const AppEmptyState(
            icon: Icons.leaderboard,
            title: 'No rankings yet',
            subtitle: 'Make predictions to climb the leaderboard!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(provider),
          child: CustomScrollView(
            slivers: [
              // Podium for top 3
              if (entries.length >= 3)
                SliverToBoxAdapter(
                  child: _Podium(top3: entries.take(3).toList()),
                ),
              // Column headers
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
                  child: Row(
                    children: const [
                      SizedBox(width: 32),
                      SizedBox(width: 36 + AppSpacing.md), // avatar + gap
                      Expanded(child: Text('Player', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600))),
                      SizedBox(width: 50, child: Text('Win%', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                      SizedBox(width: 50, child: Text('Bold', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                      SizedBox(width: 60, child: Text('Tokens', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
                    ],
                  ),
                ),
              ),
              // Remaining entries
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final startIndex = entries.length >= 3 ? 3 : 0;
                    final entry = entries[startIndex + index];
                    final isCurrentUser = entry.uid == currentUid;

                    return Container(
                      color: isCurrentUser
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Text(
                              '${entry.rank}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: isCurrentUser
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              entry.displayName.isNotEmpty
                                  ? entry.displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.displayName,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: isCurrentUser
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  entry.school,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              '${entry.winRate.toStringAsFixed(0)}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: entry.winRate >= 60
                                    ? AppColors.success
                                    : entry.winRate >= 40
                                        ? AppColors.textSecondary
                                        : AppColors.lost,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              '${entry.boldness.toStringAsFixed(0)}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: entry.boldness >= 70
                                    ? AppColors.secondary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              TokenFormatter.format(entry.tokens),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: AppColors.tokenGoldDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: entries.length - (entries.length >= 3 ? 3 : 0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Aggregate Leaderboard (By School / By State)
// ---------------------------------------------------------------------------
class _AggregateLeaderboardList extends ConsumerWidget {
  const _AggregateLeaderboardList({required this.provider, required this.entityLabel});

  final FutureProvider<List<AggregateEntry>> provider;
  final String entityLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(provider);

    return dataAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (error, _) => AppErrorWidget(
        message: 'Could not load rankings.',
        onRetry: () => ref.invalidate(provider),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return const AppEmptyState(
            icon: Icons.leaderboard,
            title: 'No data yet',
            subtitle: 'Rankings will appear once players start predicting!',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _AggregateCard(entry: entry, entityLabel: entityLabel);
          },
        );
      },
    );
  }
}

class _AggregateCard extends StatelessWidget {
  const _AggregateCard({required this.entry, required this.entityLabel});
  final AggregateEntry entry;
  final String entityLabel;

  @override
  Widget build(BuildContext context) {
    final Color rankColor;
    if (entry.rank == 1) {
      rankColor = AppColors.gold;
    } else if (entry.rank == 2) {
      rankColor = AppColors.silver;
    } else if (entry.rank == 3) {
      rankColor = AppColors.bronze;
    } else {
      rankColor = AppColors.textMuted;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: rankColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '#${entry.rank}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: rankColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${entry.playerCount} players${entry.schoolCount != null ? ' \u2022 ${entry.schoolCount} schools' : ''}',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      TokenFormatter.format(entry.totalTokens),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: AppColors.tokenGoldDark,
                      ),
                    ),
                    const Text(
                      'total tokens',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Stats row
            Row(
              children: [
                _MiniStat(
                  label: 'Win Rate',
                  value: '${entry.avgWinRate.toStringAsFixed(0)}%',
                  color: entry.avgWinRate >= 55 ? AppColors.success : AppColors.textSecondary,
                  icon: Icons.trending_up,
                ),
                const SizedBox(width: AppSpacing.lg),
                _MiniStat(
                  label: 'Boldness',
                  value: '${entry.avgBoldness.toStringAsFixed(0)}%',
                  color: entry.avgBoldness >= 65 ? AppColors.secondary : AppColors.textSecondary,
                  icon: Icons.local_fire_department,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.color, required this.icon});
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Podium for top 3
// ---------------------------------------------------------------------------
class _Podium extends StatelessWidget {
  const _Podium({required this.top3});

  final List<LeaderboardEntry> top3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          _PodiumEntry(entry: top3[1], color: AppColors.silver, height: 80),
          const SizedBox(width: AppSpacing.md),
          // 1st place
          _PodiumEntry(entry: top3[0], color: AppColors.gold, height: 100),
          const SizedBox(width: AppSpacing.md),
          // 3rd place
          _PodiumEntry(entry: top3[2], color: AppColors.bronze, height: 60),
        ],
      ),
    );
  }
}

class _PodiumEntry extends StatelessWidget {
  const _PodiumEntry({
    required this.entry,
    required this.color,
    required this.height,
  });

  final LeaderboardEntry entry;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.3),
          child: Text(
            entry.displayName.isNotEmpty
                ? entry.displayName[0].toUpperCase()
                : '?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          entry.displayName,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.winRate.toStringAsFixed(0)}% win',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          TokenFormatter.format(entry.tokens),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: AppColors.tokenGoldDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: 70,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '#${entry.rank}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
