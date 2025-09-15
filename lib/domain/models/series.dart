import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';

class Series extends RecordModel {
  final String folder;
  final String content;

  Series({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.date,
    required this.folder,
    required this.content,
  }) : super(type: RecordType.series);
}
