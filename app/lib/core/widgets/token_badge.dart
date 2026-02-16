import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../utils/token_formatter.dart';

class TokenBadge extends StatelessWidget {
  const TokenBadge({super.key, required this.tokens, this.compact = false});

  final int tokens;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.tokenGold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        border: Border.all(color: AppColors.tokenGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.toll,
            color: AppColors.tokenGold,
            size: compact ? 16 : 20,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            TokenFormatter.format(tokens),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: compact ? 13 : 15,
              fontWeight: FontWeight.w600,
              color: AppColors.tokenGoldDark,
            ),
          ),
        ],
      ),
    );
  }
}
