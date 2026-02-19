import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';

class BracketScreen extends StatelessWidget {
  const BracketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bracket = DemoData.bracket;
    final round16 = bracket['round16'] as List<Map<String, dynamic>>;
    final quarter = bracket['quarter'] as List<Map<String, dynamic>>;
    final semi = bracket['semi'] as List<Map<String, dynamic>>;
    final finalMatch = bracket['final'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Bracket'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 900,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Round of 16
                _BracketColumn(
                  label: 'Round of 16',
                  matches: round16,
                  cardWidth: 190,
                ),
                const SizedBox(width: AppSpacing.md),
                // Quarterfinals
                _BracketColumn(
                  label: 'Quarterfinals',
                  matches: quarter,
                  cardWidth: 190,
                  topPadding: 40,
                  spacing: 80,
                ),
                const SizedBox(width: AppSpacing.md),
                // Semifinals
                _BracketColumn(
                  label: 'Semifinals',
                  matches: semi,
                  cardWidth: 190,
                  topPadding: 120,
                  spacing: 240,
                ),
                const SizedBox(width: AppSpacing.md),
                // Final
                _BracketColumn(
                  label: 'Final',
                  matches: finalMatch,
                  cardWidth: 200,
                  topPadding: 280,
                  isFinal: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BracketColumn extends StatelessWidget {
  const _BracketColumn({
    required this.label,
    required this.matches,
    required this.cardWidth,
    this.topPadding = 0,
    this.spacing = 0,
    this.isFinal = false,
  });

  final String label;
  final List<Map<String, dynamic>> matches;
  final double cardWidth;
  final double topPadding;
  final double spacing;
  final bool isFinal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Round label
        Container(
          width: cardWidth,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: isFinal ? AppColors.secondary : AppColors.primary,
              fontSize: isFinal ? 16 : 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (isFinal)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text('\u{1F3C6}', style: TextStyle(fontSize: 36)),
          ),
        SizedBox(height: topPadding),
        ...List.generate(matches.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < matches.length - 1 ? spacing + AppSpacing.sm : 0),
            child: _BracketMatchCard(
              match: matches[index],
              width: cardWidth,
              isFinal: isFinal,
            ),
          );
        }),
      ],
    );
  }
}

class _BracketMatchCard extends StatelessWidget {
  const _BracketMatchCard({
    required this.match,
    required this.width,
    this.isFinal = false,
  });

  final Map<String, dynamic> match;
  final double width;
  final bool isFinal;

  @override
  Widget build(BuildContext context) {
    final home = match['home'] as String;
    final away = match['away'] as String;
    final homeLogo = match['homeLogo'] as String;
    final awayLogo = match['awayLogo'] as String;
    final scoreHome = match['scoreHome'] as int?;
    final scoreAway = match['scoreAway'] as int?;
    final played = match['played'] as bool;
    final penaltyHome = match['penaltyHome'] as int?;
    final penaltyAway = match['penaltyAway'] as int?;

    final bool homeWins;
    if (!played) {
      homeWins = false;
    } else if (penaltyHome != null && penaltyAway != null) {
      homeWins = penaltyHome > penaltyAway;
    } else {
      homeWins = (scoreHome ?? 0) > (scoreAway ?? 0);
    }
    final awayWins = played && !homeWins;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isFinal
              ? AppColors.secondary.withValues(alpha: 0.4)
              : AppColors.divider,
          width: isFinal ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TeamRow(
            name: home,
            logo: homeLogo,
            score: scoreHome,
            isWinner: homeWins,
            penaltyScore: penaltyHome,
            played: played,
          ),
          Divider(height: 1, color: AppColors.divider.withValues(alpha: 0.5)),
          _TeamRow(
            name: away,
            logo: awayLogo,
            score: scoreAway,
            isWinner: awayWins,
            penaltyScore: penaltyAway,
            played: played,
          ),
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  const _TeamRow({
    required this.name,
    required this.logo,
    required this.score,
    required this.isWinner,
    required this.played,
    this.penaltyScore,
  });

  final String name;
  final String logo;
  final int? score;
  final bool isWinner;
  final bool played;
  final int? penaltyScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isWinner
            ? AppColors.bracketWinner.withValues(alpha: 0.06)
            : null,
      ),
      child: Row(
        children: [
          // Team logo
          if (logo.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                logo,
                width: 20,
                height: 20,
                errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 20),
              ),
            )
          else
            Icon(Icons.help_outline, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 6),
          // Team name
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: isWinner ? FontWeight.w700 : FontWeight.w400,
                color: !played && name == 'TBD'
                    ? AppColors.textMuted
                    : isWinner
                        ? AppColors.bracketWinner
                        : AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Score
          if (played && score != null) ...[
            Text(
              '$score',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isWinner ? AppColors.bracketWinner : AppColors.textSecondary,
              ),
            ),
            if (penaltyScore != null)
              Text(
                ' ($penaltyScore)',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ] else if (!played)
            Text(
              '-',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}
