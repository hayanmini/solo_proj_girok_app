import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;
  SignInWithGoogle(this.repository);

  Future<User?> call() => repository.signInWithGoogle();
}
