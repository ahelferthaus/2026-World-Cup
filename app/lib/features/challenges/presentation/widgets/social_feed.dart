import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Venmo-style social activity feed for challenges.
class SocialFeedWidget extends StatelessWidget {
  const SocialFeedWidget({super.key, required this.feedEntries});

  final List<Map<String, dynamic>> feedEntries;

  @override
  Widget build(BuildContext context) {
    if (feedEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dynamic_feed_outlined,
                size: 64, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text('No activity yet',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: feedEntries.length,
      separatorBuilder: (_, __) => Divider(
        color: AppColors.textMuted.withValues(alpha: 0.15),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final entry = feedEntries[index];
        return _FeedEntry(entry: entry);
      },
    );
  }
}

class _FeedEntry extends StatelessWidget {
  const _FeedEntry({required this.entry});
  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final type = entry['type'] as String;
    final actor = entry['actor'] as String;
    final target = entry['target'] as String;
    final title = entry['title'] as String;
    final wager = entry['wager'] as int;
    final emoji = entry['emoji'] as String;
    final fires = entry['fires'] as int;
    final timeAgo = entry['timeAgo'] as String;

    final (String verb, Color accentColor) = switch (type) {
      'challenge' => ('challenged', AppColors.primary),
      'won' => ('won against', AppColors.won),
      'lost' => ('lost to', AppColors.lost),
      _ => ('vs', AppColors.textSecondary),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: AppSpacing.md),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: actor,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' $verb ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextSpan(
                        text: target,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '"$title"',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    // Wager
                    Text(
                      '\u{1F4B0} $wager tokens',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tokenGoldDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    // Fire reactions
                    const Text('\u{1F525}', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 2),
                    Text(
                      '$fires',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    // Time
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
