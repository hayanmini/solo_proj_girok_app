import 'package:flutter_girok_app/domain/repositories/auth_repository.dart';
import 'package:flutter_girok_app/domain/repositories/user_repository.dart';

class DeleteUser {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  DeleteUser(this.authRepository, this.userRepository);

  Future<void> call(userId) async {
    await userRepository.deleteUser(userId);
    await authRepository.deleteAccount();
  }
}
