import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/glassmorphic_card.dart';
import '../nba_demo_data.dart';

class NbaHomeScreen extends StatelessWidget {
  const NbaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        colors: [
          AppColors.nbaBlue.withValues(alpha: 0.4),
          AppColors.nbaOrange.withValues(alpha: 0.3),
          AppColors.nbaRed.withValues(alpha: 0.2),
          AppColors.primary.withValues(alpha: 0.25),
        ],
        child: CustomScrollView(
          slivers: [
            // Collapsed app bar with glassmorphism
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.background.withValues(alpha: 0.8),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'NBA PLAYOFFS',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
                background: _HeroBanner(),
              ),
            ),
            // Star player scroll
            SliverToBoxAdapter(
              child: _StarPlayerCarousel(),
            ),
            // Today's games header
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(Icons.sports_basketball, color: AppColors.nbaOrange, size: 20),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      "TODAY'S GAMES",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Matchup cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final matchup = NbaDemoData.round1Matchups[index];
                    return _PlayoffMatchupCard(matchup: matchup);
                  },
                  childCount: NbaDemoData.round1Matchups.length,
                ),
              ),
            ),
            // Trending predictions
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text('\u{1F525}', style: TextStyle(fontSize: 18)),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'TRENDING PREDICTIONS',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Social prediction feed
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final pred = NbaDemoData.trendingPredictions[index];
                    return _TrendingPredictionCard(prediction: pred);
                  },
                  childCount: NbaDemoData.trendingPredictions.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero Banner with gradient and NBA branding
// ---------------------------------------------------------------------------
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1D428A), // NBA blue
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Decorative basketball pattern
          Positioned(
            right: -30,
            top: 20,
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.sports_basketball, size: 200, color: Colors.white),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, 80, AppSpacing.xl, 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.nbaOrange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ROUND 1',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'NBA Playoffs',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '8 games today \u2022 Predict & Win Tokens',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
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
// Star Player Carousel — glossy player images with glassmorphism stats
// ---------------------------------------------------------------------------
class _StarPlayerCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        itemCount: NbaDemoData.starPlayers.length,
        itemBuilder: (context, index) {
          final player = NbaDemoData.starPlayers[index];
          return _PlayerCard(player: player);
        },
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({required this.player});
  final Map<String, dynamic> player;

  @override
  Widget build(BuildContext context) {
    final teamData = NbaDemoData.playoffTeams.firstWhere(
      (t) => t['abbr'] == player['team'],
      orElse: () => {'color': 0xFF6C5CE7},
    );
    final teamColor = Color(teamData['color'] as int);

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    teamColor.withValues(alpha: 0.6),
                    teamColor.withValues(alpha: 0.2),
                    AppColors.surfaceCard,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: teamColor.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          // Player image (positioned at top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.cardRadius),
              ),
              child: SizedBox(
                height: 110,
                child: Image.network(
                  player['image'] as String,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Container(
                    color: teamColor.withValues(alpha: 0.2),
                    child: Center(
                      child: Text(
                        '#${player['number']}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: teamColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Glassmorphic stat overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSpacing.cardRadius),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (player['name'] as String).split(' ').last,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${player['team']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const Spacer(),
                          _MiniStat('${player['ppg']}', 'PPG'),
                          const SizedBox(width: 6),
                          _MiniStat('${player['rpg']}', 'RPG'),
                          const SizedBox(width: 6),
                          _MiniStat('${player['apg']}', 'APG'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Jersey number badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '#${player['number']}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Playoff Matchup Card — glassmorphic with series score and bet button
// ---------------------------------------------------------------------------
class _PlayoffMatchupCard extends StatelessWidget {
  const _PlayoffMatchupCard({required this.matchup});
  final Map<String, dynamic> matchup;

  @override
  Widget build(BuildContext context) {
    final odds = matchup['odds'] as Map<String, dynamic>;

    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Predict: ${matchup['homeName']} vs ${matchup['awayName']}',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      },
      child: Column(
        children: [
          // Conference & round badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: matchup['conference'] == 'West'
                      ? AppColors.nbaBlue.withValues(alpha: 0.2)
                      : AppColors.nbaRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${matchup['conference']} \u2022 R${matchup['round']}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: matchup['conference'] == 'West'
                        ? const Color(0xFF6DB3F2)
                        : const Color(0xFFFF8A80),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                matchup['status'] as String,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: AppColors.nbaOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Teams row
          Row(
            children: [
              // Home team
              Expanded(
                child: _TeamColumn(
                  seed: matchup['homeSeed'] as int,
                  name: matchup['homeName'] as String,
                  city: matchup['homeCity'] as String,
                  wins: matchup['homeWins'] as int,
                  isLeading: (matchup['homeWins'] as int) >
                      (matchup['awayWins'] as int),
                ),
              ),
              // Series score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${matchup['homeWins']} - ${matchup['awayWins']}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Away team
              Expanded(
                child: _TeamColumn(
                  seed: matchup['awaySeed'] as int,
                  name: matchup['awayName'] as String,
                  city: matchup['awayCity'] as String,
                  wins: matchup['awayWins'] as int,
                  isLeading: (matchup['awayWins'] as int) >
                      (matchup['homeWins'] as int),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Odds row with quick bet buttons
          Row(
            children: [
              _OddsBetButton(
                label: matchup['homeName'] as String,
                odds: (odds['home'] as num).toDouble(),
                isHome: true,
              ),
              const SizedBox(width: AppSpacing.sm),
              _OddsBetButton(
                label: matchup['awayName'] as String,
                odds: (odds['away'] as num).toDouble(),
                isHome: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  const _TeamColumn({
    required this.seed,
    required this.name,
    required this.city,
    required this.wins,
    this.isLeading = false,
    this.alignEnd = false,
  });

  final int seed;
  final String name;
  final String city;
  final int wins;
  final bool isLeading;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          '($seed) $city',
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isLeading ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _OddsBetButton extends StatelessWidget {
  const _OddsBetButton({
    required this.label,
    required this.odds,
    required this.isHome,
  });

  final String label;
  final double odds;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    final isFavorite = odds < 2.0;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isFavorite
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surfaceLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: isFavorite
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isFavorite ? AppColors.primaryLight : AppColors.textSecondary,
              ),
            ),
            Text(
              odds.toStringAsFixed(2),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isFavorite ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trending Prediction Card (social feed style)
// ---------------------------------------------------------------------------
class _TrendingPredictionCard extends StatelessWidget {
  const _TrendingPredictionCard({required this.prediction});
  final Map<String, dynamic> prediction;

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      opacity: 0.06,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Emoji
          Text(
            prediction['emoji'] as String,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          // Prediction text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '@${prediction['user']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tokenGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${prediction['tokens']} tokens',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.tokenGoldDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  prediction['prediction'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Likes
          Column(
            children: [
              const Icon(Icons.favorite_border, size: 16, color: AppColors.neonPink),
              Text(
                '${prediction['likes']}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
