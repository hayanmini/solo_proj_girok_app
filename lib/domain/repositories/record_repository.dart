// 인터페이스
abstract class RecordRepository {
  Future<void> addRecord(String userId, Record record);
  Future<void> updateRecord(String userId, Record record);
  Future<void> deleteRecord(String userId, String recordId);
  Future<List<Record>> getRecordByDate(String userId, DateTime date);
}
