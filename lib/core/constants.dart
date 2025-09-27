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
