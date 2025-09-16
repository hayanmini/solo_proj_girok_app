import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _auth;
  AuthRepositoryImpl(this._auth);

  // FirebaseUser -> Domain User 변환 공통 메서드
  User? _mapUser(fb.User? fbUser) {
    if (fbUser == null) return null;

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
    );
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleProvider = fb.GoogleAuthProvider();
    final userCredential = await _auth.signInWithProvider(googleProvider);
    return _mapUser(userCredential.user);
  }

  @override
  Future<User?> signInWithApple() async {
    final appleProvider = fb.AppleAuthProvider();
    final userCredential = await _auth.signInWithProvider(appleProvider);
    return _mapUser(userCredential.user);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  User? getCurrentUser() => _mapUser(_auth.currentUser);
}
