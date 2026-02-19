import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/token_formatter.dart';
import '../../domain/challenge_model.dart';

/// Bottom sheet for both sides to confirm the outcome of a challenge.
class OutcomeConfirmationSheet extends StatelessWidget {
  const OutcomeConfirmationSheet({
    super.key,
    required this.challenge,
    required this.currentUid,
  });

  final ChallengeModel challenge;
  final String currentUid;

  @override
  Widget build(BuildContext context) {
    final isMine = challenge.isMine(currentUid);
    final opponentName = challenge.opponentName(currentUid);

    // Check if the other person has already confirmed
    final otherConfirmed =
        isMine ? challenge.toConfirmed : challenge.fromConfirmed;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          const Text(
            'Who Won?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Challenge details
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${TokenFormatter.format(challenge.wager)} \u{1FA99}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.tokenGoldDark,
                  ),
                ),
              ],
            ),
          ),

          // Other person's confirmation status
          if (otherConfirmed) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '$opponentName already confirmed',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Outcome buttons
          _OutcomeButton(
            label: 'I Won',
            emoji: '\u{1F389}',
            color: AppColors.won,
            subtitle: 'You won ${TokenFormatter.format(challenge.wager)} tokens from $opponentName',
            onTap: () {
              context.showSuccessSnackBar(
                  'Outcome confirmed! (Demo mode)');
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _OutcomeButton(
            label: 'They Won',
            emoji: '\u{1F91D}',
            color: AppColors.primary,
            subtitle: '$opponentName won ${TokenFormatter.format(challenge.wager)} tokens',
            onTap: () {
              context.showSuccessSnackBar(
                  'Outcome confirmed! (Demo mode)');
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _OutcomeButton(
            label: 'Push (Tie)',
            emoji: '\u{1F91D}',
            color: AppColors.pending,
            subtitle: 'No tokens exchanged — everyone keeps their wager',
            onTap: () {
              context.showSuccessSnackBar(
                  'Outcome confirmed as push! (Demo mode)');
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _OutcomeButton extends StatelessWidget {
  const _OutcomeButton({
    required this.label,
    required this.emoji,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
