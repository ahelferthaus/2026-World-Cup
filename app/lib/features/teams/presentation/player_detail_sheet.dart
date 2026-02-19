import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

void showPlayerDetailSheet(BuildContext context, Map<String, dynamic> player) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
    ),
    builder: (_) => _PlayerDetailContent(player: player),
  );
}

class _PlayerDetailContent extends StatelessWidget {
  const _PlayerDetailContent({required this.player});
  final Map<String, dynamic> player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppSpacing.xl),
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              (player['name'] as String).split(' ').map((w) => w[0]).join(),
              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(player['name'] as String, style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${player['team']} | ${player['position']} | Age ${player['age']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatBubble(label: 'Goals', value: '${player['goals']}', color: AppColors.secondary),
              _StatBubble(label: 'Assists', value: '${player['assists']}', color: AppColors.primary),
              _StatBubble(label: 'Caps', value: '${player['caps']}', color: AppColors.successDark),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Bio
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Text(
              player['bio'] as String,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _StatBubble extends StatelessWidget {
  const _StatBubble({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: AppTextStyles.heading2.copyWith(color: color),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}
