import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/user_repository.dart';

class AddUser {
  final UserRepository repository;
  AddUser(this.repository);

  Future<void> call(User user) => repository.addUser(user);
}
