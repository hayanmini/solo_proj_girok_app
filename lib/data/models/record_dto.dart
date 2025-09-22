// DTO 파이어베이스 전용 모델
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_girok_app/domain/models/daily.dart';
import 'package:flutter_girok_app/domain/models/memo.dart';
import 'package:flutter_girok_app/domain/models/series.dart';

class RecordDto {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final RecordType type;
  final Map<String, dynamic> extra;

  RecordDto({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.type,
    required this.extra,
  });

  factory RecordDto.fromDomain(RecordModel record) {
    Map<String, dynamic> extra = {};
    switch (record.type) {
      case RecordType.checklist:
        final checklist = record as CheckList;
        extra = {
          "items": checklist.items
              .map((e) => {"check": e.check, "content": e.content})
              .toList(),
        };
        break;
      case RecordType.daily:
        final daily = record as Daily;
        extra = {"emotion": daily.emotion.index, "content": daily.content};
        break;
      case RecordType.series:
        final series = record as Series;
        extra = {"folder": series.folder, "content": series.content};
        break;
      case RecordType.memo:
        final memo = record as Memo;
        extra = {"content": memo.content};
        break;
    }

    return RecordDto(
      id: record.id,
      title: record.title,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      date: record.date,
      type: record.type,
      extra: extra,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "createdAt": Timestamp.fromDate(createdAt),
    "updatedAt": Timestamp.fromDate(updatedAt),
    "date": Timestamp.fromDate(date),
    "type": type.name,
    "extra": extra,
  };

  RecordModel toDomain() {
    switch (type) {
      case RecordType.checklist:
        final itemsList = (extra["items"] as List<dynamic>?) ?? [];
        final items = itemsList.map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          return CheckListItem(
            check: map["check"] as bool,
            content: map["content"] as String,
          );
        }).toList();
        return CheckList(
          id: id,
          title: title,
          createdAt: createdAt,
          updatedAt: updatedAt,
          date: date,
          items: items,
        );

      case RecordType.daily:
        return Daily(
          id: id,
          title: title,
          createdAt: createdAt,
          updatedAt: updatedAt,
          date: date,
          emotion: Emotion.values[extra['emotion']],
          content: extra['content'],
        );

      case RecordType.series:
        return Series(
          id: id,
          title: title,
          createdAt: createdAt,
          updatedAt: updatedAt,
          date: date,
          folder: extra['folder'],
          content: extra['content'],
        );

      case RecordType.memo:
        return Memo(
          id: id,
          title: title,
          createdAt: createdAt,
          updatedAt: updatedAt,
          date: date,
          content: extra['content'],
        );
    }
  }

  factory RecordDto.fromFirestore(Map<String, dynamic> json) {
    final extraMap = Map<String, dynamic>.from(json["extra"] as Map? ?? {});
    return RecordDto(
      id: json['id'],
      title: json['title'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      date: (json['date'] as Timestamp).toDate(),
      type: RecordType.values.firstWhere((e) => e.name == json['type']),
      extra: extraMap,
    );
  }
}
