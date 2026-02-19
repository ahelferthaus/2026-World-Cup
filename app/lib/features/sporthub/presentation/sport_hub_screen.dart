import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/animated_background.dart';

/// The multi-sport hub — the app's front door for selecting a sport.
/// Uses animated backgrounds and glassmorphic cards for Stadium Live-quality UI.
class SportHubScreen extends StatelessWidget {
  const SportHubScreen({super.key});

  static const _sports = <_SportEntry>[
    _SportEntry(
      id: 'worldcup',
      name: 'FIFA World Cup',
      subtitle: '2026 \u2022 USA/MEX/CAN',
      emoji: '\u26BD',
      route: '/home',
      gradientColors: [Color(0xFF00C853), Color(0xFF1B5E20)],
      isLive: true,
      badge: 'LIVE NOW',
    ),
    _SportEntry(
      id: 'nba',
      name: 'NBA Playoffs',
      subtitle: '2026 \u2022 Round 1',
      emoji: '\u{1F3C0}',
      route: '/nba',
      gradientColors: [Color(0xFFF37321), Color(0xFF1D428A)],
      isLive: true,
      badge: 'GAME TONIGHT',
    ),
    _SportEntry(
      id: 'nfl',
      name: 'NFL',
      subtitle: 'Coming Fall 2026',
      emoji: '\u{1F3C8}',
      route: '',
      gradientColors: [Color(0xFF013369), Color(0xFFD50A0A)],
      isLive: false,
      badge: 'COMING SOON',
    ),
    _SportEntry(
      id: 'mlb',
      name: 'MLB',
      subtitle: 'Coming Summer 2026',
      emoji: '\u26BE',
      route: '',
      gradientColors: [Color(0xFF002D72), Color(0xFFCE1141)],
      isLive: false,
      badge: 'COMING SOON',
    ),
    _SportEntry(
      id: 'ufc',
      name: 'UFC/MMA',
      subtitle: 'Coming 2026',
      emoji: '\u{1F94A}',
      route: '',
      gradientColors: [Color(0xFFD20A0A), Color(0xFF1A1A1A)],
      isLive: false,
      badge: 'COMING SOON',
    ),
    _SportEntry(
      id: 'esports',
      name: 'Esports',
      subtitle: 'Coming 2026',
      emoji: '\u{1F3AE}',
      route: '',
      gradientColors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
      isLive: false,
      badge: 'COMING SOON',
    ),
  ];

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
                    AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PICK YOUR GAME',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          color: AppColors.textPrimary,
                          letterSpacing: 1,
                          height: 1.1,
                        ),
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
              // Sport cards grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _SportCard(sport: _sports[index]);
                    },
                    childCount: _sports.length,
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
// Sport Card — glassmorphic card with gradient, emoji, and live badge
// ---------------------------------------------------------------------------
class _SportCard extends StatelessWidget {
  const _SportCard({required this.sport});
  final _SportEntry sport;

  @override
  Widget build(BuildContext context) {
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
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: sport.isLive
                      ? [
                          sport.gradientColors.first.withValues(alpha: 0.25),
                          sport.gradientColors.last.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.03),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.06),
                          Colors.white.withValues(alpha: 0.02),
                        ],
                ),
              ),
              child: Stack(
                children: [
                  // Background emoji (large, faded)
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: sport.isLive ? 0.15 : 0.06,
                      child: Text(
                        sport.emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: sport.isLive
                                ? AppColors.success.withValues(alpha: 0.2)
                                : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
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
                        ),
                        const Spacer(),
                        // Emoji
                        Text(
                          sport.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Name
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------
class _SportEntry {
  final String id;
  final String name;
  final String subtitle;
  final String emoji;
  final String route;
  final List<Color> gradientColors;
  final bool isLive;
  final String badge;

  const _SportEntry({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.emoji,
    required this.route,
    required this.gradientColors,
    required this.isLive,
    required this.badge,
  });
}
