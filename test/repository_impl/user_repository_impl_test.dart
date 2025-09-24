import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girok_app/data/data_sources/firestore_datasource.dart';
import 'package:flutter_girok_app/data/models/record_dto.dart';
import 'package:flutter_girok_app/data/models/user_dto.dart';
import 'package:flutter_girok_app/data/repositories/user_repository_impl.dart';
import 'package:flutter_girok_app/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

/// build_runner 없이 직접 만드는 Fake 클래스
class FakeFirestoreDatasource implements FirestoreDatasource {
  UserDto? storedDto; // addUser 시 여기에 저장

  @override
  Future<UserDto?> getUser(String userId) async {
    // getUser 호출될 때 storedDto 리턴
    if (storedDto != null && storedDto!.id == userId) {
      return storedDto;
    }
    return null;
  }

  @override
  Future<void> addUser(UserDto user) async {
    // addUser가 호출되면 storedDto에 저장
    storedDto = user;
  }

  // 쓰지 않는 메서드는 모두 UnimplementedError 처리
  @override
  Future<void> addRecord(String userId, record) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteRecord(String userId, String recordId) async =>
      throw UnimplementedError();

  @override
  FirebaseFirestore get firestore => throw UnimplementedError();

  @override
  Future<void> updateRecord(String userId, RecordDto record) {
    throw UnimplementedError();
  }

  @override
  Future<List<RecordDto>> getRecordByDate(String userId, DateTime date) {
    throw UnimplementedError();
  }

  @override
  Future<List<RecordDto>> getRecord(String userId) {
    throw UnimplementedError();
  }
}

void main() {
  late FakeFirestoreDatasource fakeDataSource;
  late UserRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeFirestoreDatasource();
    repository = UserRepositoryImpl(fakeDataSource);
  });

  test('addUser stores the UserDto correctly', () async {
    // given
    final user = User(id: 'u1', email: 'test@test.com');

    // when
    await repository.addUser(user);

    // then
    // fakeDataSource.storedDto가 저장됐는지 확인
    expect(fakeDataSource.storedDto, isNotNull);
    expect(fakeDataSource.storedDto!.id, 'u1');
    expect(fakeDataSource.storedDto!.email, 'test@test.com');
  });

  test('getUser returns UserModel from dto', () async {
    // given: 미리 storedDto에 저장
    fakeDataSource.storedDto = UserDto(id: 'u1', email: 'test@test.com');

    // when
    final result = await repository.getUser('u1');

    // then
    expect(result, isA<User>());
    expect(result!.id, 'u1');
    expect(result.email, 'test@test.com');
  });

  test('getUser returns null when no user', () async {
    // given: storedDto 없음
    fakeDataSource.storedDto = null;

    // when
    final result = await repository.getUser('u1');

    // then
    expect(result, isNull);
  });
}
