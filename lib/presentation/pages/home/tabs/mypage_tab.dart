import 'package:flutter/material.dart';

class MypageTab extends StatelessWidget {
  final ScrollController scrollController;
  const MypageTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(children: [Text("mypage")]),
    );
  }
}
