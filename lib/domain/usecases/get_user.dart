import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;
  GetUser(this.repository);

  Future<User?> call(String userId) => repository.getUser(userId);
}
