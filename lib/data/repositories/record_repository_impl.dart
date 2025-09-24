import 'package:flutter_girok_app/data/data_sources/firestore_datasource.dart';
import 'package:flutter_girok_app/data/models/record_dto.dart';
import 'package:flutter_girok_app/domain/repositories/record_repository.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';

class RecordRepositoryImpl implements RecordRepository {
  final FirestoreDatasource datasource;
  RecordRepositoryImpl(this.datasource);

  @override
  Future<void> addRecord(String userId, RecordModel record) async {
    final dto = RecordDto.fromDomain(record);
    await datasource.addRecord(userId, dto);
  }

  @override
  Future<void> updateRecord(String userId, RecordModel record) async {
    final dto = RecordDto.fromDomain(record);
    await datasource.updateRecord(userId, dto);
  }

  @override
  Future<void> deleteRecord(String userId, String recordId) async {
    await datasource.deleteRecord(userId, recordId);
  }

  @override
  Future<List<RecordModel>> getRecords(String userId) async {
    final dtos = await datasource.getRecord(userId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<RecordModel>> getRecordByDate(
    String userId,
    DateTime date,
  ) async {
    final dtos = await datasource.getRecordByDate(userId, date);
    return dtos.map((e) => e.toDomain()).toList();
  }
}
