import 'package:flutter_girok_app/core/enums.dart';

abstract class RecordModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final RecordType type;

  RecordModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.type,
  });
}
