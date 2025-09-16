import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_girok_app/data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Fake Firebase User
class FakeFbUser implements fb.User {
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL;

  FakeFbUser({required this.uid, this.email, this.displayName, this.photoURL});

  // 나머지 abstract 멤버는 테스트용으로 필요없으면 throw
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Fake UserCredential
class FakeUserCredential implements fb.UserCredential {
  @override
  final fb.User? user;

  FakeUserCredential(this.user);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Fake FirebaseAuth
class FakeFirebaseAuth implements fb.FirebaseAuth {
  fb.User? _currentUser;

  @override
  fb.User? get currentUser => _currentUser;

  @override
  Future<fb.UserCredential> signInWithProvider(fb.AuthProvider provider) async {
    // provider에 따라 다른 사용자 생성 가능
    if (provider is fb.GoogleAuthProvider) {
      _currentUser = FakeFbUser(
        uid: 'google123',
        email: 'google@test.com',
        displayName: 'Google User',
      );
    } else if (provider is fb.AppleAuthProvider) {
      _currentUser = FakeFbUser(
        uid: 'apple123',
        email: 'apple@test.com',
        displayName: 'Apple User',
      );
    }
    return FakeUserCredential(_currentUser);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeFirebaseAuth fakeAuth;
  late AuthRepositoryImpl repository;

  setUp(() {
    fakeAuth = FakeFirebaseAuth();
    repository = AuthRepositoryImpl(fakeAuth);
  });

  test('구글 로그인 테스트', () async {
    final user = await repository.signInWithGoogle();

    expect(user, isNotNull);
    expect(user?.id, 'google123');
    expect(user?.email, 'google@test.com');
    expect(user?.displayName, 'Google User');
    expect(repository.getCurrentUser()?.id, 'google123');
  });

  test('애플 로그인 테스트', () async {
    final user = await repository.signInWithApple();

    expect(user, isNotNull);
    expect(user?.id, 'apple123');
    expect(user?.email, 'apple@test.com');
    expect(user?.displayName, 'Apple User');
    expect(repository.getCurrentUser()?.id, 'apple123');
  });

  test('로그아웃 후 currentUser null', () async {
    await repository.signInWithGoogle();
    expect(repository.getCurrentUser(), isNotNull);

    await repository.signOut();
    expect(repository.getCurrentUser(), isNull);
  });
}
