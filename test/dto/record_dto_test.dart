import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/data/models/record_dto.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_girok_app/domain/models/daily.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecordDTO Test', () {
    final checklist = Checklist(
      id: 'rec1',
      title: 'Test Checklist',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime(2025, 9, 12),
      items: [
        ChecklistItem(check: true, content: 'Item1'),
        ChecklistItem(check: false, content: 'Item2'),
      ],
    );

    test('Checklist → RecordDTO → JSON → Domain', () {
      final dto = RecordDto.fromDomain(checklist);
      final json = dto.toJson();
      final fromJson = RecordDto.fromFirestore(json).toDomain();

      expect(fromJson.id, checklist.id);
      expect(fromJson.title, checklist.title);
      expect(fromJson.type, checklist.type);
      expect((fromJson as Checklist).items.length, checklist.items.length);
      expect(fromJson.items[0].content, checklist.items[0].content);
    });

    final daily = Daily(
      id: 'rec2',
      title: 'Daily Test',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime(2025, 9, 12),
      emotion: Emotion.happy,
      content: 'Feeling good!',
    );

    test('Daily → RecordDTO → JSON → Domain', () {
      final dto = RecordDto.fromDomain(daily);
      final json = dto.toJson();
      final fromJson = RecordDto.fromFirestore(json).toDomain() as Daily;

      expect(fromJson.id, daily.id);
      expect(fromJson.title, daily.title);
      expect(fromJson.type, daily.type);
      expect(fromJson.emotion, daily.emotion);
      expect(fromJson.content, daily.content);
    });
  });
}
