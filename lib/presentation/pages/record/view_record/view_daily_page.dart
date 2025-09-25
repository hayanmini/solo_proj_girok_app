import 'package:flutter/material.dart';
import 'package:flutter_girok_app/domain/models/daily.dart';

class ViewDailyPage extends StatelessWidget {
  final String userId;
  final Daily record;

  const ViewDailyPage({super.key, required this.userId, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // TODO : 캘린더 날짜 변경
          "9월 20일 토요일",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Scaffold(),
    );
  }
}
