import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Full-screen coin rain overlay for wins.
/// Shows animated coins raining down with rotation and scale effects.
class CoinRainOverlay extends StatefulWidget {
  const CoinRainOverlay({
    super.key,
    required this.child,
    required this.trigger,
    this.coinCount = 30,
    this.duration = const Duration(seconds: 3),
    this.tokenAmount,
  });

  final Widget child;

  /// Set to true to trigger the animation. Resets when set back to false.
  final bool trigger;

  /// Number of coins to rain down
  final int coinCount;

  /// How long the animation runs
  final Duration duration;

  /// If provided, shows "+{amount}" text in the center during animation
  final int? tokenAmount;

  @override
  State<CoinRainOverlay> createState() => _CoinRainOverlayState();
}

class _CoinRainOverlayState extends State<CoinRainOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_CoinData> _coins;
  bool _showingAnimation = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _coins = _generateCoins();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showingAnimation = false);
      }
    });
  }

  @override
  void didUpdateWidget(CoinRainOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _coins = _generateCoins();
      _showingAnimation = true;
      _controller.forward(from: 0);
    }
  }

  List<_CoinData> _generateCoins() {
    final rng = Random();
    return List.generate(widget.coinCount, (i) {
      return _CoinData(
        startX: rng.nextDouble(),
        startDelay: rng.nextDouble() * 0.4, // stagger start
        speed: 0.6 + rng.nextDouble() * 0.6, // vary fall speed
        wobbleAmplitude: 10 + rng.nextDouble() * 20,
        wobbleFrequency: 2 + rng.nextDouble() * 3,
        size: 20 + rng.nextDouble() * 16,
        rotationSpeed: 1 + rng.nextDouble() * 3,
        emoji: rng.nextBool() ? '\u{1FA99}' : '\u{1F4B0}', // 🪙 or 💰
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
        widget.child,
        if (_showingAnimation) ...[
          // Coin rain
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _CoinRainPainter(
                      coins: _coins,
                      progress: _controller.value,
                    ),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
          // Emoji coins (more visible than custom paint)
          ..._coins.map((coin) {
            return _AnimatedCoinWidget(
              coin: coin,
              animation: _controller,
            );
          }),
          // Center token amount badge
          if (widget.tokenAmount != null)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
                      ),
                    ),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.gradientGold,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tokenGold.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '+${widget.tokenAmount}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _CoinData {
  final double startX;
  final double startDelay;
  final double speed;
  final double wobbleAmplitude;
  final double wobbleFrequency;
  final double size;
  final double rotationSpeed;
  final String emoji;

  _CoinData({
    required this.startX,
    required this.startDelay,
    required this.speed,
    required this.wobbleAmplitude,
    required this.wobbleFrequency,
    required this.size,
    required this.rotationSpeed,
    required this.emoji,
  });
}

class _AnimatedCoinWidget extends StatelessWidget {
  const _AnimatedCoinWidget({
    required this.coin,
    required this.animation,
  });

  final _CoinData coin;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        final adjustedT = ((t - coin.startDelay) / coin.speed).clamp(0.0, 1.0);
        if (adjustedT <= 0) return const SizedBox.shrink();

        final screenSize = MediaQuery.of(context).size;
        final x = coin.startX * screenSize.width +
            sin(adjustedT * coin.wobbleFrequency * pi * 2) *
                coin.wobbleAmplitude;
        final y = -coin.size + adjustedT * (screenSize.height + coin.size * 2);
        final opacity = adjustedT < 0.8 ? 1.0 : (1.0 - adjustedT) / 0.2;
        final rotation = adjustedT * coin.rotationSpeed * pi * 2;

        return Positioned(
          left: x,
          top: y,
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.rotate(
                angle: rotation,
                child: Text(
                  coin.emoji,
                  style: TextStyle(fontSize: coin.size),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Fallback custom painter (not used when emoji coins are showing)
class _CoinRainPainter extends CustomPainter {
  _CoinRainPainter({required this.coins, required this.progress});

  final List<_CoinData> coins;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // The emoji widgets handle rendering, so this is just a shimmer overlay
    if (progress < 0.5) {
      final shimmerPaint = Paint()
        ..color = AppColors.tokenGold.withValues(alpha: 0.05 * (1 - progress * 2))
        ..style = PaintingStyle.fill;
      canvas.drawRect(Offset.zero & size, shimmerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CoinRainPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
