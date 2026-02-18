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
    return Stream.value(AppUser.fromDemo(DemoData.userProfile));
  }

  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  return ref.read(profileRepositoryProvider).watchUser(uid);
});
