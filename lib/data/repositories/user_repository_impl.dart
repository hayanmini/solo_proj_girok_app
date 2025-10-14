import 'package:flutter_girok_app/data/data_sources/firestore_datasource.dart';
import 'package:flutter_girok_app/data/models/user_dto.dart';
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreDatasource datasource;
  UserRepositoryImpl(this.datasource);

  @override
  Future<void> addUser(User user) async {
    final dto = UserDto.fromDomain(user);
    await datasource.addUser(dto);
  }

  @override
  Future<User?> getUser(String userId) async {
    final dto = await datasource.getUser(userId);
    return dto?.toDomain();
  }

  @override
  Future<void> deleteUser(String userId) async {
    await datasource.deleteUser(userId);
  }
}
