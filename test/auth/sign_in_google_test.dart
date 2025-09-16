import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_girok_app/domain/repositories/auth_repository.dart';
import 'package:flutter_girok_app/domain/usecases/sign_in_with_google.dart';

// Fake Repository
class FakeAuthRepository implements AuthRepository {
  User? _user;

  @override
  Future<User?> signInWithGoogle() async {
    _user = User(
      id: 'google123',
      email: 'google@test.com',
      displayName: 'Google User',
    );
    return _user;
  }

  @override
  Future<User?> signInWithApple() async {
    return null; // 이번 테스트에서는 사용 안 함
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }

  @override
  User? getCurrentUser() => _user;
}

void main() {
  test('구글 로그인 시 User 반환', () async {
    final repo = FakeAuthRepository();
    final signInWithGoogle = SignInWithGoogle(repo);

    final user = await signInWithGoogle();

    expect(user, isNotNull);
    expect(user?.id, 'google123');
    expect(user?.email, 'google@test.com');
    expect(repo.getCurrentUser()?.displayName, 'Google User');
  });
}
