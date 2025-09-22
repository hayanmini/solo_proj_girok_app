import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';

class CheckList extends RecordModel {
  final List<CheckListItem> items;

  CheckList({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    required super.date,
    required this.items,
  }) : super(type: RecordType.checklist);
}

class CheckListItem {
  final bool check;
  final String content;

  CheckListItem({required this.check, required this.content});
}
