import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class StreaksScreen extends StatelessWidget {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Streaks & Challenges')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current streak card
            const _StreakCard(),
            const SizedBox(height: AppSpacing.xl),
            // Daily challenges
            Text('Daily Challenges', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Complete challenges to earn bonus tokens!',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._dailyChallenges.map((c) => _ChallengeCard(challenge: c)),
            const SizedBox(height: AppSpacing.xl),
            // Weekly challenges
            Text('Weekly Challenges', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Bigger rewards for bigger commitments!',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._weeklyChallenges.map((c) => _ChallengeCard(challenge: c)),
            const SizedBox(height: AppSpacing.xl),
            // Streak milestones
            Text('Streak Milestones', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            const _MilestoneRow(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Streak Card - shows current prediction streak
// ---------------------------------------------------------------------------
class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    // Demo data
    const currentStreak = 5;
    const longestStreak = 8;
    const streakDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final activeDays = [true, true, true, true, true, false, false]; // M-F active

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6D00), Color(0xFFFF9100)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '\u{1F525} Current Streak',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$currentStreak',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6, left: 4),
                        child: Text(
                          'days',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Best Streak',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '$longestStreak days',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Day indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final isActive = activeDays[i];
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isActive
                          ? const Icon(Icons.check, color: Color(0xFFFF6D00), size: 20)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    streakDays[i],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Make a prediction today to keep your streak!',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Challenge Card
// ---------------------------------------------------------------------------
class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge});
  final _Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final progressPercent = (challenge.progress / challenge.target).clamp(0.0, 1.0);
    final isComplete = challenge.progress >= challenge.target;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isComplete
                        ? AppColors.success.withValues(alpha: 0.15)
                        : challenge.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isComplete
                        ? const Icon(Icons.check_circle, color: AppColors.success, size: 24)
                        : Icon(challenge.icon, color: challenge.color, size: 24),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          decoration: isComplete ? TextDecoration.lineThrough : null,
                          color: isComplete ? AppColors.textMuted : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        challenge.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isComplete ? AppColors.textMuted : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Reward
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.toll, size: 14, color: AppColors.tokenGold),
                        const SizedBox(width: 2),
                        Text(
                          '+${challenge.reward}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: isComplete ? AppColors.textMuted : AppColors.tokenGoldDark,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (isComplete)
                      const Text(
                        'Claimed!',
                        style: TextStyle(fontSize: 10, color: AppColors.success),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercent,
                minHeight: 6,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation(
                  isComplete ? AppColors.success : challenge.color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${challenge.progress}/${challenge.target}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                Text(
                  '${(progressPercent * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isComplete ? AppColors.success : challenge.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Milestone Row
// ---------------------------------------------------------------------------
class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _milestones.map((m) {
          final isReached = m.daysRequired <= 5; // demo: 5-day streak
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isReached
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: isReached
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : AppColors.divider,
              ),
            ),
            child: Column(
              children: [
                Text(
                  m.emoji,
                  style: TextStyle(
                    fontSize: 28,
                    color: isReached ? null : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${m.daysRequired} days',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isReached ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
                Text(
                  '+${m.reward}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isReached ? AppColors.tokenGoldDark : AppColors.textMuted,
                  ),
                ),
                if (isReached)
                  const Icon(Icons.check_circle, size: 16, color: AppColors.success),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------
class _Challenge {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int progress;
  final int target;
  final int reward;

  const _Challenge({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.progress,
    required this.target,
    required this.reward,
  });
}

class _Milestone {
  final int daysRequired;
  final String emoji;
  final int reward;

  const _Milestone({
    required this.daysRequired,
    required this.emoji,
    required this.reward,
  });
}

const _dailyChallenges = [
  _Challenge(
    title: 'Make 3 Predictions',
    description: 'Place predictions on 3 different matches',
    icon: Icons.sports_soccer,
    color: AppColors.primary,
    progress: 2,
    target: 3,
    reward: 10,
  ),
  _Challenge(
    title: 'Bold Bet',
    description: 'Make a prediction with 15+ tokens',
    icon: Icons.local_fire_department,
    color: AppColors.accent,
    progress: 1,
    target: 1,
    reward: 15,
  ),
  _Challenge(
    title: 'Exact Score Try',
    description: 'Attempt an exact score prediction',
    icon: Icons.gps_fixed,
    color: AppColors.neonPink,
    progress: 0,
    target: 1,
    reward: 5,
  ),
  _Challenge(
    title: 'Win One',
    description: 'Get at least one correct prediction today',
    icon: Icons.emoji_events,
    color: AppColors.tokenGoldDark,
    progress: 1,
    target: 1,
    reward: 20,
  ),
];

const _weeklyChallenges = [
  _Challenge(
    title: 'Prediction Master',
    description: 'Make 20 predictions this week',
    icon: Icons.star,
    color: AppColors.neonPurple,
    progress: 12,
    target: 20,
    reward: 50,
  ),
  _Challenge(
    title: '7-Day Streak',
    description: 'Predict every day for a full week',
    icon: Icons.local_fire_department,
    color: AppColors.accent,
    progress: 5,
    target: 7,
    reward: 100,
  ),
  _Challenge(
    title: 'Social Butterfly',
    description: 'Send 3 prop bets to friends',
    icon: Icons.handshake,
    color: AppColors.secondary,
    progress: 1,
    target: 3,
    reward: 30,
  ),
];

const _milestones = [
  _Milestone(daysRequired: 3, emoji: '\u{1F525}', reward: 25),
  _Milestone(daysRequired: 5, emoji: '\u{2B50}', reward: 50),
  _Milestone(daysRequired: 7, emoji: '\u{1F31F}', reward: 100),
  _Milestone(daysRequired: 14, emoji: '\u{1F4A5}', reward: 250),
  _Milestone(daysRequired: 30, emoji: '\u{1F3C6}', reward: 500),
  _Milestone(daysRequired: 60, emoji: '\u{1F451}', reward: 1000),
];
