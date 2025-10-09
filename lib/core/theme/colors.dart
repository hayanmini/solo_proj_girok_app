import 'package:flutter/material.dart';

/// 앱 전역에서 사용하는 다크모드 전용 컬러 팔레트
class AppColors {
  static final dartColor = Color(0xFF1A162F);
  static final secondColor = Color(0xFF2A2543);

  static final pointColor = Color(0xFFBF9CD3);
  static final lightColor = Color(0xFFF3DBF3);

  static final whiteTextColor = Colors.white;
  static final lightTextColor = Color(0xFFDAD3F1);

  static final containerColor = Color(0xFF383554);
  static final lightContainColor = Color(0xFF4A476F);

  // static final dartColor = Color(0xFFC9B9E9);
  // static final secondColor = Color(0xFFF3ECFC);

  // static final pointColor = Color(0xFFE0C4EC);
  // static final lightColor = Color(0xFFFAF2FE);

  // static final whiteTextColor = Color(0xFFA893D5);
  // static final lightTextColor = Color(0xFFA08BCA);

  // static final containerColor = Color(0xFFDFD3F0);
  // static final lightContainColor = Color(0xFFF0E9FA);

  // 기본 배경
  static final Color background = dartColor;

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
