import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _auth;
  AuthRepositoryImpl(this._auth);

  @override
  Future<User?> signInWithGoogle() async {
    final googleProvider = fb.GoogleAuthProvider();

    // 구글 로그인
    final userCredential = await _auth.signInWithProvider(googleProvider);
    final fb.User? fbUser = userCredential.user;
    if (fbUser == null) return null;

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  User? getCurrentUser() {
    final fb.User? fbUser = _auth.currentUser;
    if (fbUser == null) return null;

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
    );
  }
}
