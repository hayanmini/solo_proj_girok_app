import 'package:flutter_girok_app/presentation/providers/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/data/repositories/record_repository_impl.dart';

// 레포지토리 주입
final recordRepositoryProvider = Provider<RecordRepositoryImpl>((ref) {
  final datasource = ref.read(firestoreDatasourceProvider);
  return RecordRepositoryImpl(datasource);
});

// 조회 조건
class RecordQuery {
  final String userId;
  final DateTime? date;

  RecordQuery({required this.userId, this.date});
}

// Record Notifier
class RecordsNotifier extends AsyncNotifier<List<RecordModel>> {
  late final RecordRepositoryImpl _repository;

  @override
  Future<List<RecordModel>> build() async {
    _repository = ref.read(recordRepositoryProvider);
    return [];
  }

  Future<void> loadRecords(RecordQuery query) async {
    state = const AsyncValue.loading();
    try {
      final records = await _repository.getRecordByDate(
        query.userId,
        query.date ?? DateTime.now(),
      );
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadRecordList(String userId) async {
    state = const AsyncValue.loading();
    try {
      final recordList = await _repository.getRecords(userId);
      state = AsyncValue.data(recordList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRecord(String userId, RecordModel record) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addRecord(userId, record);
      await loadRecords(RecordQuery(userId: userId, date: record.date));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateRecord(String userId, RecordModel record) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateRecord(userId, record);
      await loadRecords(RecordQuery(userId: userId, date: record.date));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteRecord(
    String userId,
    String recordId,
    DateTime date,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteRecord(userId, recordId);
      await loadRecords(RecordQuery(userId: userId, date: date));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final recordsProvider =
    AsyncNotifierProvider<RecordsNotifier, List<RecordModel>>(
      RecordsNotifier.new,
    );
