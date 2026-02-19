import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/widgets/team_flag.dart';
import 'player_detail_sheet.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teams = DemoData.teams;
    final goldenBoot = DemoData.goldenBootRace;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Teams & Players'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Teams'),
              Tab(text: 'Players'),
              Tab(icon: Icon(Icons.emoji_events, size: 18), text: 'Golden Boot'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TeamsTab(teams: teams),
            _PlayersTab(),
            _GoldenBootTab(entries: goldenBoot),
          ],
        ),
      ),
    );
  }
}

class _TeamsTab extends StatelessWidget {
  const _TeamsTab({required this.teams});
  final List<Map<String, dynamic>> teams;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final t = teams[index];
        return Card(
          child: ListTile(
            leading: TeamFlag(logoUrl: t['logo'] as String, size: 36),
            title: Text(
              t['name'] as String,
              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Group ${t['group']} | FIFA #${t['fifaRanking']} | Coach: ${t['coach']}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTeamPlayers(context, t['name'] as String),
          ),
        );
      },
    );
  }

  void _showTeamPlayers(BuildContext context, String teamName) {
    final teamPlayers = DemoData.players
        .where((p) => p['team'] == teamName)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text('$teamName Squad', style: AppTextStyles.heading3),
            ),
            Expanded(
              child: teamPlayers.isEmpty
                  ? const Center(child: Text('No player data available'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: teamPlayers.length,
                      itemBuilder: (context, i) {
                        final p = teamPlayers[i];
                        return ListTile(
                          title: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${p['position']} | Age: ${p['age']} | ${p['caps']} caps'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${p['goals']}', style: AppTextStyles.heading3.copyWith(color: AppColors.secondary)),
                              const Text('goals', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          onTap: () => showPlayerDetailSheet(context, p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final players = DemoData.players;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final p = players[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                (p['name'] as String).split(' ').last[0],
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
            title: Text(
              p['name'] as String,
              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${p['team']} | ${p['position']} | Age ${p['age']}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${p['goals']}', style: AppTextStyles.labelLarge.copyWith(color: AppColors.secondary)),
                    const Text('G', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${p['assists']}', style: AppTextStyles.labelLarge),
                    const Text('A', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
            onTap: () => showPlayerDetailSheet(context, p),
          ),
        );
      },
    );
  }
}

class _GoldenBootTab extends StatelessWidget {
  const _GoldenBootTab({required this.entries});
  final List<Map<String, dynamic>> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final e = entries[index];
        final rank = index + 1;
        final Color? medalColor = rank == 1
            ? AppColors.gold
            : rank == 2
                ? AppColors.silver
                : rank == 3
                    ? AppColors.bronze
                    : null;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: medalColor?.withValues(alpha: 0.2) ?? AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: medalColor ?? AppColors.textMuted,
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
                        e['player'] as String,
                        style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${e['team']} | ${e['minutesPlayed']} min played',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${e['goals']}',
                      style: AppTextStyles.heading2.copyWith(color: AppColors.secondary),
                    ),
                    Text(
                      '${e['assists']} ast',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
