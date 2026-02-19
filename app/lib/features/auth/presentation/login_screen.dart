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

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

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
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A0E3E),
                  AppColors.background,
                  Color(0xFF0A1628),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Animated glow orbs
          Positioned(
            top: -80,
            right: -60,
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (_, __) => Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15 + _glowController.value * 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (_, __) => Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.08 + _glowController.value * 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Glowing soccer ball
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (_, __) => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.3),
                            AppColors.primaryDark.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          radius: 0.8 + _glowController.value * 0.2,
                        ),
                      ),
                      child: const Center(
                        child: Text('\u26BD', style: TextStyle(fontSize: 56)),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Title with gradient shimmer
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.textPrimary, AppColors.primaryLight],
                    ).createShader(bounds),
                    child: Text(
                      '2026 WORLD CUP',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Tagline pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          AppColors.primaryDark.withValues(alpha: 0.2),
                        ],
                      ),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'PREDICT \u2022 COMPETE \u2022 WIN',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryLight,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Bet against your friends.\nNo real money. All bragging rights.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Sign-in buttons
                  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ...[
                    _GlowButton(
                      label: 'Sign in with Apple',
                      icon: Icons.apple,
                      gradient: const [Colors.white, Color(0xFFE0E0E0)],
                      textColor: Colors.black,
                      onPressed: _isLoading ? null : _handleAppleSignIn,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  _GlowButton(
                    label: 'Sign in with Google',
                    icon: Icons.g_mobiledata,
                    gradient: AppColors.gradientPrimary,
                    textColor: Colors.white,
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _GlowButton(
                    label: 'Sign in with Email',
                    icon: Icons.email_outlined,
                    gradient: null,
                    textColor: AppColors.textPrimary,
                    outlined: true,
                    onPressed: _isLoading ? null : () {
                      if (useDemoData) { _handleDemoLogin(); return; }
                      context.go('/register');
                    },
                  ),
                  const Spacer(),
                  // Token teaser
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('\u{1F3C6}', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        'Get 500 free tokens when you sign up',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.tokenGold),
                      ),
                      const SizedBox(width: 6),
                      const Text('\u{1F3C6}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowButton extends StatelessWidget {
  const _GlowButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.textColor,
    required this.onPressed,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final List<Color>? gradient;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: textColor, size: 22),
              label: Text(
                label,
                style: AppTextStyles.buttonText.copyWith(color: textColor),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: gradient != null ? LinearGradient(colors: gradient!) : null,
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                boxShadow: gradient != null
                    ? [
                        BoxShadow(
                          color: (gradient!.first).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPressed,
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: textColor, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          label,
                          style: AppTextStyles.buttonText.copyWith(color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
