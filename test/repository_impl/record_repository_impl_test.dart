import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girok_app/data/models/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_girok_app/data/data_sources/firestore_datasource.dart';
import 'package:flutter_girok_app/data/models/record_dto.dart';
import 'package:flutter_girok_app/data/repositories/record_repository_impl.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';

/// FirestoreDatasource Fake
class FakeRecordDatasource implements FirestoreDatasource {
  final List<RecordDto> storedRecords = [];

  @override
  Future<void> addRecord(String userId, RecordDto recordDto) async {
    storedRecords.add(recordDto);
  }

  @override
  Future<void> updateRecord(String userId, RecordDto recordDto) async {
    final index = storedRecords.indexWhere((dto) => dto.id == recordDto.id);
    if (index != -1) {
      storedRecords[index] = recordDto;
    }
  }

  @override
  Future<void> deleteRecord(String userId, String recordId) async {
    storedRecords.removeWhere((dto) => dto.id == recordId);
  }

  @override
  Future<List<RecordDto>> getRecordByDate(String userId, DateTime date) async {
    return storedRecords
        .where(
          (dto) =>
              dto.date.year == date.year &&
              dto.date.month == date.month &&
              dto.date.day == date.day,
        )
        .toList();
  }

  // 필요없는 FirestoreDatasource 메서드는 UnimplementedError
  @override
  Future<UserDto?> getUser(String userId) async => throw UnimplementedError();

  @override
  Future<void> addUser(user) async => throw UnimplementedError();

  @override
  FirebaseFirestore get firestore => throw UnimplementedError();

  @override
  Future<List<RecordDto>> getRecord(String userId) {
    throw UnimplementedError();
  }
}

void main() {
  late FakeRecordDatasource fakeDataSource;
  late RecordRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeRecordDatasource();
    repository = RecordRepositoryImpl(fakeDataSource);
  });

  test('addRecord stores DTO correctly', () async {
    final record = CheckList(
      id: 'rec1',
      title: 'Test Checklist',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime(2025, 9, 12),
      items: [],
    );

    await repository.addRecord('user1', record);

    expect(fakeDataSource.storedRecords.length, 1);
    expect(fakeDataSource.storedRecords.first.id, 'rec1');
  });

  test('updateRecord modifies existing record', () async {
    final record = CheckList(
      id: 'rec1',
      title: 'Original Title',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime(2025, 9, 12),
      items: [],
    );

    await repository.addRecord('user1', record);

    // update
    final updatedRecord = CheckList(
      id: 'rec1',
      title: 'Updated Title',
      createdAt: record.createdAt,
      updatedAt: DateTime.now(),
      date: record.date,
      items: [],
    );

    await repository.updateRecord('user1', updatedRecord);

    final stored = fakeDataSource.storedRecords.first;
    expect(stored.id, 'rec1');
    expect(stored.title, 'Updated Title');
  });

  test('deleteRecord removes the record', () async {
    final record = CheckList(
      id: 'rec1',
      title: 'Checklist',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime(2025, 9, 12),
      items: [],
    );

    await repository.addRecord('user1', record);
    expect(fakeDataSource.storedRecords.length, 1);

    // when
    await repository.deleteRecord('user1', 'rec1');

    // then
    expect(fakeDataSource.storedRecords.length, 0);
  });

  test('getRecordByDate returns only records for that date', () async {
    // given: 저장된 DTO 2개
    final r1 = CheckList(
      id: 'rec1',
      title: 'Checklist 1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime(2025, 9, 12),
      items: [],
    );

    final r2 = CheckList(
      id: 'rec2',
      title: 'Checklist 2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime(2025, 9, 13),
      items: [],
    );

    await repository.addRecord('user1', r1);
    await repository.addRecord('user1', r2);

    // when: 9월12일꺼만 가져오기
    final result = await repository.getRecordByDate(
      'user1',
      DateTime(2025, 9, 12),
    );

    // then
    expect(result.length, 1);
    expect(result.first.id, 'rec1');
  });
}
