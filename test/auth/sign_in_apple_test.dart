import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/auth_repository.dart';
import 'package:flutter_girok_app/domain/usecases/sign_in_with_apple.dart';

class FakeAuthRepository implements AuthRepository {
  User? _user;

  @override
  Future<User?> signInWithGoogle() async {
    return null; // 이번 테스트에서는 사용 안 함
  }

  @override
  Future<User?> signInWithApple() async {
    _user = User(
      id: 'apple123',
      email: 'apple@test.com',
      displayName: 'Apple User',
    );
    return _user;
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }

  @override
  User? getCurrentUser() => _user;
}

void main() {
  test('애플 로그인 시 User 반환', () async {
    final repo = FakeAuthRepository();
    final signInWithApple = SignInWithApple(repo);

    final user = await signInWithApple();

    expect(user, isNotNull);
    expect(user?.id, 'apple123');
    expect(user?.email, 'apple@test.com');
    expect(repo.getCurrentUser()?.displayName, 'Apple User');
  });
}
