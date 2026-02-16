import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/utils/token_formatter.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../predict/presentation/providers/predict_providers.dart';
import 'providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final predictionsAsync = ref.watch(userPredictionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (_, __) => const Center(child: Text('Failed to load profile')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Profile not found'));
          }

          final predictions = predictionsAsync.valueOrNull ?? [];
          final totalPredictions = predictions.length;
          final wonPredictions = predictions.where((p) => p.isWon).length;
          final winRate = totalPredictions > 0
              ? (wonPredictions / totalPredictions * 100).toStringAsFixed(0)
              : '0';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                // Avatar + name
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    user.displayName.isNotEmpty
                        ? user.displayName[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(user.displayName, style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.xs),
                Chip(
                  label: Text(user.school),
                  avatar: const Icon(Icons.school, size: 16),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Token balance card
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
                      const Icon(
                        Icons.toll,
                        color: AppColors.tokenGold,
                        size: 40,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        TokenFormatter.format(user.tokens),
                        style: AppTextStyles.tokenDisplay.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'tokens',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Predictions',
                        value: '$totalPredictions',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        label: 'Win Rate',
                        value: '$winRate%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Action list
                _ActionTile(
                  icon: Icons.history,
                  label: 'Prediction History',
                  onTap: () => context.go('/profile/history'),
                ),
                _ActionTile(
                  icon: Icons.edit,
                  label: 'Change Display Name',
                  onTap: () => context.go('/profile/edit'),
                ),
                _ActionTile(
                  icon: Icons.logout,
                  label: 'Sign Out',
                  isDestructive: true,
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Sign Out'),
                        content: const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await ref.read(authRepositoryProvider).signOut();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
