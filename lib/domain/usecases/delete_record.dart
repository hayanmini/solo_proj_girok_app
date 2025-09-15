import 'package:flutter_girok_app/domain/repositories/record_repository.dart';

class DeleteRecord {
  final RecordRepository repository;
  DeleteRecord(this.repository);

  Future<void> call(String userId, Record record) =>
      repository.deleteRecord(userId, record);
}
