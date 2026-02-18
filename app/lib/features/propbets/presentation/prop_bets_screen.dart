import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/token_formatter.dart';
import '../../auth/presentation/providers/auth_providers.dart';

class PropBetsScreen extends ConsumerWidget {
  const PropBetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = ref.watch(currentUidProvider);
    final allBets = DemoData.propBets;
    final myBets = allBets.where((b) =>
        b['fromUid'] == currentUid || b['toUid'] == currentUid).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prop Bets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Bets'),
              Tab(text: 'Create'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MyBetsTab(bets: myBets, currentUid: currentUid ?? ''),
            _CreatePropBetTab(),
          ],
        ),
      ),
    );
  }
}

class _MyBetsTab extends StatelessWidget {
  const _MyBetsTab({required this.bets, required this.currentUid});
  final List<Map<String, dynamic>> bets;
  final String currentUid;

  @override
  Widget build(BuildContext context) {
    if (bets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handshake_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: AppSpacing.md),
            Text('No prop bets yet', style: AppTextStyles.heading3.copyWith(color: Colors.grey)),
            const SizedBox(height: AppSpacing.xs),
            const Text('Challenge a friend to a bet!', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: bets.length,
      itemBuilder: (context, index) {
        final bet = bets[index];
        final isMine = bet['fromUid'] == currentUid;
        final otherName = isMine ? bet['toName'] : bet['fromName'];
        final status = bet['status'] as String;

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    _StatusChip(status: status),
                    const Spacer(),
                    Text(
                      DateFormatter.relativeTime(DateTime.parse(bet['createdAt'] as String)),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Bet details
                Text(
                  isMine ? 'You challenged $otherName' : '$otherName challenged you',
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${bet['homeTeamName']} vs ${bet['awayTeamName']}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.casino, size: 16, color: AppColors.secondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      bet['description'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${TokenFormatter.format(bet['wager'] as int)} tokens each',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.tokenGoldDark,
                  ),
                ),
                // Action buttons for pending received bets
                if (status == 'pending' && !isMine) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.showSuccessSnackBar('Bet declined'),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.showSuccessSnackBar('Bet accepted!'),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    switch (status) {
      case 'pending':
        color = AppColors.pending;
        label = 'Pending';
      case 'accepted':
        color = AppColors.primary;
        label = 'Active';
      case 'won':
        color = AppColors.won;
        label = 'Won';
      case 'lost':
        color = AppColors.lost;
        label = 'Lost';
      case 'declined':
        color = Colors.grey;
        label = 'Declined';
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _CreatePropBetTab extends StatefulWidget {
  @override
  State<_CreatePropBetTab> createState() => _CreatePropBetTabState();
}

class _CreatePropBetTabState extends State<_CreatePropBetTab> {
  String? _selectedOpponent;
  String? _selectedMatch;
  String? _selectedBetType;
  double _wager = 5;

  static const _betTypes = [
    {'id': 'winner', 'label': 'Match Winner', 'icon': Icons.emoji_events, 'desc': 'Bet on who wins the game'},
    {'id': 'nextGoal', 'label': 'Next Goal', 'icon': Icons.sports_soccer, 'desc': 'Bet on which team scores next'},
    {'id': 'overUnder', 'label': 'Over/Under', 'icon': Icons.swap_vert, 'desc': 'Bet on total goals over or under 2.5'},
    {'id': 'exactScore', 'label': 'Exact Score', 'icon': Icons.scoreboard, 'desc': 'Bet on the final score'},
    {'id': 'goldenBoot', 'label': 'Golden Boot', 'icon': Icons.military_tech, 'desc': 'Bet on who wins the Golden Boot'},
  ];

  @override
  Widget build(BuildContext context) {
    final opponents = DemoData.leaderboardSchool
        .where((e) => e['uid'] != 'demo_user')
        .toList();
    final upcomingMatches = DemoData.matches
        .where((m) => m['status'] == 'NS')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Challenge a Friend', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),
          // Opponent selector
          Text('Who do you want to challenge?', style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: opponents.map((o) {
              final uid = o['uid'] as String;
              final isSelected = _selectedOpponent == uid;
              return ChoiceChip(
                label: Text(o['displayName'] as String),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedOpponent = uid),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Match selector
          Text('Which match?', style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          ...upcomingMatches.map((m) {
            final matchId = '${m['id']}';
            final isSelected = _selectedMatch == matchId;
            return ListTile(
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : Colors.grey,
                size: 20,
              ),
              title: Text(
                '${(m['homeTeam'] as Map)['name']} vs ${(m['awayTeam'] as Map)['name']}',
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () => setState(() => _selectedMatch = matchId),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          // Bet type
          Text('What kind of bet?', style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          ...(_betTypes.map((bt) {
            final id = bt['id'] as String;
            final isSelected = _selectedBetType == id;
            return Card(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
              shape: isSelected
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      side: const BorderSide(color: AppColors.primary, width: 2),
                    )
                  : null,
              child: ListTile(
                leading: Icon(bt['icon'] as IconData,
                    color: isSelected ? AppColors.primary : Colors.grey),
                title: Text(bt['label'] as String,
                    style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                subtitle: Text(bt['desc'] as String, style: const TextStyle(fontSize: 12)),
                onTap: () => setState(() => _selectedBetType = id),
                dense: true,
              ),
            );
          })),
          const SizedBox(height: AppSpacing.xl),
          // Wager
          Text('Wager: ${_wager.toInt()} tokens', style: AppTextStyles.heading3),
          Slider(
            value: _wager,
            min: 1,
            max: 20,
            divisions: 19,
            label: '${_wager.toInt()}',
            onChanged: (v) => setState(() => _wager = v),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Send button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _selectedOpponent != null &&
                      _selectedMatch != null &&
                      _selectedBetType != null
                  ? () {
                      context.showSuccessSnackBar('Prop bet sent! (Demo mode)');
                      setState(() {
                        _selectedOpponent = null;
                        _selectedMatch = null;
                        _selectedBetType = null;
                        _wager = 5;
                      });
                    }
                  : null,
              icon: const Icon(Icons.send),
              label: const Text('Send Challenge'),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
