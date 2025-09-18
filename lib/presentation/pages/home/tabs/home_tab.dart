import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final ScrollController scrollController;
  const HomeTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(children: [Text("home")]),
    );
  }
}
