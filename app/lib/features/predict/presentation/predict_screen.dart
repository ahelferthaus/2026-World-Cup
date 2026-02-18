import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/utils/token_formatter.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/match_card.dart';
import '../../../core/widgets/token_badge.dart';
import '../../home/domain/match_model.dart';
import '../../home/presentation/providers/matches_providers.dart';
import '../../profile/presentation/providers/profile_providers.dart';
import 'widgets/prediction_form.dart';

class PredictScreen extends ConsumerWidget {
  const PredictScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesTodayProvider);
    final userProfile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict'),
        actions: [
          if (userProfile != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: TokenBadge(tokens: userProfile.tokens, compact: true),
            ),
        ],
      ),
      body: matchesAsync.when(
        loading: () => const AppLoadingIndicator(message: 'Loading matches...'),
        error: (error, _) => AppErrorWidget(
          message: 'Could not load matches.',
          onRetry: () => ref.invalidate(matchesTodayProvider),
        ),
        data: (matches) {
          final upcoming = matches.where((m) => m.isUpcoming).toList();

          if (upcoming.isEmpty) {
            return const AppEmptyState(
              icon: Icons.sports_soccer,
              title: 'No upcoming matches',
              subtitle: 'Predictions open before kickoff. Check back later!',
            );
          }

          return Column(
            children: [
              // Betting Lines Explainer Banner
              _BettingLinesExplainer(),
              // ALL IN Button
              if (userProfile != null && userProfile.tokens > 0)
                _AllInBanner(tokens: userProfile.tokens),
              // Match List with Odds
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: upcoming.length,
                  itemBuilder: (context, index) {
                    final match = upcoming[index];
                    return Column(
                      children: [
                        MatchCard(
                          match: match,
                          onTap: () => _openPredictionForm(context, match),
                        ),
                        // Odds chips below each match
                        _OddsRow(match: match),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openPredictionForm(BuildContext context, MatchModel match) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PredictionForm(match: match),
    );
  }
}

// ---------------------------------------------------------------------------
// Betting Lines Explainer Banner
// ---------------------------------------------------------------------------
class _BettingLinesExplainer extends StatefulWidget {
  @override
  State<_BettingLinesExplainer> createState() => _BettingLinesExplainerState();
}

class _BettingLinesExplainerState extends State<_BettingLinesExplainer> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 18, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  const Text(
                    'How do betting lines work?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  _explainerItem(
                    'Odds (like 2.50)',
                    'This means for every 1 token you bet, you could win 2.50 back. Higher odds = less likely to happen but bigger payout!',
                  ),
                  _explainerItem(
                    'Favorite vs Underdog',
                    'The team with LOWER odds is the favorite (expected to win). The team with HIGHER odds is the underdog.',
                  ),
                  _explainerItem(
                    'Over/Under 2.5',
                    'Betting on whether the total goals scored will be MORE than 2.5 (Over) or LESS than 2.5 (Under). Since you can\'t score half a goal, Over means 3+ goals.',
                  ),
                  _explainerItem(
                    'Draw',
                    'Neither team wins - the match ends in a tie. Draw odds are usually around 3.00-3.50.',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _explainerItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.primary),
          ),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ALL IN Banner with Rooster
// ---------------------------------------------------------------------------
class _AllInBanner extends StatelessWidget {
  const _AllInBanner({required this.tokens});
  final int tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAllInDialog(context),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondary, Color(0xFFFF9100)],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '\u{1F414}',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'ALL IN',
                    style: AppTextStyles.heading3.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '($tokens tokens)',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Text(
                    '\u{1F414}',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAllInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _AllInRoosterDialog(tokens: tokens),
    );
  }
}

class _AllInRoosterDialog extends StatelessWidget {
  const _AllInRoosterDialog({required this.tokens});
  final int tokens;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.xl),
      ),
      contentPadding: const EdgeInsets.all(AppSpacing.xl),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Big rooster
          const Text(
            '\u{1F413}',
            style: TextStyle(fontSize: 72),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Look who's got the juice!",
            style: AppTextStyles.heading3.copyWith(color: AppColors.secondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You\'re about to go ALL IN with all $tokens tokens on a single prediction.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${TokenFormatter.format(tokens)} tokens',
            style: AppTextStyles.heading2.copyWith(color: AppColors.tokenGoldDark),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Pick a match above, then bet everything.\nNo guts, no glory!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('\u{1F414}'),
                      SizedBox(width: 6),
                      Text('Chicken Out'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pick a match and slide the wager to max! \u{1F525}'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('\u{1F413}'),
                      SizedBox(width: 6),
                      Text("LET'S GO"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Odds Row under each match
// ---------------------------------------------------------------------------
class _OddsRow extends StatelessWidget {
  const _OddsRow({required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    // Try to get odds from raw data (demo data stores them)
    final odds = match.rawData?['odds'] as Map<String, dynamic>?;
    if (odds == null) return const SizedBox.shrink();

    final homeOdds = odds['home'] as num?;
    final drawOdds = odds['draw'] as num?;
    final awayOdds = odds['away'] as num?;
    final overUnder = odds['overUnder'] as num?;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      child: Row(
        children: [
          if (homeOdds != null)
            _OddsChip(label: 'Home', value: homeOdds.toStringAsFixed(2), isFavorite: _isFavorite(homeOdds, awayOdds)),
          const SizedBox(width: AppSpacing.xs),
          if (drawOdds != null)
            _OddsChip(label: 'Draw', value: drawOdds.toStringAsFixed(2)),
          const SizedBox(width: AppSpacing.xs),
          if (awayOdds != null)
            _OddsChip(label: 'Away', value: awayOdds.toStringAsFixed(2), isFavorite: _isFavorite(awayOdds, homeOdds)),
          const Spacer(),
          if (overUnder != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'O/U ${overUnder.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  bool _isFavorite(num? thisOdds, num? otherOdds) {
    if (thisOdds == null || otherOdds == null) return false;
    return thisOdds < otherOdds;
  }
}

class _OddsChip extends StatelessWidget {
  const _OddsChip({required this.label, required this.value, this.isFavorite = false});
  final String label;
  final String value;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isFavorite
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: isFavorite
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isFavorite ? AppColors.primary : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isFavorite ? AppColors.primary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
