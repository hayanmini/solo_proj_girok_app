// 인터페이스
import 'package:flutter_girok_app/domain/models/record_model.dart';

abstract class RecordRepository {
  Future<void> addRecord(String userId, RecordModel record);
  Future<void> updateRecord(String userId, RecordModel record);
  Future<void> deleteRecord(String userId, String recordId);
  Future<List<RecordModel>> getRecords(String userId);
  Future<List<RecordModel>> getRecordByDate(String userId, DateTime date);
}
