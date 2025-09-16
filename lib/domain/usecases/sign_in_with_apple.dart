import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/auth_repository.dart';

class SignInWithApple {
  final AuthRepository repository;
  SignInWithApple(this.repository);

  Future<User?> call() => repository.signInWithApple();
}
