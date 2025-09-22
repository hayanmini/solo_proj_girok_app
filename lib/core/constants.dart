// 앱 전역에서 쓰이는 상수
// 컬러, 폰트, 문자열, 이미지 경로 등
import 'package:flutter/material.dart';

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
    fontSize: 16,
    color: Colors.white,
  );
  static const TextStyle recordTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.grey,
  );
}
