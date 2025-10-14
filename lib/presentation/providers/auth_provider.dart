import 'package:flutter_girok_app/domain/usecases/delete_user.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_girok_app/data/repositories/auth_repository_impl.dart';
import 'package:flutter_girok_app/domain/models/user.dart' as domain_user;

// AuthRepositoryImpl 주입
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(fb.FirebaseAuth.instance);
});

// 현재 로그인한 유저 상태 (FirebaseAuth)
final currentUserProvider = StreamProvider<fb.User?>((ref) {
  return fb.FirebaseAuth.instance.authStateChanges();
});

// 로그인 상태 확인 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

// domain User로 매핑된 유저 상태
final domainUserProvider = FutureProvider<domain_user.User?>((ref) async {
  final fbUser = await ref.watch(currentUserProvider.future);
  if (fbUser == null) return null;

  // FirebaseAuth 유저 -> Domain User
  return domain_user.User(
    id: fbUser.uid,
    email: fbUser.email ?? '',
    displayName: fbUser.displayName,
    photoUrl: fbUser.photoURL,
  );
});

final deleteAccountProvider = Provider<DeleteUser>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return DeleteUser(authRepo, userRepo);
});
