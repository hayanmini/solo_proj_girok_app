// 앱 전역에서 쓰이는 상수
// 컬러, 폰트, 문자열, 이미지 경로 등
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/enums.dart';

class BorderBoxDecoration {
  static BoxDecoration commonBox = BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
    borderRadius: BorderRadius.circular(12),
  );
  static BoxDecoration saveBox = BoxDecoration(
    color: Color(0xFF2B2545),
    borderRadius: BorderRadius.circular(12),
  );
}

class TitleTextStyle {
  static const TextStyle titleBold16 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    color: Colors.white,
  );
  static const TextStyle recordTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.grey,
  );
}

String weekdayToKorean(int weekday) {
  switch (weekday) {
    case 1:
      return '월';
    case 2:
      return '화';
    case 3:
      return '수';
    case 4:
      return '목';
    case 5:
      return '금';
    case 6:
      return '토';
    default:
      return '일';
  }
}

IconData typeIcon(dynamic type) {
  switch (type.toString()) {
    case "RecordType.checklist":
      return Icons.check_box;
    case "RecordType.daily":
      return Icons.emoji_emotions;
    case "RecordType.series":
      return Icons.edit_document;
    case "RecordType.memo":
      return Icons.my_library_books_sharp;
    default:
      return Icons.note_add;
  }
}

IconData emotionIcon(Emotion emotion) {
  switch (emotion) {
    case Emotion.veryBad:
      return Icons.sentiment_very_dissatisfied;
    case Emotion.bad:
      return Icons.sentiment_dissatisfied;
    case Emotion.normal:
      return Icons.sentiment_neutral;
    case Emotion.happy:
      return Icons.sentiment_satisfied;
    case Emotion.veryHappy:
      return Icons.sentiment_very_satisfied;
  }
}

Color colorForType(RecordType type) {
  switch (type) {
    case RecordType.checklist:
      return Colors.green.shade100;
    case RecordType.daily:
      return Colors.green.shade200;
    case RecordType.series:
      return Colors.green.shade300;
    case RecordType.memo:
      return Colors.green.shade400;
  }
}

Color emotionColor(Emotion emotion) {
  switch (emotion) {
    case Emotion.veryBad:
      return Colors.green.shade100;
    case Emotion.bad:
      return Colors.green.shade200;
    case Emotion.normal:
      return Colors.green.shade300;
    case Emotion.happy:
      return Colors.green.shade400;
    case Emotion.veryHappy:
      return Colors.green.shade500;
  }
}
