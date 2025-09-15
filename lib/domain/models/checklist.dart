import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';

class Checklist extends RecordModel {
  final List<ChecklistItem> items;

  Checklist({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.date,
    required this.items,
  }) : super(type: RecordType.checklist);
}

class ChecklistItem {
  final bool check;
  final String content;

  ChecklistItem({required this.check, required this.content});
}
