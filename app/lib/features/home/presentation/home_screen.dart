import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/glassmorphic_card.dart';
import '../../../core/widgets/token_badge.dart';
import '../../profile/presentation/providers/profile_providers.dart';
import 'matches_tab.dart';
import 'standings_tab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).valueOrNull;
    final liveCount = DemoData.matches
        .where((m) =>
            m['status'] == '1H' ||
            m['status'] == '2H' ||
            m['status'] == 'HT')
        .length;

    return AnimatedGradientBackground(
      colors: [
        AppColors.primary.withValues(alpha: 0.3),
        AppColors.secondary.withValues(alpha: 0.2),
        AppColors.accent.withValues(alpha: 0.15),
      ],
      orbCount: 3,
      speed: 0.5,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              // Hero SliverAppBar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.background.withValues(alpha: 0.85),
                flexibleSpace: FlexibleSpaceBar(
                  background: _HomeHeroBanner(
                    liveCount: liveCount,
                    tokens: userProfile?.tokens ?? 0,
                  ),
                ),
                title: const Text(
                  "POKIN' TOKENS",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                actions: [
                  if (userProfile != null)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child:
                          TokenBadge(tokens: userProfile.tokens, compact: true),
                    ),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Matches'),
                    Tab(text: 'Standings'),
                  ],
                ),
              ),

              // Quick access bar
              SliverToBoxAdapter(child: _QuickAccessBar()),

              // Trending predictions carousel
              SliverToBoxAdapter(child: _TrendingCarousel()),
            ],
            body: const TabBarView(
              children: [
                MatchesTab(),
                StandingsTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero banner — gradient background with live match count
// ---------------------------------------------------------------------------
class _HomeHeroBanner extends StatelessWidget {
  const _HomeHeroBanner({required this.liveCount, required this.tokens});
  final int liveCount;
  final int tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A0E3E), // deep purple
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Decorative token icon watermark
          Positioned(
            right: -30,
            top: 20,
            child: Opacity(
              opacity: 0.06,
              child: Icon(Icons.toll, size: 200, color: Colors.white),
            ),
          ),
          // Decorative soccer ball
          Positioned(
            left: -20,
            bottom: 60,
            child: Opacity(
              opacity: 0.04,
              child: Text('\u26BD', style: TextStyle(fontSize: 120)),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, 80, AppSpacing.xl, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Live badge
                if (liveCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.live.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: AppColors.live.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.live,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$liveCount LIVE ${liveCount == 1 ? "MATCH" : "MATCHES"}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            letterSpacing: 0.5,
                            color: AppColors.live,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Predict & Win Tokens',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trending predictions carousel
// ---------------------------------------------------------------------------
class _TrendingCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Reuse social feed data for trending predictions
    final trending = [
      {'user': 'SoccerKing99', 'prediction': 'USA beats Mexico', 'tokens': 20, 'emoji': '\u{1F1FA}\u{1F1F8}'},
      {'user': 'PredictPro', 'prediction': 'Brazil wins Group B', 'tokens': 30, 'emoji': '\u{1F1E7}\u{1F1F7}'},
      {'user': 'GoalMachine', 'prediction': 'Mbapp\u00e9 Golden Boot', 'tokens': 25, 'emoji': '\u{1F3C6}'},
      {'user': 'BucketBoss', 'prediction': 'Over 2.5 goals ENG vs GER', 'tokens': 15, 'emoji': '\u26BD'},
      {'user': 'HoopDreams', 'prediction': 'France wins the whole thing', 'tokens': 50, 'emoji': '\u{1F525}'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          child: Row(
            children: [
              const Text('\u{1F525}', style: TextStyle(fontSize: 16)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'TRENDING PREDICTIONS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 1,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: trending.length,
            itemBuilder: (context, index) {
              final t = trending[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                child: GlassmorphicCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(t['emoji'] as String,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              t['prediction'] as String,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '@${t['user']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${t['tokens']} \u{1FA99}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tokenGoldDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Quick access bar
// ---------------------------------------------------------------------------
class _QuickAccessBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm, horizontal: AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _QuickChip(
              icon: Icons.sports,
              label: 'All Sports',
              onTap: () => context.push('/sports'),
              highlight: true,
            ),
            _QuickChip(
              icon: Icons.sports_basketball,
              label: 'NBA',
              onTap: () => context.push('/nba'),
              highlight: true,
            ),
            _QuickChip(
              icon: Icons.play_circle_fill,
              label: 'Live Game',
              onTap: () => context.push('/live/1'),
              highlight: true,
            ),
            _QuickChip(
              icon: Icons.local_fire_department,
              label: 'Streaks',
              onTap: () => context.push('/streaks'),
              highlight: true,
            ),
            _QuickChip(
              icon: Icons.account_tree,
              label: 'Bracket',
              onTap: () => context.push('/bracket'),
            ),
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
              icon: Icons.bolt,
              label: 'Challenges',
              onTap: () => context.push('/propbets'),
              highlight: true,
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
          color: highlight ? AppColors.accent : AppColors.primaryLight,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: highlight ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
        onPressed: onTap,
        side: highlight ? const BorderSide(color: AppColors.accent) : null,
      ),
    );
  }
}
