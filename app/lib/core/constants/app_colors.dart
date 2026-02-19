import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Stadium-quality dark theme palette
  // ---------------------------------------------------------------------------

  // Primary — electric blue / neon blue
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFF9B8FFF);
  static const primaryDark = Color(0xFF3D2E9E);
  static const primaryGlow = Color(0x406C5CE7);

  // Secondary — neon green (the "win" color, like Stadium Live)
  static const secondary = Color(0xFF00E676);
  static const secondaryLight = Color(0xFF69F0AE);
  static const secondaryDark = Color(0xFF00C853);

  // Accent — hot orange for CTAs
  static const accent = Color(0xFFFF6D00);
  static const accentLight = Color(0xFFFF9E40);

  // Success (aliases for green)
  static const success = Color(0xFF00E676);
  static const successDark = Color(0xFF00C853);

  // Neon highlights
  static const neonPurple = Color(0xFFBB86FC);
  static const neonCyan = Color(0xFF00E5FF);
  static const neonPink = Color(0xFFFF4081);
  static const neonBlue = Color(0xFF448AFF);

  // Sport-specific brand colors
  static const nbaOrange = Color(0xFFF37321);
  static const nbaBlue = Color(0xFF1D428A);
  static const nbaRed = Color(0xFFC8102E);

  // Challenge category colors
  static const challengeSports = Color(0xFFF37321);
  static const challengeCustom = Color(0xFFE040FB);
  static const challengeParty = Color(0xFFFFD600);
  static const disputed = Color(0xFFFF9100);

  // Status colors
  static const live = Color(0xFF00E676);
  static const pending = Color(0xFF78909C);
  static const lost = Color(0xFFFF5252);
  static const won = Color(0xFF00E676);

  // Surfaces — dark with depth
  static const background = Color(0xFF0D0B1E);
  static const surface = Color(0xFF1A1730);
  static const surfaceLight = Color(0xFF252240);
  static const surfaceCard = Color(0xFF1E1B35);
  static const surfaceElevated = Color(0xFF2A2650);

  // Text
  static const textPrimary = Color(0xFFF0F0F0);
  static const textSecondary = Color(0xFF9E9BB0);
  static const textMuted = Color(0xFF6B6880);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textOnDark = Color(0xFFE0E0E0);

  // Dividers / borders
  static const divider = Color(0xFF2A2745);
  static const border = Color(0xFF3A3755);

  // Token gold — premium feel
  static const tokenGold = Color(0xFFFFD700);
  static const tokenGoldDark = Color(0xFFFFC107);
  static const tokenGlow = Color(0x40FFD700);

  // Podium
  static const gold = Color(0xFFFFD700);
  static const silver = Color(0xFFC0C0C0);
  static const bronze = Color(0xFFCD7F32);

  // Bracket
  static const bracketLine = Color(0xFF5C5880);
  static const bracketWinner = Color(0xFF00E676);

  // Gradient presets
  static const gradientPrimary = [Color(0xFF6C5CE7), Color(0xFF3D2E9E)];
  static const gradientAccent = [Color(0xFFFF6D00), Color(0xFFFF9100)];
  static const gradientWin = [Color(0xFF00E676), Color(0xFF00C853)];
  static const gradientSurface = [Color(0xFF1A1730), Color(0xFF0D0B1E)];
  static const gradientCard = [Color(0xFF252240), Color(0xFF1A1730)];
  static const gradientGold = [Color(0xFFFFD700), Color(0xFFFFA000)];
}
