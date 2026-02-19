import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/data/demo_data.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Bottom sheet for rapid-fire custom bet creation.
/// Optimized for the "watching a game together" use case — 3 taps to send.
class QuickChallengeSheet extends StatefulWidget {
  const QuickChallengeSheet({super.key});

  @override
  State<QuickChallengeSheet> createState() => _QuickChallengeSheetState();
}

class _QuickChallengeSheetState extends State<QuickChallengeSheet> {
  final _titleController = TextEditingController();
  String? _selectedOpponent;
  int _wager = 10;

  static const _quickWagers = [5, 10, 25, 50];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opponents = DemoData.leaderboardSchool
        .where((e) => e['uid'] != 'demo_user')
        .toList();

    final canSend =
        _titleController.text.trim().isNotEmpty && _selectedOpponent != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Row(
              children: [
                const Text('\u26A1', style: TextStyle(fontSize: 24)),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'Quick Challenge',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Bet description input
            TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Next free throw: make or miss?',
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

            // Opponent selector
            Text(
              'Challenge who?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: opponents.map((o) {
                final uid = o['uid'] as String;
                final isSelected = _selectedOpponent == uid;
                return ChoiceChip(
                  label: Text(o['displayName'] as String),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _selectedOpponent = uid),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Quick wager chips
            Text(
              'How many tokens?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: _quickWagers.map((w) {
                final isSelected = _wager == w;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: w != _quickWagers.last ? AppSpacing.sm : 0,
                    ),
                    child: ChoiceChip(
                      label: Text(
                        '$w',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.tokenGold
                              : AppColors.textSecondary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _wager = w),
                      selectedColor:
                          AppColors.tokenGold.withValues(alpha: 0.15),
                      avatar: isSelected
                          ? const Text('\u{1FA99}',
                              style: TextStyle(fontSize: 14))
                          : null,
                      showCheckmark: false,
                    ),
                  ),
                );
              }).toList(),
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
                        Navigator.of(context).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                child: const Text('SEND IT \u{1F525}'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
