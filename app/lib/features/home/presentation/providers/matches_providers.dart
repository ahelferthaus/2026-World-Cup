import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/matches_repository.dart';
import '../../domain/match_model.dart';

final matchesRepositoryProvider = Provider<MatchesRepository>((ref) {
  return MatchesRepository();
});

final matchesTodayProvider = FutureProvider<List<MatchModel>>((ref) async {
  final idToken = await ref.watch(idTokenProvider.future);
  if (idToken == null) return [];

  return ref.read(matchesRepositoryProvider).fetchTodayMatches(idToken);
});
