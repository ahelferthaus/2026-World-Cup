import 'package:flutter/material.dart';
import '../../features/home/domain/match_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../utils/date_formatter.dart';
import 'team_flag.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
  });

  final MatchModel match;
  final VoidCallback? onTap;

  Color _statusColor() {
    switch (match.status) {
      case 'LIVE':
      case '1H':
      case '2H':
      case 'HT':
      case 'ET':
        return AppColors.live;
      case 'FT':
      case 'AET':
      case 'PEN':
        return AppColors.primary;
      default:
        return AppColors.pending;
    }
  }

  String _statusLabel() {
    switch (match.status) {
      case 'NS':
        return DateFormatter.kickoffTime(match.kickoff);
      case '1H':
      case '2H':
      case 'ET':
        return DateFormatter.elapsed(match.elapsed);
      case 'HT':
        return 'HT';
      case 'FT':
        return 'FT';
      case 'AET':
        return 'AET';
      case 'PEN':
        return 'PEN';
      default:
        return match.statusLong;
    }
  }

  bool get _isLive => ['1H', '2H', 'HT', 'ET'].contains(match.status);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Status row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLive)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      decoration: const BoxDecoration(
                        color: AppColors.live,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    _statusLabel(),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Teams + Score row
              Row(
                children: [
                  // Home team
                  Expanded(
                    child: Column(
                      children: [
                        TeamFlag(logoUrl: match.homeTeam.logo, size: 40),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          match.homeTeam.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Score
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(
                      match.scoreHome != null
                          ? '${match.scoreHome} - ${match.scoreAway}'
                          : 'vs',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Away team
                  Expanded(
                    child: Column(
                      children: [
                        TeamFlag(logoUrl: match.awayTeam.logo, size: 40),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          match.awayTeam.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
