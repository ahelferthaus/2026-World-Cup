import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/async_value_extensions.dart';
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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: upcoming.length,
            itemBuilder: (context, index) {
              final match = upcoming[index];
              return MatchCard(
                match: match,
                onTap: () => _openPredictionForm(context, match),
              );
            },
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
