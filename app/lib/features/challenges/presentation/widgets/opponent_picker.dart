import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/data/demo_data.dart';
import '../../domain/opponent_record.dart';

/// Friend selector for creating challenges.
/// Shows recent opponents first, then school leaderboard.
class OpponentPicker extends StatefulWidget {
  const OpponentPicker({
    super.key,
    required this.recentOpponents,
    required this.onSelected,
    this.selectedUid,
  });

  final List<OpponentRecord> recentOpponents;
  final ValueChanged<String> onSelected;
  final String? selectedUid;

  @override
  State<OpponentPicker> createState() => _OpponentPickerState();
}

class _OpponentPickerState extends State<OpponentPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final allOpponents = DemoData.leaderboardSchool
        .where((e) => e['uid'] != 'demo_user')
        .toList();

    // Merge recent opponents + school list, deduplicate
    final recentUids = widget.recentOpponents.map((r) => r.opponentUid).toSet();
    final recent = widget.recentOpponents
        .where((r) =>
            _search.isEmpty ||
            r.opponentName.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    final others = allOpponents
        .where((o) =>
            !recentUids.contains(o['uid'] as String) &&
            (_search.isEmpty ||
                (o['displayName'] as String)
                    .toLowerCase()
                    .contains(_search.toLowerCase())))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search
        TextField(
          onChanged: (v) => setState(() => _search = v),
          decoration: InputDecoration(
            hintText: 'Search friends...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon:
                Icon(Icons.search, color: AppColors.textMuted, size: 20),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: AppSpacing.md),

        // Recent opponents section
        if (recent.isNotEmpty) ...[
          Text(
            'RECENT',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: recent.map((r) {
              final isSelected = widget.selectedUid == r.opponentUid;
              return ChoiceChip(
                label: Text(r.opponentName),
                selected: isSelected,
                onSelected: (_) => widget.onSelected(r.opponentUid),
                avatar: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                  child: Text(
                    r.opponentName[0],
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  ),
                ),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 13,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // School list
        if (others.isNotEmpty) ...[
          Text(
            'FROM YOUR SCHOOL',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: others.map((o) {
              final uid = o['uid'] as String;
              final name = o['displayName'] as String;
              final isSelected = widget.selectedUid == uid;
              return ChoiceChip(
                label: Text(name),
                selected: isSelected,
                onSelected: (_) => widget.onSelected(uid),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 13,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
