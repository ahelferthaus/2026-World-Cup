import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/demo_data.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/challenges_demo_data.dart';
import '../../domain/challenge_model.dart';
import '../../domain/opponent_record.dart';

/// All challenges (unfiltered).
final allChallengesProvider = FutureProvider<List<ChallengeModel>>((ref) async {
  if (useDemoData) {
    return ChallengesDemoData.challenges
        .map((c) => ChallengeModel.fromDemo(c))
        .toList();
  }
  // TODO: Firestore query
  return [];
});

/// Only challenges involving the current user.
final myChallengesProvider = FutureProvider<List<ChallengeModel>>((ref) async {
  final uid = ref.watch(currentUidProvider) ?? 'demo_user';
  final all = await ref.watch(allChallengesProvider.future);
  return all
      .where((c) => c.fromUid == uid || c.toUid == uid)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

/// Pending challenges that need the current user's action.
final pendingChallengesProvider =
    FutureProvider<List<ChallengeModel>>((ref) async {
  final uid = ref.watch(currentUidProvider) ?? 'demo_user';
  final mine = await ref.watch(myChallengesProvider.future);
  return mine
      .where((c) =>
          (c.isPending && c.toUid == uid) || c.needsMyConfirmation(uid))
      .toList();
});

/// Active (accepted + awaitingOutcome) challenges.
final activeChallengesProvider =
    FutureProvider<List<ChallengeModel>>((ref) async {
  final mine = await ref.watch(myChallengesProvider.future);
  return mine.where((c) => c.isActive).toList();
});

/// Resolved (settled) challenges.
final resolvedChallengesProvider =
    FutureProvider<List<ChallengeModel>>((ref) async {
  final mine = await ref.watch(myChallengesProvider.future);
  return mine.where((c) => c.isResolved).toList();
});

/// Head-to-head opponent records.
final opponentRecordsProvider =
    FutureProvider<List<OpponentRecord>>((ref) async {
  if (useDemoData) {
    return ChallengesDemoData.opponentRecords
        .map((r) => OpponentRecord.fromDemo(r))
        .toList()
      ..sort((a, b) => b.lastBetAt.compareTo(a.lastBetAt));
  }
  // TODO: compute from Firestore challenge history
  return [];
});

/// Social feed data (raw maps for flexible rendering).
final socialFeedProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  if (useDemoData) {
    return ChallengesDemoData.socialFeed;
  }
  return [];
});
