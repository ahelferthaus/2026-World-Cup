import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/widgets/token_badge.dart';
import '../../profile/presentation/providers/profile_providers.dart';
import 'matches_tab.dart';
import 'standings_tab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).valueOrNull;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(userProfile?.school.isNotEmpty == true
              ? 'WC 2026 \u2022 ${userProfile!.school.replaceAll(' High School', '')}'
              : '2026 World Cup'),
          actions: [
            if (userProfile != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: TokenBadge(tokens: userProfile.tokens, compact: true),
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Matches'),
              Tab(text: 'Standings'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Quick access bar
            _QuickAccessBar(),
            // Tab content
            const Expanded(
              child: TabBarView(
                children: [
                  MatchesTab(),
                  StandingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _QuickChip(
              icon: Icons.groups,
              label: 'Teams',
              onTap: () => context.push('/teams'),
            ),
            _QuickChip(
              icon: Icons.newspaper,
              label: 'News',
              onTap: () => context.push('/news'),
            ),
            _QuickChip(
              icon: Icons.handshake,
              label: 'Prop Bets',
              onTap: () => context.push('/propbets'),
            ),
            _QuickChip(
              icon: Icons.store,
              label: 'Buy Tokens',
              onTap: () => context.push('/store'),
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ActionChip(
        avatar: Icon(
          icon,
          size: 16,
          color: highlight ? AppColors.secondary : AppColors.primary,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: highlight ? AppColors.secondary : null,
          ),
        ),
        onPressed: onTap,
        side: highlight
            ? const BorderSide(color: AppColors.secondary)
            : null,
      ),
    );
  }
}
