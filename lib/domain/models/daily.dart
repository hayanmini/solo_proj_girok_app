import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/domain/models/record.dart';

class Daily extends Record {
  final Emotion emotion;
  final String content;

  Daily({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.date,
    required this.emotion,
    required this.content,
  }) : super(type: RecordType.daily);
}
