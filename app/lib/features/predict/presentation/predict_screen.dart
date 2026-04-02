import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
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
import '../../../core/widgets/gradient_button.dart';
import 'widgets/prediction_form.dart';

class PredictScreen extends ConsumerWidget {
  const PredictScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesTodayProvider);
    final userProfile = ref.watch(userProfileProvider).valueOrNull;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Predict'),
          actions: [
            if (userProfile != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: TokenBadge(tokens: userProfile.tokens, compact: true),
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Match Winner'),
              Tab(text: 'BTTS'),
              Tab(text: 'Player Props'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Original Match Winner predictions
            matchesAsync.when(
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
                    _BettingLinesExplainer(),
                    if (userProfile != null && userProfile.tokens > 0)
                      _AllInBanner(tokens: userProfile.tokens),
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
            // Tab 2: Both Teams to Score
            _BttsTab(),
            // Tab 3: Player Props
            _PlayerPropsTab(),
          ],
        ),
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
          Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4)),
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
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
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
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => _AllInMatchPicker(tokens: tokens),
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
// ALL IN Match Picker Bottom Sheet
// ---------------------------------------------------------------------------
class _AllInMatchPicker extends StatelessWidget {
  const _AllInMatchPicker({required this.tokens});
  final int tokens;

  @override
  Widget build(BuildContext context) {
    final upcomingMatches = DemoData.matches
        .where((m) => m['status'] == 'NS')
        .map((m) => MatchModel.fromJson(m))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '\u{1F414} Pick a match to go ALL IN!',
            style: AppTextStyles.heading3.copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Wagering all $tokens tokens',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          if (upcomingMatches.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Text('No upcoming matches available.'),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              itemCount: upcomingMatches.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final match = upcomingMatches[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.sports_soccer, color: AppColors.primary),
                    title: Text(
                      '${match.homeTeam.name} vs ${match.awayTeam.name}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => PredictionForm(
                          match: match,
                          initialWager: tokens,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          const SizedBox(height: AppSpacing.xl),
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
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'O/U ${overUnder.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
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
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surfaceLight,
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
              color: isFavorite ? AppColors.primaryLight : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isFavorite ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Both Teams to Score Tab
// ---------------------------------------------------------------------------
class _BttsTab extends StatelessWidget {
  void _showMarketSheet(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double odds,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MarketPredictionSheet(
        title: title,
        subtitle: subtitle,
        odds: odds,
        onConfirm: (wager) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Prediction locked in! Wagered $wager tokens.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markets = DemoData.bttsMarkets;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: markets.length,
      itemBuilder: (context, index) {
        final m = markets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${m['home']} vs ${m['away']}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Both Teams to Score?',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _BttsButton(
                        label: 'YES',
                        odds: (m['yesOdds'] as num).toStringAsFixed(2),
                        color: AppColors.success,
                        onTap: () => _showMarketSheet(
                          context,
                          title: '${m['home']} vs ${m['away']}',
                          subtitle: 'Both Teams to Score: YES at ${(m['yesOdds'] as num).toStringAsFixed(2)}',
                          odds: (m['yesOdds'] as num).toDouble(),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _BttsButton(
                        label: 'NO',
                        odds: (m['noOdds'] as num).toStringAsFixed(2),
                        color: AppColors.lost,
                        onTap: () => _showMarketSheet(
                          context,
                          title: '${m['home']} vs ${m['away']}',
                          subtitle: 'Both Teams to Score: NO at ${(m['noOdds'] as num).toStringAsFixed(2)}',
                          odds: (m['noOdds'] as num).toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BttsButton extends StatelessWidget {
  const _BttsButton({
    required this.label,
    required this.odds,
    required this.color,
    required this.onTap,
  });
  final String label;
  final String odds;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                odds,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Player Props Tab
// ---------------------------------------------------------------------------
class _PlayerPropsTab extends StatelessWidget {
  void _showMarketSheet(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double odds,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MarketPredictionSheet(
        title: title,
        subtitle: subtitle,
        odds: odds,
        onConfirm: (wager) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Prediction locked in! Wagered $wager tokens.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final props = DemoData.playerPropMarkets;

    // Group by player
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final p in props) {
      final key = '${p['player']} (${p['team']})';
      grouped.putIfAbsent(key, () => []).add(p);
    }

    final entries = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 18, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: entry.value.map((prop) {
                    return ActionChip(
                      label: Text(
                        '${prop['prop']}  ${(prop['odds'] as num).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      avatar: Icon(Icons.bolt, size: 14, color: AppColors.accent),
                      side: BorderSide(color: AppColors.accent.withValues(alpha: 0.3)),
                      onPressed: () => _showMarketSheet(
                        context,
                        title: '${prop['player']} (${prop['team']})',
                        subtitle: '${prop['prop']} at ${(prop['odds'] as num).toStringAsFixed(2)}',
                        odds: (prop['odds'] as num).toDouble(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable Market Prediction Bottom Sheet
// ---------------------------------------------------------------------------
class _MarketPredictionSheet extends StatefulWidget {
  const _MarketPredictionSheet({
    required this.title,
    required this.subtitle,
    required this.odds,
    required this.onConfirm,
  });

  final String title;
  final String subtitle;
  final double odds;
  final void Function(int wager) onConfirm;

  @override
  State<_MarketPredictionSheet> createState() => _MarketPredictionSheetState();
}

class _MarketPredictionSheetState extends State<_MarketPredictionSheet> {
  double _wager = 5;

  int get _potentialReturn => (_wager * widget.odds).toInt();

  Future<void> _submit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Prediction'),
        content: Text(
          'Wager ${_wager.toInt()} tokens on\n${widget.subtitle}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Lock In'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Demo mode: simulate success
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    Navigator.pop(context);
    widget.onConfirm(_wager.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            // Subtitle (pick + odds)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
              ),
              child: Text(
                widget.subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Wager slider
            Text(
              'Wager: ${_wager.toInt()} tokens',
              style: AppTextStyles.heading3,
            ),
            Slider(
              value: _wager,
              min: 1,
              max: 20,
              divisions: 19,
              label: '${_wager.toInt()}',
              onChanged: (v) => setState(() => _wager = v),
            ),
            Text(
              'Potential return: ${TokenFormatter.format(_potentialReturn)} tokens',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Lock In button
            GradientButton(
              label: 'Lock In Prediction',
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
