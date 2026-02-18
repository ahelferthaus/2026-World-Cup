import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/demo_data.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/predictions_repository.dart';
import '../../domain/prediction_model.dart';

final predictionsRepositoryProvider = Provider<PredictionsRepository>((ref) {
  return PredictionsRepository();
});

final userPredictionsProvider = FutureProvider<List<PredictionModel>>((ref) async {
  if (useDemoData) {
    return DemoData.predictions.map((p) => PredictionModel.fromDemo(p)).toList();
  }

  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  return ref.read(predictionsRepositoryProvider).fetchUserPredictions(uid);
});
