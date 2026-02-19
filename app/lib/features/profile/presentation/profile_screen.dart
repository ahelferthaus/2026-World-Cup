import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/utils/token_formatter.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/user_avatar.dart';
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
          final totalPredictions = user.predictionsCount > 0
              ? user.predictionsCount
              : predictions.length;
          final wonPredictions = user.predictionsWon > 0
              ? user.predictionsWon
              : predictions.where((p) => p.isWon).length;
          final winRate = totalPredictions > 0
              ? (wonPredictions / totalPredictions * 100).toStringAsFixed(0)
              : '0';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                // Avatar + name (tap to change photo)
                EditableUserAvatar(
                  displayName: user.displayName,
                  photoUrl: user.photoUrl,
                  school: user.school,
                  radius: 44,
                  canGenerate: user.canGenerateAiPhoto,
                  onUploadTap: () {
                    // In production: use image_picker to select photo,
                    // upload to Firebase Storage, save URL to Firestore
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo upload coming soon! (requires image_picker + Firebase Storage)'),
                      ),
                    );
                  },
                  onGenerateTap: () {
                    // In production: call AI image API (DALL-E / Stability AI),
                    // save result to Firebase Storage
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AI avatar generation coming soon! (1x per week)'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Text(user.displayName, style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.xs),
                // School + State + Grade
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  alignment: WrapAlignment.center,
                  children: [
                    Chip(
                      label: Text(user.school, style: const TextStyle(fontSize: 12)),
                      avatar: const Icon(Icons.school, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    if (user.state.isNotEmpty)
                      Chip(
                        label: Text(user.state, style: const TextStyle(fontSize: 12)),
                        avatar: const Icon(Icons.location_on, size: 16),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    if (user.grade.isNotEmpty)
                      Chip(
                        label: Text(user.grade, style: const TextStyle(fontSize: 12)),
                        avatar: const Icon(Icons.grade, size: 16),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
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
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/store'),
                        icon: const Icon(Icons.add, size: 16, color: Colors.white),
                        label: const Text('Buy More Tokens', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Predictions',
                        value: '$totalPredictions',
                        icon: Icons.sports_soccer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _StatCard(
                        label: 'Win Rate',
                        value: '$winRate%',
                        icon: Icons.trending_up,
                        valueColor: double.parse(winRate) >= 50
                            ? AppColors.success
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Wagered',
                        value: TokenFormatter.format(user.totalWagered),
                        icon: Icons.casino,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _StatCard(
                        label: 'Boldness',
                        value: '${user.boldnessScore.toStringAsFixed(0)}%',
                        icon: Icons.local_fire_department,
                        valueColor: user.boldnessScore >= 60
                            ? AppColors.secondary
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Quick Links
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Quick Links', style: AppTextStyles.labelLarge),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ActionTile(
                  icon: Icons.handshake,
                  label: 'My Prop Bets',
                  onTap: () => context.push('/propbets'),
                ),
                _ActionTile(
                  icon: Icons.groups,
                  label: 'Teams & Players',
                  onTap: () => context.push('/teams'),
                ),
                _ActionTile(
                  icon: Icons.newspaper,
                  label: 'World Cup News',
                  onTap: () => context.push('/news'),
                ),
                const Divider(height: AppSpacing.xl),
                // Account actions
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
                      if (useDemoData) {
                        ref.read(demoLoggedInProvider.notifier).logout();
                      } else {
                        await ref.read(authRepositoryProvider).signOut();
                      }
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

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
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(color: valueColor),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
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
