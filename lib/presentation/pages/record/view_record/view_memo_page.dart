import 'package:flutter/material.dart';

class ViewMemoPage extends StatelessWidget {
  final String recordId;
  const ViewMemoPage({super.key, required this.recordId});

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
