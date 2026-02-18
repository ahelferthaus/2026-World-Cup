import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/demo_data.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/standings_repository.dart';
import '../../domain/standing_model.dart';

final standingsRepositoryProvider = Provider<StandingsRepository>((ref) {
  return StandingsRepository();
});

final standingsProvider = FutureProvider<List<GroupStanding>>((ref) async {
  if (useDemoData) {
    return DemoData.standings.map((g) => GroupStanding.fromJson(g)).toList();
  }

  final idToken = await ref.watch(idTokenProvider.future);
  if (idToken == null) return [];

  return ref.read(standingsRepositoryProvider).fetchStandings(idToken);
});
