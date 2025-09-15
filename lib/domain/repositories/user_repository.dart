import 'package:flutter_girok_app/domain/models/user.dart';

abstract class UserRepository {
  Future<void> addUser(User user);
  Future<User?> getUser(String userId);
}
