import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/glassmorphic_card.dart';
import '../../../core/widgets/token_badge.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../profile/presentation/providers/profile_providers.dart';
import '../domain/challenge_category.dart';
import '../domain/challenge_model.dart';
import 'providers/challenges_providers.dart';
import 'widgets/challenge_card.dart';
import 'widgets/h2h_dashboard.dart';
import 'widgets/opponent_picker.dart';
import 'widgets/outcome_confirmation_sheet.dart';
import 'widgets/party_mode_lobby.dart';
import 'widgets/quick_challenge_sheet.dart';
import 'widgets/social_feed.dart';

/// Main Challenges hub — the P2P social betting experience.
/// Tabs: Feed | My Bets | Create | H2H | Party
class ChallengesHubScreen extends ConsumerWidget {
  const ChallengesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).valueOrNull;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: AnimatedGradientBackground(
          colors: const [
            Color(0xFFE040FB), // magenta
            Color(0xFF6C5CE7), // purple
            Color(0xFFFF6D00), // orange
          ],
          orbCount: 4,
          speed: 0.6,
          child: SafeArea(
            child: Column(
              children: [
                // Custom app bar
                _ChallengesAppBar(tokens: userProfile?.tokens),
                // Tab bar
                const _ChallengesTabBar(),
                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      _FeedTab(),
                      _MyBetsTab(),
                      _CreateTab(),
                      _H2hTab(),
                      const PartyModeLobby(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App bar with title, token badge, and quick challenge button
// ---------------------------------------------------------------------------
class _ChallengesAppBar extends StatelessWidget {
  const _ChallengesAppBar({this.tokens});
  final int? tokens;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
          ),
          const Expanded(
            child: Text(
              'Challenges',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (tokens != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: TokenBadge(tokens: tokens!, compact: true),
            ),
          // Quick challenge FAB
          _QuickChallengeButton(),
        ],
      ),
    );
  }
}

class _QuickChallengeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const QuickChallengeSheet(),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'Quick',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
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
// Tab bar
// ---------------------------------------------------------------------------
class _ChallengesTabBar extends StatelessWidget {
  const _ChallengesTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            ),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
              ),
              dividerColor: Colors.transparent,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: '\u{1F4F0} Feed'),
                Tab(text: '\u{1F3AF} My Bets'),
                Tab(text: '\u2728 Create'),
                Tab(text: '\u{1F93C} H2H'),
                Tab(text: '\u{1F3B2} Party'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feed tab — Venmo-style social activity
// ---------------------------------------------------------------------------
class _FeedTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(socialFeedProvider);
    return feed.when(
      data: (entries) => SocialFeedWidget(feedEntries: entries),
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

// ---------------------------------------------------------------------------
// My Bets tab — all challenges filtered by status
// ---------------------------------------------------------------------------
class _MyBetsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(myChallengesProvider);
    final uid = ref.watch(currentUidProvider) ?? 'demo_user';

    return challenges.when(
      data: (bets) {
        if (bets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.handshake_outlined,
                    size: 64, color: AppColors.textMuted),
                const SizedBox(height: AppSpacing.md),
                Text('No challenges yet',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.xs),
                Text('Tap Quick \u26A1 to challenge a friend!',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        // Group: needs action → active → pending → resolved
        final needsAction = bets.where((c) =>
            (c.isPending && c.toUid == uid) ||
            c.needsMyConfirmation(uid)).toList();
        final active = bets.where((c) => c.isActive && !c.needsMyConfirmation(uid)).toList();
        final pending = bets.where((c) => c.isPending && c.fromUid == uid).toList();
        final resolved = bets.where((c) => c.isResolved || c.status == ChallengeStatus.declined).toList();

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (needsAction.isNotEmpty) ...[
              _SectionHeader(
                  title: 'NEEDS YOUR ACTION',
                  count: needsAction.length,
                  color: AppColors.accent),
              ...needsAction.map((c) => ChallengeCard(
                    challenge: c,
                    currentUid: uid,
                    onAccept: () => context.showSuccessSnackBar(
                        'Challenge accepted! (Demo mode)'),
                    onDecline: () => context.showSuccessSnackBar(
                        'Challenge declined (Demo mode)'),
                    onConfirmOutcome: () => _showOutcomeSheet(context, c, uid),
                  )),
            ],
            if (active.isNotEmpty) ...[
              _SectionHeader(
                  title: 'ACTIVE', count: active.length, color: AppColors.primary),
              ...active.map((c) => ChallengeCard(
                    challenge: c,
                    currentUid: uid,
                  )),
            ],
            if (pending.isNotEmpty) ...[
              _SectionHeader(
                  title: 'WAITING ON THEM',
                  count: pending.length,
                  color: AppColors.pending),
              ...pending.map((c) => ChallengeCard(
                    challenge: c,
                    currentUid: uid,
                  )),
            ],
            if (resolved.isNotEmpty) ...[
              _SectionHeader(
                  title: 'HISTORY',
                  count: resolved.length,
                  color: AppColors.textMuted),
              ...resolved.map((c) => ChallengeCard(
                    challenge: c,
                    currentUid: uid,
                  )),
            ],
          ],
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  void _showOutcomeSheet(
      BuildContext context, ChallengeModel challenge, String uid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OutcomeConfirmationSheet(
        challenge: challenge,
        currentUid: uid,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });
  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: AppSpacing.sm, top: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1,
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Create tab — full challenge creation flow
// ---------------------------------------------------------------------------
class _CreateTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends ConsumerState<_CreateTab> {
  ChallengeCategory _category = ChallengeCategory.custom;
  String? _selectedOpponent;
  final _titleController = TextEditingController();
  double _wager = 10;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opponentRecords = ref.watch(opponentRecordsProvider);
    final canSend =
        _titleController.text.trim().isNotEmpty && _selectedOpponent != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Create Challenge',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Category selector
          Text(
            'CATEGORY',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: ChallengeCategory.values.map((cat) {
              final isSelected = _category == cat;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: cat != ChallengeCategory.values.last
                        ? AppSpacing.sm
                        : 0,
                  ),
                  child: GlassmorphicCard(
                    onTap: () => setState(() => _category = cat),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    borderColor: isSelected
                        ? cat.color.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.08),
                    gradient: isSelected
                        ? LinearGradient(colors: [
                            cat.color.withValues(alpha: 0.2),
                            cat.color.withValues(alpha: 0.05),
                          ])
                        : null,
                    child: Column(
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          cat.displayName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: isSelected
                                ? cat.color
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Challenge description
          Text(
            'WHAT\'S THE BET?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _titleController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: _hintForCategory,
              hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(AppSpacing.lg),
            ),
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Opponent picker
          Text(
            'CHALLENGE WHO?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          opponentRecords.when(
            data: (records) => OpponentPicker(
              recentOpponents: records,
              selectedUid: _selectedOpponent,
              onSelected: (uid) =>
                  setState(() => _selectedOpponent = uid),
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Wager
          Text(
            'WAGER: ${_wager.toInt()} TOKENS',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '\u{1FA99}',
                style: const TextStyle(fontSize: 20),
              ),
              Expanded(
                child: Slider(
                  value: _wager,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '${_wager.toInt()}',
                  activeColor: AppColors.tokenGold,
                  onChanged: (v) => setState(() => _wager = v),
                ),
              ),
              Text(
                '${_wager.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.tokenGoldDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Send button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: canSend
                  ? () {
                      context.showSuccessSnackBar(
                          'Challenge sent! \u{1F525} (Demo mode)');
                      setState(() {
                        _titleController.clear();
                        _selectedOpponent = null;
                        _wager = 10;
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _category.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.buttonRadius),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              child: Text('Send ${_category.emoji} Challenge'),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  String get _hintForCategory => switch (_category) {
        ChallengeCategory.sports =>
          'LeBron drops 30+ tonight',
        ChallengeCategory.custom =>
          'I land this bottle flip on the first try',
        ChallengeCategory.partyGame =>
          'Who blinks first loses',
      };
}

// ---------------------------------------------------------------------------
// H2H tab — head-to-head opponent stats
// ---------------------------------------------------------------------------
class _H2hTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(opponentRecordsProvider);
    return records.when(
      data: (r) => H2hDashboard(records: r),
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
