import 'package:flutter/material.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewCheckListPage extends ConsumerStatefulWidget {
  final String userId;
  final CheckList record;

  const ViewCheckListPage({
    super.key,
    required this.userId,
    required this.record,
  });

  @override
  ConsumerState<ViewCheckListPage> createState() => _ViewCheckListPageState();
}

class _ViewCheckListPageState extends ConsumerState<ViewCheckListPage> {
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
