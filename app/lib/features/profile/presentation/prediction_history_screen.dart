import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/token_formatter.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../predict/domain/prediction_model.dart';
import '../../predict/presentation/providers/predict_providers.dart';

class PredictionHistoryScreen extends ConsumerWidget {
  const PredictionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictionsAsync = ref.watch(userPredictionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Prediction History')),
      body: predictionsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorWidget(
          message: 'Could not load predictions.',
          onRetry: () => ref.invalidate(userPredictionsProvider),
        ),
        data: (predictions) {
          if (predictions.isEmpty) {
            return const AppEmptyState(
              icon: Icons.history,
              title: 'No predictions yet',
              subtitle: 'Head to the Predict tab to get started!',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: predictions.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              return _PredictionTile(prediction: predictions[index]);
            },
          );
        },
      ),
    );
  }
}

class _PredictionTile extends StatelessWidget {
  const _PredictionTile({required this.prediction});

  final PredictionModel prediction;

  Color get _statusColor {
    switch (prediction.status) {
      case 'won':
        return AppColors.won;
      case 'lost':
        return AppColors.lost;
      default:
        return AppColors.pending;
    }
  }

  IconData get _statusIcon {
    switch (prediction.status) {
      case 'won':
        return Icons.check_circle;
      case 'lost':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(_statusIcon, color: _statusColor, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Match #${prediction.matchId}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${prediction.selectionLabel} | ${prediction.wager} tokens wagered',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  DateFormatter.relativeTime(prediction.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          if (prediction.isWon)
            Text(
              '+${TokenFormatter.format(prediction.payout)}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: AppColors.won,
              ),
            )
          else if (prediction.isLost)
            Text(
              '-${TokenFormatter.format(prediction.wager)}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: AppColors.lost,
              ),
            )
          else
            Text(
              'Pending',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
        ],
      ),
    );
  }
}
