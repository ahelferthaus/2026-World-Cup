import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/token_formatter.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../domain/challenge_model.dart';

/// A glassmorphic card displaying a single P2P challenge.
class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.currentUid,
    this.onAccept,
    this.onDecline,
    this.onConfirmOutcome,
    this.compact = false,
  });

  final ChallengeModel challenge;
  final String currentUid;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onConfirmOutcome;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isMine = challenge.isMine(currentUid);
    final opponentName = challenge.opponentName(currentUid);
    final cat = challenge.category;

    return GlassmorphicCard(
      margin: EdgeInsets.only(bottom: compact ? AppSpacing.sm : AppSpacing.md),
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cat.color.withValues(alpha: 0.12),
          Colors.white.withValues(alpha: 0.03),
        ],
      ),
      borderColor: _borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: category badge + status + time
          Row(
            children: [
              _CategoryBadge(category: cat),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(status: challenge.status),
              const Spacer(),
              Text(
                DateFormatter.relativeTime(challenge.createdAt),
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Challenger info
          Text(
            isMine
                ? 'You challenged $opponentName'
                : '$opponentName challenged you',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Challenge title
          Text(
            challenge.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Wager
          Row(
            children: [
              const Text('\u{1F4B0}', style: TextStyle(fontSize: 16)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${TokenFormatter.format(challenge.wager)} tokens each',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: AppColors.tokenGoldDark,
                ),
              ),
              if (challenge.isResolved && challenge.outcome != null) ...[
                const Spacer(),
                _OutcomeBadge(
                  challenge: challenge,
                  currentUid: currentUid,
                ),
              ],
            ],
          ),

          // Action buttons
          if (!compact) ...[
            // Accept/Decline for pending challenges sent TO me
            if (challenge.isPending && !isMine) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.lost,
                        side: const BorderSide(color: AppColors.lost),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],

            // Confirm outcome button
            if (challenge.needsMyConfirmation(currentUid)) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onConfirmOutcome,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Confirm Outcome'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Color get _borderColor {
    if (challenge.isPending) return AppColors.pending.withValues(alpha: 0.3);
    if (challenge.isActive) return AppColors.primary.withValues(alpha: 0.3);
    if (challenge.isDisputed) return const Color(0xFFFF9100).withValues(alpha: 0.4);
    if (challenge.isResolved) {
      if (challenge.didWin(currentUid)) return AppColors.won.withValues(alpha: 0.3);
      if (challenge.didLose(currentUid)) return AppColors.lost.withValues(alpha: 0.2);
    }
    return Colors.white.withValues(alpha: 0.08);
  }
}

// ---------------------------------------------------------------------------
// Category badge
// ---------------------------------------------------------------------------
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final dynamic category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.15) as Color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.emoji as String, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 4),
          Text(
            category.displayName as String,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 9,
              letterSpacing: 0.5,
              color: category.color as Color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status chip (extended from the old PropBets version)
// ---------------------------------------------------------------------------
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final ChallengeStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color color, String label) = switch (status) {
      ChallengeStatus.pending => (AppColors.pending, 'Pending'),
      ChallengeStatus.accepted => (AppColors.primary, 'Active'),
      ChallengeStatus.declined => (AppColors.textMuted, 'Declined'),
      ChallengeStatus.awaitingOutcome => (AppColors.accent, 'Awaiting'),
      ChallengeStatus.disputed => (const Color(0xFFFF9100), 'Disputed'),
      ChallengeStatus.settled => (AppColors.won, 'Settled'),
      ChallengeStatus.expired => (AppColors.textMuted, 'Expired'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Outcome badge (Won / Lost / Push)
// ---------------------------------------------------------------------------
class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({
    required this.challenge,
    required this.currentUid,
  });
  final ChallengeModel challenge;
  final String currentUid;

  @override
  Widget build(BuildContext context) {
    final bool isWin = challenge.didWin(currentUid);
    final bool isPush = challenge.outcome == ChallengeOutcome.push;

    final (Color color, String label, String emoji) = isPush
        ? (AppColors.pending, 'PUSH', '\u{1F91D}')
        : isWin
            ? (AppColors.won, '+${TokenFormatter.format(challenge.wager)}', '\u{1F389}')
            : (AppColors.lost, '-${TokenFormatter.format(challenge.wager)}', '\u{1F614}');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
