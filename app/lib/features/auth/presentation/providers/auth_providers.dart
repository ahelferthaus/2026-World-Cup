import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/demo_data.dart';
import '../../../../core/extensions/async_value_extensions.dart';
import '../../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  if (useDemoData) {
    // In demo mode, return null (no real auth) — the router will handle it
    return Stream.value(null);
  }
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// In demo mode, always return a fake UID so the app thinks user is logged in
class DemoLoggedInNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void login() => state = true;
  void logout() => state = false;
}

final demoLoggedInProvider = NotifierProvider<DemoLoggedInNotifier, bool>(
  DemoLoggedInNotifier.new,
);

final currentUidProvider = Provider<String?>((ref) {
  if (useDemoData) {
    return ref.watch(demoLoggedInProvider) ? 'demo_user' : null;
  }
  return ref.watch(authStateProvider).valueOrNull?.uid;
});

final idTokenProvider = FutureProvider<String?>((ref) async {
  if (useDemoData) return 'demo_token';
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return null;
  return await user.getIdToken();
});
