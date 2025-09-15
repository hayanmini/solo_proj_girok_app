import 'package:flutter_girok_app/domain/repositories/record_repository.dart';

class AddRecord {
  final RecordRepository repository;
  AddRecord(this.repository);

  Future<void> call(String userId, Record record) =>
      repository.addRecord(userId, record);
}
