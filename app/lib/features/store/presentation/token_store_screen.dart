import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/token_formatter.dart';
import '../../../core/widgets/token_badge.dart';
import '../../profile/presentation/providers/profile_providers.dart';

class TokenStoreScreen extends ConsumerWidget {
  const TokenStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).valueOrNull;
    final packages = DemoData.tokenPackages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Store'),
        actions: [
          if (userProfile != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: TokenBadge(tokens: userProfile.tokens, compact: true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Column(
                children: [
                  const Icon(Icons.toll, color: AppColors.tokenGold, size: 48),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Need more tokens?',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.textOnPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Buy tokens to make bigger bets and climb the leaderboard!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Choose a Package', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            // Package grid
            ...packages.map((pkg) => _TokenPackageCard(
              package: pkg,
              onBuy: () => _handleBuy(context, pkg),
            )),
            const SizedBox(height: AppSpacing.xl),
            // Stripe badge
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Secured by Stripe',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Disclaimer
            Center(
              child: Text(
                'Tokens are virtual currency for prediction games only.\nNo real money value. All purchases are final.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBuy(BuildContext context, Map<String, dynamic> pkg) {
    final tokens = pkg['tokens'] as int;
    final price = pkg['price'] as double;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(pkg['label'] as String),
        content: Text(
          'Buy ${TokenFormatter.format(tokens)} tokens for \$${price.toStringAsFixed(2)}?\n\n'
          'In demo mode, this will simulate the purchase.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.showSuccessSnackBar(
                'Demo: +${TokenFormatter.format(tokens)} tokens added!',
              );
            },
            child: Text('Buy for \$${price.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}

class _TokenPackageCard extends StatelessWidget {
  const _TokenPackageCard({required this.package, required this.onBuy});
  final Map<String, dynamic> package;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final isPopular = package['popular'] as bool;
    final tokens = package['tokens'] as int;
    final price = package['price'] as double;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: isPopular
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              side: const BorderSide(color: AppColors.secondary, width: 2),
            )
          : null,
      child: InkWell(
        onTap: onBuy,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.tokenGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.toll, color: AppColors.tokenGold, size: 28),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          package['label'] as String,
                          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                        ),
                        if (isPopular) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'POPULAR',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${TokenFormatter.format(tokens)} tokens',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                ),
                child: Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
