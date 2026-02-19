import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Animated gradient orb background — creates the "video background" feel
/// that Stadium Live uses. Multiple colored orbs float and pulse behind content.
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.orbCount = 4,
    this.speed = 1.0,
  });

  final Widget child;
  final List<Color>? colors;
  final int orbCount;
  final double speed;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Orb> _orbs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (20 / widget.speed).round()),
    )..repeat();
    _orbs = _generateOrbs();
  }

  List<_Orb> _generateOrbs() {
    final rng = Random(42);
    final colors = widget.colors ??
        [
          AppColors.primary.withValues(alpha: 0.35),
          AppColors.secondary.withValues(alpha: 0.25),
          AppColors.accent.withValues(alpha: 0.2),
          AppColors.neonPink.withValues(alpha: 0.15),
          AppColors.neonBlue.withValues(alpha: 0.2),
        ];

    return List.generate(widget.orbCount, (i) {
      return _Orb(
        color: colors[i % colors.length],
        startX: rng.nextDouble(),
        startY: rng.nextDouble(),
        radiusX: 0.2 + rng.nextDouble() * 0.25,
        radiusY: 0.15 + rng.nextDouble() * 0.2,
        speedX: 0.3 + rng.nextDouble() * 0.7,
        speedY: 0.2 + rng.nextDouble() * 0.5,
        size: 0.3 + rng.nextDouble() * 0.4,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark base
        Container(color: AppColors.background),
        // Animated orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _OrbPainter(
                orbs: _orbs,
                progress: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Subtle noise/grain overlay for texture
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.background.withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _Orb {
  final Color color;
  final double startX, startY;
  final double radiusX, radiusY;
  final double speedX, speedY;
  final double size;

  _Orb({
    required this.color,
    required this.startX,
    required this.startY,
    required this.radiusX,
    required this.radiusY,
    required this.speedX,
    required this.speedY,
    required this.size,
  });
}

class _OrbPainter extends CustomPainter {
  final List<_Orb> orbs;
  final double progress;

  _OrbPainter({required this.orbs, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      final x = size.width *
          (orb.startX + sin(progress * pi * 2 * orb.speedX) * orb.radiusX);
      final y = size.height *
          (orb.startY + cos(progress * pi * 2 * orb.speedY) * orb.radiusY);
      final radius = size.width * orb.size;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color,
            orb.color.withValues(alpha: 0),
          ],
        ).createShader(
          Rect.fromCircle(center: Offset(x, y), radius: radius),
        );

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter old) => old.progress != progress;
}

/// A simpler sport-themed background with a single large gradient and particles.
class SportHeroBackground extends StatelessWidget {
  const SportHeroBackground({
    super.key,
    required this.child,
    required this.sportColor,
    this.secondaryColor,
  });

  final Widget child;
  final Color sportColor;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sportColor.withValues(alpha: 0.35),
            AppColors.background,
            (secondaryColor ?? sportColor).withValues(alpha: 0.15),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
