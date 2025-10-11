import 'package:flutter/material.dart';

/// 앱 전역에서 사용하는 다크모드 전용 컬러 팔레트
class AppColors {
  static final dartColor = Color.fromARGB(255, 28, 28, 29);
  static final secondColor = Color.fromARGB(255, 28, 28, 29);

  static final pointColor = Color.fromARGB(255, 98, 93, 152);
  static final lightColor = Color.fromARGB(255, 225, 219, 243);

  static final whiteTextColor = Colors.white;
  static final lightTextColor = Color(0xFFDAD3F1);

  static final containerColor = Color.fromARGB(255, 40, 40, 41);
  static final lightContainColor = Color(0xFF4A476F);

  static final level1Color = Color.fromARGB(255, 164, 156, 255);
  static final level2Color = Color.fromARGB(255, 142, 134, 231);
  static final level3Color = Color.fromARGB(255, 118, 110, 196);
  static final level4Color = Color.fromARGB(255, 94, 89, 149);
  static final level5Color = Color(0xFF4A476F);

  // 기본 배경
  static final Color background = dartColor;
  static final Color backGrey = secondColor;

  // 카드나 컨테이너 배경
  static final Color surface = containerColor;
  static final Color surfaceSecondary = lightContainColor;

  // 포인트 컬러 (버튼, 강조 텍스트 등)
  static final Color primary = secondColor;

  // 텍스트 색상
  static final Color textPrimary = whiteTextColor;
  static final Color textSecondary = lightTextColor;

  // 구분선, 테두리 등
  static final Color divider = lightColor;

  // 에러
  static Color error = pointColor;
}
