import 'package:flutter_girok_app/domain/models/user.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  Future<void> signOut();
  User? getCurrentUser();
  Future<void> deleteAccount();
}
