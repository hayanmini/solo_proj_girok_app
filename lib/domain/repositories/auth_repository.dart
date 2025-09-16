import 'package:flutter_girok_app/domain/models/user.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
}
