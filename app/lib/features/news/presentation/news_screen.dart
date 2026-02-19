import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/team_flag.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final news = DemoData.newsFeed;

    return Scaffold(
      appBar: AppBar(title: const Text('Sports News')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: news.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = news[index];
          return _NewsCard(item: item);
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});
  final Map<String, dynamic> item;

  IconData _categoryIcon() {
    switch (item['category']) {
      case 'match':
        return Icons.sports_soccer;
      case 'stats':
        return Icons.bar_chart;
      case 'preview':
        return Icons.visibility;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = item['imageUrl'] as String?;
    final publishedAt = DateTime.parse(item['publishedAt'] as String);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // In production, launch URL with url_launcher
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Would open: ${item['url']}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or icon
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  child: TeamFlag(logoUrl: imageUrl, size: 48),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Icon(_categoryIcon(), color: AppColors.primary),
                ),
              const SizedBox(width: AppSpacing.md),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          item['source'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          DateFormatter.relativeTime(publishedAt),
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
