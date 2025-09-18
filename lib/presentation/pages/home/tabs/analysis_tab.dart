import 'package:flutter/material.dart';

class AnalysisTab extends StatelessWidget {
  final ScrollController scrollController;
  const AnalysisTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(children: [Text("analysis")]),
    );
  }
}
