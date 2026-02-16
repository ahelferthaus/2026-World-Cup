import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/predictions_repository.dart';
import '../../domain/prediction_model.dart';

final predictionsRepositoryProvider = Provider<PredictionsRepository>((ref) {
  return PredictionsRepository();
});

final userPredictionsProvider = FutureProvider<List<PredictionModel>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  return ref.read(predictionsRepositoryProvider).fetchUserPredictions(uid);
});
