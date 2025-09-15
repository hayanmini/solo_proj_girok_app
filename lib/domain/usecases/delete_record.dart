import 'package:flutter_girok_app/domain/repositories/record_repository.dart';

class DeleteRecord {
  final RecordRepository repository;
  DeleteRecord(this.repository);

  Future<void> call(String userId, String recordId) =>
      repository.deleteRecord(userId, recordId);
}
