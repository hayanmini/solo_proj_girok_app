import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/domain/models/record.dart';

class Memo extends Record {
  final String content;

  Memo({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.date,
    required this.content,
  }) : super(type: RecordType.memo);
}
