import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/domain/usecases/get_records_by_date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_girok_app/domain/usecases/add_record.dart';
import 'package:flutter_girok_app/domain/usecases/delete_record.dart';
import 'package:flutter_girok_app/domain/usecases/update_record.dart';
import 'package:flutter_girok_app/domain/repositories/record_repository.dart';

/// Fake Record Repository using RecordModel
class FakeRecordRepository implements RecordRepository {
  List<RecordModel> records = [];
  bool addCalled = false;
  bool deleteCalled = false;
  bool updateCalled = false;
  bool getByDateCalled = false;

  @override
  Future<void> addRecord(String userId, RecordModel record) async {
    addCalled = true;
    records.add(record);
  }

  @override
  Future<void> deleteRecord(String userId, String id) async {
    deleteCalled = true;
    records.removeWhere((r) => r.id == id);
  }

  @override
  Future<void> updateRecord(String userId, RecordModel record) async {
    updateCalled = true;
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) records[index] = record;
  }

  @override
  Future<List<RecordModel>> getRecordByDate(
    String userId,
    DateTime date,
  ) async {
    getByDateCalled = true;
    return records
        .where(
          (r) =>
              r.date.year == date.year &&
              r.date.month == date.month &&
              r.date.day == date.day,
        )
        .toList();
  }
}

void main() {
  group('RecordModel UseCase Tests', () {
    late FakeRecordRepository fakeRepo;
    late AddRecord addRecordUseCase;
    late DeleteRecord deleteRecordUseCase;
    late UpdateRecord updateRecordUseCase;
    late GetRecordsByDate getRecordsUseCase;

    setUp(() {
      fakeRepo = FakeRecordRepository();
      addRecordUseCase = AddRecord(fakeRepo);
      deleteRecordUseCase = DeleteRecord(fakeRepo);
      updateRecordUseCase = UpdateRecord(fakeRepo);
      getRecordsUseCase = GetRecordsByDate(fakeRepo);
    });

    test('AddRecord adds RecordModel', () async {
      final record = CheckList(
        id: 'r1',
        title: 'Test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: DateTime(2025, 9, 12),
        items: [],
      );

      await addRecordUseCase.call('user1', record);

      expect(fakeRepo.addCalled, true);
      expect(fakeRepo.records.contains(record), true);
    });

    test('DeleteRecord removes RecordModel', () async {
      final record = CheckList(
        id: 'r1',
        title: 'To Delete',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: DateTime(2025, 9, 12),
        items: [],
      );
      fakeRepo.records.add(record);

      await deleteRecordUseCase.call('user1', record.id);

      expect(fakeRepo.deleteCalled, true);
      expect(fakeRepo.records.contains(record), false);
    });

    test('UpdateRecord modifies existing RecordModel', () async {
      final record = CheckList(
        id: 'r1',
        title: 'Original',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: DateTime(2025, 9, 12),
        items: [],
      );
      fakeRepo.records.add(record);

      final updatedRecord = CheckList(
        id: 'r1',
        title: 'Updated',
        createdAt: record.createdAt,
        updatedAt: DateTime.now(),
        date: record.date,
        items: [],
      );

      await updateRecordUseCase.call('user1', updatedRecord);

      expect(fakeRepo.updateCalled, true);
      expect(fakeRepo.records.first.title, 'Updated');
    });

    test('GetRecords returns RecordModel for given date', () async {
      final r1 = CheckList(
        id: 'r1',
        title: 'A',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: DateTime(2025, 9, 12),
        items: [],
      );
      final r2 = CheckList(
        id: 'r2',
        title: 'B',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: DateTime(2025, 9, 13),
        items: [],
      );
      fakeRepo.records.addAll([r1, r2]);

      final result = await getRecordsUseCase.call(
        'user1',
        DateTime(2025, 9, 12),
      );

      expect(fakeRepo.getByDateCalled, true);
      expect(result.length, 1);
      expect(result.first.id, 'r1');
    });
  });
}
