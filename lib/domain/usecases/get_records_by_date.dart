import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/domain/repositories/record_repository.dart';

class GetRecordsByDate {
  final RecordRepository repository;
  GetRecordsByDate(this.repository);

  Future<List<RecordModel>> call(String userId, DateTime date) =>
      repository.getRecordByDate(userId, date);
}
