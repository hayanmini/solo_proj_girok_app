import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/domain/repositories/record_repository.dart';

class UpdateRecord {
  final RecordRepository repository;
  UpdateRecord(this.repository);

  Future<void> call(String userId, RecordModel record) =>
      repository.updateRecord(userId, record);
}
