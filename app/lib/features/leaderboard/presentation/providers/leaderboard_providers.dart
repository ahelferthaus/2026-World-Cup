import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/demo_data.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/leaderboard_repository.dart';
import '../../domain/leaderboard_entry.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository();
});

final globalLeaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  if (useDemoData) {
    return DemoData.leaderboardGlobal.map((e) => LeaderboardEntry.fromJson(e)).toList();
  }

  final idToken = await ref.watch(idTokenProvider.future);
  if (idToken == null) return [];

  return ref.read(leaderboardRepositoryProvider).fetchGlobalLeaderboard(idToken);
});

final schoolLeaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  if (useDemoData) {
    return DemoData.leaderboardSchool.map((e) => LeaderboardEntry.fromJson(e)).toList();
  }

  final idToken = await ref.watch(idTokenProvider.future);
  if (idToken == null) return [];

  return ref
      .read(leaderboardRepositoryProvider)
      .fetchSchoolLeaderboard(idToken, 'Centaurus High School');
});

final schoolAggregatesProvider = FutureProvider<List<AggregateEntry>>((ref) async {
  if (useDemoData) {
    return DemoData.schoolAggregates.map((e) => AggregateEntry.fromJson(e)).toList();
  }
  return [];
});

final stateAggregatesProvider = FutureProvider<List<AggregateEntry>>((ref) async {
  if (useDemoData) {
    return DemoData.stateAggregates.map((e) => AggregateEntry.fromJson(e)).toList();
  }
  return [];
});
