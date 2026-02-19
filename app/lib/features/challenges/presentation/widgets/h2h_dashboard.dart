import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../domain/opponent_record.dart';

/// Head-to-head dashboard showing per-opponent stats.
class H2hDashboard extends StatelessWidget {
  const H2hDashboard({super.key, required this.records});

  final List<OpponentRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text('No opponents yet',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('Challenge a friend to get started!',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: records.length,
      itemBuilder: (context, index) {
        return _OpponentCard(record: records[index]);
      },
    );
  }
}

class _OpponentCard extends StatelessWidget {
  const _OpponentCard({required this.record});
  final OpponentRecord record;

  @override
  Widget build(BuildContext context) {
    final isPositive = record.netTokens >= 0;

    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Header: name + record
          Row(
            children: [
              // Avatar placeholder
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  record.opponentName[0].toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
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
                      record.opponentName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${record.totalBets} bets total',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Net tokens
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isPositive ? "+" : ""}${record.netTokens}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: isPositive ? AppColors.won : AppColors.lost,
                    ),
                  ),
                  Text(
                    'net tokens',
                    style: TextStyle(
                        fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Stats row
          Row(
            children: [
              _StatPill(
                label: 'Record',
                value: record.recordDisplay,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatPill(
                label: 'Win %',
                value: '${(record.winRate * 100).toStringAsFixed(0)}%',
                color: record.winRate >= 0.5 ? AppColors.won : AppColors.lost,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatPill(
                label: 'Streak',
                value: record.streakDisplay,
                color: record.isOnWinStreak
                    ? AppColors.won
                    : record.isOnLossStreak
                        ? AppColors.lost
                        : AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Win rate visual bar
          _WinRateBar(winRate: record.winRate),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Visual bar showing win rate as green vs red proportional fill.
class _WinRateBar extends StatelessWidget {
  const _WinRateBar({required this.winRate});
  final double winRate;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 6,
        child: Row(
          children: [
            Expanded(
              flex: math.max((winRate * 100).round(), 1),
              child: Container(color: AppColors.won),
            ),
            Expanded(
              flex: math.max(((1 - winRate) * 100).round(), 1),
              child: Container(color: AppColors.lost.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }
}
