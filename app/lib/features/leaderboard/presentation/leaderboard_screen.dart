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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Global'),
              Tab(text: 'School'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _LeaderboardList(provider: globalLeaderboardProvider),
            _LeaderboardList(provider: schoolLeaderboardProvider),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardList extends ConsumerWidget {
  const _LeaderboardList({required this.provider});

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
                                    : Colors.grey,
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
                                  ),
                                ),
                                Text(
                                  entry.school,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            TokenFormatter.format(entry.tokens),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppColors.tokenGoldDark,
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
          TokenFormatter.format(entry.tokens),
          style: TextStyle(
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
