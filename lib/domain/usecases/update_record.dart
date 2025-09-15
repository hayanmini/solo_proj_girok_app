import 'package:flutter_girok_app/domain/repositories/record_repository.dart';

class UpdateRecord {
  final RecordRepository repository;
  UpdateRecord(this.repository);

  Future<void> call(String userId, Record record) =>
      repository.deleteRecord(userId, record);
}
