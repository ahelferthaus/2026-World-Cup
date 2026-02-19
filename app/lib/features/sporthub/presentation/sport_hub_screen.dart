import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/glassmorphic_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../data/sport_hub_data.dart';

/// The multi-sport hub — the app's front door for selecting a sport.
/// Uses animated backgrounds, player headshots, and glassmorphic cards.
class SportHubScreen extends StatelessWidget {
  const SportHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        orbCount: 5,
        speed: 0.7,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '\u{1FA99}',
                            style: TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Text(
                            'PICK YOUR GAME',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                              color: AppColors.textPrimary,
                              letterSpacing: 1,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Predict. Compete. Win tokens.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Matchup Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  child: _FeaturedMatchupBanner(),
                ),
              ),

              // Sport cards grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _SportCard(sport: SportHubData.sports[index]);
                    },
                    childCount: SportHubData.sports.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Featured Matchup Banner — tonight's biggest game
// ---------------------------------------------------------------------------
class _FeaturedMatchupBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Grab the first live match from demo data
    final match = DemoData.matches.firstWhere(
      (m) => m['status'] == '2H' || m['status'] == '1H',
      orElse: () => DemoData.matches.first,
    );
    final home = match['homeTeam'] as Map<String, dynamic>;
    final away = match['awayTeam'] as Map<String, dynamic>;
    final isLive = match['status'] == '2H' || match['status'] == '1H';

    return GlassmorphicCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.15),
          AppColors.accent.withValues(alpha: 0.08),
        ],
      ),
      child: Column(
        children: [
          // "FEATURED MATCHUP" header
          Row(
            children: [
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.live.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
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
                      const SizedBox(width: 4),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                          color: AppColors.live,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                'FEATURED MATCHUP',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 1,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Team vs Team
          Row(
            children: [
              // Home team
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        home['logo'] as String,
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Text('\u26BD', style: TextStyle(fontSize: 36)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      home['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Score / VS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: isLive
                    ? Column(
                        children: [
                          Text(
                            '${match['homeScore']} - ${match['awayScore']}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            "${match['elapsed']}'",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.live,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'VS',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: AppColors.textMuted,
                        ),
                      ),
              ),

              // Away team
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        away['logo'] as String,
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Text('\u26BD', style: TextStyle(fontSize: 36)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      away['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Predict Now button
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: 'PREDICT NOW',
              onPressed: () => context.push('/predict'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sport Card — rich imagery with player headshots
// ---------------------------------------------------------------------------
class _SportCard extends StatelessWidget {
  const _SportCard({required this.sport});
  final SportConfig sport;

  @override
  Widget build(BuildContext context) {
    final hasPlayers = sport.featuredPlayers.isNotEmpty &&
        sport.featuredPlayers.first.imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: sport.route.isNotEmpty
          ? () => context.push(sport.route)
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${sport.name} coming soon!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: sport.isLive
                ? sport.gradientColors.first.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: sport.isLive
                        ? [
                            sport.gradientColors.first.withValues(alpha: 0.35),
                            sport.gradientColors.last.withValues(alpha: 0.15),
                            AppColors.background.withValues(alpha: 0.8),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.06),
                            Colors.white.withValues(alpha: 0.02),
                          ],
                  ),
                ),
              ),

              // Player headshot (hero image) — top portion
              if (hasPlayers)
                Positioned(
                  top: -5,
                  right: -15,
                  child: Opacity(
                    opacity: sport.isLive ? 0.7 : 0.3,
                    child: Image.network(
                      sport.featuredPlayers.first.imageUrl,
                      height: 130,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, __, ___) => Opacity(
                        opacity: 0.15,
                        child: Text(
                          sport.emoji,
                          style: const TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                  ),
                )
              else
                // Fallback: large faded emoji
                Positioned(
                  right: -10,
                  top: -5,
                  child: Opacity(
                    opacity: sport.isLive ? 0.15 : 0.06,
                    child: Text(
                      sport.emoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),

              // Glassmorphic bottom overlay with content
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppSpacing.cardRadius)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.background.withValues(alpha: 0.3),
                            AppColors.background.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Sport name
                          Text(
                            sport.name,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: sport.isLive
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                            ),
                          ),
                          Text(
                            sport.subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: sport.isLive
                                  ? AppColors.textSecondary
                                  : AppColors.textMuted,
                            ),
                          ),

                          // Mini player avatar row
                          if (sport.featuredPlayers.isNotEmpty &&
                              sport.isLive) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                // Player circles
                                ...sport.featuredPlayers.take(3).map((p) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.only(right: 4),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: sport
                                          .gradientColors.first
                                          .withValues(alpha: 0.3),
                                      child: p.imageUrl.isNotEmpty
                                          ? ClipOval(
                                              child: Image.network(
                                                p.imageUrl,
                                                width: 24,
                                                height: 24,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) => Text(
                                                  p.name[0],
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              p.name[0],
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    AppColors.textSecondary,
                                              ),
                                            ),
                                    ),
                                  );
                                }),
                                const SizedBox(width: 4),
                                Text(
                                  sport.featuredPlayers
                                      .take(3)
                                      .map((p) => p.name)
                                      .join(', '),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.textMuted,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Badge (top-right)
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: sport.isLive
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (sport.isLive) ...[
                        Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Text(
                        sport.badge,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                          letterSpacing: 0.5,
                          color: sport.isLive
                              ? AppColors.success
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
