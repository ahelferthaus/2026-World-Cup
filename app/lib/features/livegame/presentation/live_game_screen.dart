import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/utils/token_formatter.dart';

/// Live Game Session — real-time intragame friend betting with running tally.
/// This is the killer feature that Stadium Live doesn't have.
class LiveGameScreen extends ConsumerStatefulWidget {
  const LiveGameScreen({super.key, required this.matchId});
  final String matchId;

  @override
  ConsumerState<LiveGameScreen> createState() => _LiveGameScreenState();
}

class _LiveGameScreenState extends ConsumerState<LiveGameScreen>
    with SingleTickerProviderStateMixin {
  // Demo state — in production this comes from Firestore real-time listeners
  int _homeScore = 0;
  int _awayScore = 0;
  int _minute = 0;
  bool _isLive = true;
  String _homeName = '';
  String _awayName = '';
  String _homeLogo = '';
  String _awayLogo = '';

  // Player's running tally
  int _myTokensWon = 0;
  int _friendTokensWon = 0;
  final String _friendName = 'Jake_Baller';
  int _myAvailableTokens = 500;

  // Live bets
  final List<_LiveBet> _activeBets = [];
  final List<_LiveBet> _resolvedBets = [];

  // Simulated game events
  Timer? _gameTimer;
  late AnimationController _pulseController;
  final List<_GameEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _loadMatchData();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _startDemoSimulation();
  }

  void _loadMatchData() {
    // Find match from demo data
    final matches = DemoData.matches;
    final match = matches.firstWhere(
      (m) => '${m['id']}' == widget.matchId,
      orElse: () => matches.first,
    );
    _homeName = (match['homeTeam'] as Map)['name'] as String;
    _awayName = (match['awayTeam'] as Map)['name'] as String;
    _homeLogo = (match['homeTeam'] as Map)['logo'] as String;
    _awayLogo = (match['awayTeam'] as Map)['logo'] as String;
  }

  void _startDemoSimulation() {
    _gameTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isLive || !mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _minute += 5;
        if (_minute >= 90) {
          _isLive = false;
          _minute = 90;
          return;
        }
        // Simulate random events
        if (_minute == 25) {
          _homeScore++;
          _events.insert(0, _GameEvent('\u26BD GOAL! $_homeName scores!', _minute, true));
          _resolveGoalBets(true);
        } else if (_minute == 55) {
          _awayScore++;
          _events.insert(0, _GameEvent('\u26BD GOAL! $_awayName equalizes!', _minute, false));
          _resolveGoalBets(false);
        } else if (_minute == 78) {
          _homeScore++;
          _events.insert(0, _GameEvent('\u26BD GOAL! $_homeName takes the lead!', _minute, true));
          _resolveGoalBets(true);
        }
      });
    });
  }

  void _resolveGoalBets(bool homeScored) {
    final toResolve = _activeBets.where((b) => b.betType == 'nextGoal').toList();
    for (final bet in toResolve) {
      final won = (bet.choice == 'home' && homeScored) ||
          (bet.choice == 'away' && !homeScored);
      setState(() {
        _activeBets.remove(bet);
        _resolvedBets.insert(0, bet.copyWith(resolved: true, won: won));
        if (won) {
          _myTokensWon += bet.wager * 2;
          _myAvailableTokens += bet.wager * 2;
        } else {
          _friendTokensWon += bet.wager;
        }
      });
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientSurface,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildScoreboard(),
              _buildTallyBar(),
              Expanded(
                child: _buildBetFeed(),
              ),
              _buildQuickBetBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          // LIVE indicator
          if (_isLive)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.live.withValues(alpha: 0.15 + _pulseController.value * 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.live.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.live,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.live.withValues(alpha: _pulseController.value * 0.8),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE \u2022 $_minute\'',
                      style: const TextStyle(
                        color: AppColors.live,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'FULL TIME',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          const Spacer(),
          // Token count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.tokenGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.tokenGold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.toll, size: 14, color: AppColors.tokenGold),
                const SizedBox(width: 4),
                Text(
                  TokenFormatter.format(_myAvailableTokens),
                  style: const TextStyle(
                    color: AppColors.tokenGold,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.gradientCard),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Home team
          Expanded(
            child: Column(
              children: [
                Image.network(_homeLogo, width: 40, height: 40,
                    errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 40)),
                const SizedBox(height: 6),
                Text(
                  _homeName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_homeScore - $_awayScore',
              style: AppTextStyles.scoreText.copyWith(color: AppColors.textPrimary),
            ),
          ),
          // Away team
          Expanded(
            child: Column(
              children: [
                Image.network(_awayLogo, width: 40, height: 40,
                    errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 40)),
                const SizedBox(height: 6),
                Text(
                  _awayName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTallyBar() {
    final myLeading = _myTokensWon > _friendTokensWon;
    final tied = _myTokensWon == _friendTokensWon;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: myLeading
              ? [AppColors.secondary.withValues(alpha: 0.15), AppColors.surfaceCard]
              : tied
                  ? [AppColors.surfaceCard, AppColors.surfaceCard]
                  : [AppColors.surfaceCard, AppColors.lost.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: myLeading
              ? AppColors.secondary.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          // My tally
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You',
                  style: TextStyle(
                    fontSize: 11,
                    color: myLeading ? AppColors.secondary : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '+${TokenFormatter.format(_myTokensWon)}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: myLeading ? AppColors.secondary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // VS badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: AppColors.textMuted,
                letterSpacing: 2,
              ),
            ),
          ),
          // Friend tally
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _friendName,
                  style: TextStyle(
                    fontSize: 11,
                    color: !myLeading && !tied ? AppColors.lost : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '+${TokenFormatter.format(_friendTokensWon)}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: !myLeading && !tied ? AppColors.lost : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBetFeed() {
    final allItems = [
      ..._activeBets.map((b) => _FeedItem(bet: b, isEvent: false)),
      ..._resolvedBets.map((b) => _FeedItem(bet: b, isEvent: false)),
      ..._events.map((e) => _FeedItem(event: e, isEvent: true)),
    ];
    allItems.sort((a, b) {
      final aMin = a.isEvent ? a.event!.minute : a.bet!.minute;
      final bMin = b.isEvent ? b.event!.minute : b.bet!.minute;
      return bMin.compareTo(aMin);
    });

    if (allItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('\u26A1', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Game is live! Place a bet below.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        if (item.isEvent) return _EventCard(event: item.event!);
        return _BetCard(bet: item.bet!);
      },
    );
  }

  Widget _buildQuickBetBar() {
    if (!_isLive) {
      return _buildEndGameSummary();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Quick Bet vs $_friendName',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _QuickBetChip(
                  label: '$_homeName scores next',
                  tokens: 50,
                  color: AppColors.primary,
                  onTap: () => _placeBet('nextGoal', 'home', 50),
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickBetChip(
                  label: '$_awayName scores next',
                  tokens: 50,
                  color: AppColors.accent,
                  onTap: () => _placeBet('nextGoal', 'away', 50),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _QuickBetChip(
                  label: 'No more goals',
                  tokens: 30,
                  color: AppColors.neonCyan,
                  onTap: () => _placeBet('noGoal', 'none', 30),
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickBetChip(
                  label: 'Next goal < 10 min',
                  tokens: 75,
                  color: AppColors.neonPink,
                  onTap: () => _placeBet('quickGoal', 'any', 75),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndGameSummary() {
    final myWin = _myTokensWon > _friendTokensWon;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: myWin ? AppColors.gradientWin : [AppColors.surface, AppColors.surfaceLight],
        ),
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              myWin ? '\u{1F525} YOU WON THE NIGHT!' : '\u{1F614} Better luck next time',
              style: AppTextStyles.heading3.copyWith(
                color: myWin ? AppColors.background : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You: +${TokenFormatter.format(_myTokensWon)} vs $_friendName: +${TokenFormatter.format(_friendTokensWon)}',
              style: TextStyle(
                color: myWin ? AppColors.background.withValues(alpha: 0.8) : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeBet(String type, String choice, int wager) {
    if (_myAvailableTokens < wager) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough tokens!')),
      );
      return;
    }
    setState(() {
      _myAvailableTokens -= wager;
      _activeBets.add(_LiveBet(
        betType: type,
        choice: choice,
        wager: wager,
        minute: _minute,
        description: _betDescription(type, choice),
      ));
    });
  }

  String _betDescription(String type, String choice) {
    switch (type) {
      case 'nextGoal':
        return choice == 'home'
            ? '$_homeName scores next'
            : '$_awayName scores next';
      case 'noGoal':
        return 'No more goals this half';
      case 'quickGoal':
        return 'Next goal within 10 minutes';
      default:
        return type;
    }
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------
class _LiveBet {
  final String betType;
  final String choice;
  final int wager;
  final int minute;
  final String description;
  final bool resolved;
  final bool won;

  const _LiveBet({
    required this.betType,
    required this.choice,
    required this.wager,
    required this.minute,
    required this.description,
    this.resolved = false,
    this.won = false,
  });

  _LiveBet copyWith({bool? resolved, bool? won}) => _LiveBet(
        betType: betType,
        choice: choice,
        wager: wager,
        minute: minute,
        description: description,
        resolved: resolved ?? this.resolved,
        won: won ?? this.won,
      );
}

class _GameEvent {
  final String text;
  final int minute;
  final bool isHome;
  const _GameEvent(this.text, this.minute, this.isHome);
}

class _FeedItem {
  final _LiveBet? bet;
  final _GameEvent? event;
  final bool isEvent;
  const _FeedItem({this.bet, this.event, required this.isEvent});
}

// ---------------------------------------------------------------------------
// UI Components
// ---------------------------------------------------------------------------
class _QuickBetChip extends StatelessWidget {
  const _QuickBetChip({
    required this.label,
    required this.tokens,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int tokens;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '$tokens tokens',
                style: TextStyle(
                  fontSize: 10,
                  color: color.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final _GameEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "${event.minute}'",
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              event.text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _BetCard extends StatelessWidget {
  const _BetCard({required this.bet});
  final _LiveBet bet;

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusText;
    final IconData statusIcon;

    if (!bet.resolved) {
      statusColor = AppColors.primary;
      statusText = 'PENDING';
      statusIcon = Icons.hourglass_top;
    } else if (bet.won) {
      statusColor = AppColors.secondary;
      statusText = 'WON +${bet.wager * 2}';
      statusIcon = Icons.check_circle;
    } else {
      statusColor = AppColors.lost;
      statusText = 'LOST -${bet.wager}';
      statusIcon = Icons.cancel;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: bet.resolved
              ? statusColor.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "${bet.minute}'",
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bet.description,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
                Text(
                  '${bet.wager} tokens wagered',
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 12, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
