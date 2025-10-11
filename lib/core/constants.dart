import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';

class BorderBoxDecoration {
  static BoxDecoration commonBox = BoxDecoration(
    color: AppColors.containerColor,
    // border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
    borderRadius: BorderRadius.circular(12),
  );
  static BoxDecoration saveBox = BoxDecoration(
    color: AppColors.pointColor,
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
      return AppColors.level1Color;
    case RecordType.daily:
      return AppColors.level2Color;
    case RecordType.series:
      return AppColors.level3Color;
    case RecordType.memo:
      return AppColors.level4Color;
  }
}

Color emotionColor(Emotion emotion) {
  switch (emotion) {
    case Emotion.veryBad:
      return AppColors.level5Color;

    case Emotion.bad:
      return AppColors.level4Color;

    case Emotion.normal:
      return AppColors.level3Color;

    case Emotion.happy:
      return AppColors.level2Color;

    case Emotion.veryHappy:
      return AppColors.level1Color;
  }
}
