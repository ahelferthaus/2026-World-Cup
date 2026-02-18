import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/demo_data.dart';
import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final userProfileProvider = StreamProvider<AppUser?>((ref) {
  if (useDemoData) {
    final d = DemoData.userProfile;
    return Stream.value(AppUser(
      uid: d['uid'] as String,
      displayName: d['displayName'] as String,
      school: d['school'] as String,
      tokens: d['tokens'] as int,
    ));
  }

  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  return ref.read(profileRepositoryProvider).watchUser(uid);
});
