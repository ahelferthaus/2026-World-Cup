import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// A compact mini soccer pitch visualization with team info, score, and match minute.
class PitchVisualization extends StatelessWidget {
  const PitchVisualization({
    super.key,
    required this.homeName,
    required this.awayName,
    required this.homeLogo,
    required this.awayLogo,
    required this.homeScore,
    required this.awayScore,
    required this.minute,
    required this.isLive,
  });

  final String homeName;
  final String awayName;
  final String homeLogo;
  final String awayLogo;
  final int homeScore;
  final int awayScore;
  final int minute;
  final bool isLive;

  String _abbreviate(String name) {
    if (name.length <= 3) return name.toUpperCase();
    return name.substring(0, 3).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: const Color(0xFF0D3B0F), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Pitch lines painted via CustomPaint
          Positioned.fill(
            child: CustomPaint(
              painter: _PitchPainter(),
            ),
          ),

          // Score at center top
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isLive
                        ? AppColors.neonCyan.withValues(alpha: 0.5)
                        : AppColors.divider,
                  ),
                ),
                child: Text(
                  '$homeScore - $awayScore',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),

          // Minute at center bottom
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isLive
                        ? AppColors.live.withValues(alpha: 0.4)
                        : AppColors.divider,
                  ),
                ),
                child: Text(
                  isLive ? "$minute'" : 'FT',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: isLive ? AppColors.live : AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),

          // Home team badge (left half)
          Positioned(
            left: 30,
            top: 0,
            bottom: 0,
            child: Center(
              child: _TeamBadge(
                name: _abbreviate(homeName),
                logo: homeLogo,
              ),
            ),
          ),

          // Away team badge (right half)
          Positioned(
            right: 30,
            top: 0,
            bottom: 0,
            child: Center(
              child: _TeamBadge(
                name: _abbreviate(awayName),
                logo: awayLogo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular badge showing a team logo or abbreviation.
class _TeamBadge extends StatelessWidget {
  const _TeamBadge({required this.name, required this.logo});

  final String name;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface.withValues(alpha: 0.85),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow,
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              logo,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// CustomPainter that draws the soccer pitch markings.
class _PitchPainter extends CustomPainter {
  static const _lineColor = Color(0xFF4CAF50);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final w = size.width;
    final h = size.height;
    final inset = 12.0;

    // Outer boundary
    canvas.drawRect(
      Rect.fromLTWH(inset, inset, w - inset * 2, h - inset * 2),
      paint,
    );

    // Center line (vertical)
    canvas.drawLine(
      Offset(w / 2, inset),
      Offset(w / 2, h - inset),
      paint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(w / 2, h / 2),
      28,
      paint,
    );

    // Center dot
    final dotPaint = Paint()
      ..color = _lineColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h / 2), 3, dotPaint);

    // --- Penalty areas (large boxes) ---
    const penaltyW = 52.0;
    const penaltyH = 90.0;
    final penaltyTop = (h - penaltyH) / 2;

    // Left penalty area
    canvas.drawRect(
      Rect.fromLTWH(inset, penaltyTop, penaltyW, penaltyH),
      paint,
    );

    // Right penalty area
    canvas.drawRect(
      Rect.fromLTWH(w - inset - penaltyW, penaltyTop, penaltyW, penaltyH),
      paint,
    );

    // --- Goal areas (small boxes) ---
    const goalW = 22.0;
    const goalH = 46.0;
    final goalTop = (h - goalH) / 2;

    // Left goal area
    canvas.drawRect(
      Rect.fromLTWH(inset, goalTop, goalW, goalH),
      paint,
    );

    // Right goal area
    canvas.drawRect(
      Rect.fromLTWH(w - inset - goalW, goalTop, goalW, goalH),
      paint,
    );

    // --- Penalty arcs ---
    final arcPaint = Paint()
      ..color = _lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Left arc
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(inset + penaltyW, penaltyTop, 20, penaltyH));
    canvas.drawCircle(
      Offset(inset + penaltyW - 8, h / 2),
      22,
      arcPaint,
    );
    canvas.restore();

    // Right arc
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(w - inset - penaltyW - 20, penaltyTop, 20, penaltyH));
    canvas.drawCircle(
      Offset(w - inset - penaltyW + 8, h / 2),
      22,
      arcPaint,
    );
    canvas.restore();

    // --- Corner arcs ---
    const cornerR = 8.0;
    // Top-left
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(inset, inset, cornerR, cornerR));
    canvas.drawCircle(Offset(inset, inset), cornerR, paint);
    canvas.restore();

    // Bottom-left
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(inset, h - inset - cornerR, cornerR, cornerR));
    canvas.drawCircle(Offset(inset, h - inset), cornerR, paint);
    canvas.restore();

    // Top-right
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(w - inset - cornerR, inset, cornerR, cornerR));
    canvas.drawCircle(Offset(w - inset, inset), cornerR, paint);
    canvas.restore();

    // Bottom-right
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(w - inset - cornerR, h - inset - cornerR, cornerR, cornerR));
    canvas.drawCircle(Offset(w - inset, h - inset), cornerR, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
