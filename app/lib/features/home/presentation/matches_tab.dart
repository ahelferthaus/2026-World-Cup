import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/match_card.dart';
import 'providers/matches_providers.dart';

class MatchesTab extends ConsumerWidget {
  const MatchesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesTodayProvider);

    return matchesAsync.when(
      loading: () => const AppLoadingIndicator(message: 'Loading matches...'),
      error: (error, _) => AppErrorWidget(
        message: 'Could not load matches.\n$error',
        onRetry: () => ref.invalidate(matchesTodayProvider),
      ),
      data: (matches) {
        if (matches.isEmpty) {
          return const AppEmptyState(
            icon: Icons.sports_soccer,
            title: 'No matches today',
            subtitle: 'Check back tomorrow for upcoming games!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(matchesTodayProvider),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: matches.length,
            itemBuilder: (context, index) => MatchCard(match: matches[index]),
          ),
        );
      },
    );
  }
}
