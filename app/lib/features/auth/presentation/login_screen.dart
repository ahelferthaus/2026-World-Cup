import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/extensions/context_extensions.dart';
import 'providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  void _handleDemoLogin() {
    ref.read(demoLoggedInProvider.notifier).login();
  }

  Future<void> _handleGoogleSignIn() async {
    if (useDemoData) { _handleDemoLogin(); return; }
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Google sign-in failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithApple();
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Apple sign-in failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // App branding
                const Icon(
                  Icons.sports_soccer,
                  size: 80,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '2026 World Cup',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'CENTAURUS',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 4,
                  ),
                ),
                const Spacer(flex: 2),
                // Sign-in buttons
                if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ...[
                  _SignInButton(
                    label: 'Sign in with Apple',
                    icon: Icons.apple,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: _isLoading ? null : _handleAppleSignIn,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                _SignInButton(
                  label: 'Sign in with Google',
                  icon: Icons.g_mobiledata,
                  backgroundColor: Colors.white,
                  textColor: AppColors.textPrimary,
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                ),
                const SizedBox(height: AppSpacing.md),
                _SignInButton(
                  label: 'Sign in with Email',
                  icon: Icons.email_outlined,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.textOnPrimary,
                  border: true,
                  onPressed: _isLoading ? null : () {
                    if (useDemoData) { _handleDemoLogin(); return; }
                    context.go('/register');
                  },
                ),
                const Spacer(),
                // Disclaimer
                Text(
                  'No real money. Just bragging rights.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.border = false,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 24),
        label: Text(
          label,
          style: AppTextStyles.buttonText.copyWith(color: textColor),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: border
              ? const BorderSide(color: AppColors.textOnPrimary)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
      ),
    );
  }
}
