import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Categories for P2P challenges.
enum ChallengeCategory {
  sports,
  custom,
  partyGame;

  String get displayName => switch (this) {
        sports => 'Sports',
        custom => 'Custom',
        partyGame => 'Party Game',
      };

  String get emoji => switch (this) {
        sports => '\u{1F3C0}',
        custom => '\u2728',
        partyGame => '\u{1F3B2}',
      };

  IconData get icon => switch (this) {
        sports => Icons.sports,
        custom => Icons.auto_awesome,
        partyGame => Icons.celebration,
      };

  Color get color => switch (this) {
        sports => AppColors.nbaOrange,
        custom => const Color(0xFFE040FB),
        partyGame => const Color(0xFFFFD600),
      };

  static ChallengeCategory fromString(String value) => switch (value) {
        'sports' => sports,
        'custom' => custom,
        'partyGame' || 'party_game' => partyGame,
        _ => custom,
      };
}
