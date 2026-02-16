import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/leaderboard_repository.dart';
import '../../domain/leaderboard_entry.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository();
});

final globalLeaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  final idToken = await ref.watch(idTokenProvider.future);
  if (idToken == null) return [];

  return ref.read(leaderboardRepositoryProvider).fetchGlobalLeaderboard(idToken);
});

final schoolLeaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  final idToken = await ref.watch(idTokenProvider.future);
  if (idToken == null) return [];

  return ref
      .read(leaderboardRepositoryProvider)
      .fetchSchoolLeaderboard(idToken, 'Centaurus High School');
});
