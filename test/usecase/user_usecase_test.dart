import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_girok_app/domain/usecases/get_user.dart';
import 'package:flutter_girok_app/domain/usecases/add_user.dart';
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/user_repository.dart';

/// Fake User Repository
class FakeUserRepository implements UserRepository {
  User? userToReturn;
  bool addCalled = false;
  bool getCalled = false;

  @override
  Future<void> addUser(User user) async {
    addCalled = true;
    userToReturn = user;
  }

  @override
  Future<User?> getUser(String userId) async {
    getCalled = true;
    return userToReturn;
  }
}

void main() {
  group('User UseCase Tests', () {
    late FakeUserRepository fakeRepo;
    late AddUser addUserUseCase;
    late GetUser getUserUseCase;

    setUp(() {
      fakeRepo = FakeUserRepository();
      addUserUseCase = AddUser(fakeRepo);
      getUserUseCase = GetUser(fakeRepo);
    });

    test('AddUser stores user', () async {
      final user = User(id: 'u1', email: 'test@test.com');

      await addUserUseCase.call(user);

      expect(fakeRepo.addCalled, true);
      expect(fakeRepo.userToReturn, user);
    });

    test('GetUser retrieves user', () async {
      final user = User(id: 'u1', email: 'test@test.com');
      fakeRepo.userToReturn = user;

      final result = await getUserUseCase.call('u1');

      expect(fakeRepo.getCalled, true);
      expect(result, isNotNull);
      expect(result!.id, 'u1');
      expect(result.email, 'test@test.com');
    });
  });
}
