import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisTab extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const AnalysisTab({super.key, required this.scrollController});

  @override
  ConsumerState<AnalysisTab> createState() => _AnalysisTabState();
}

class _AnalysisTabState extends ConsumerState<AnalysisTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 10),
            titleText("분석"),
            const SizedBox(height: 10),
            Container(height: 100, decoration: BorderBoxDecoration.commonBox),
            const SizedBox(height: 15),
            Divider(),

            const SizedBox(height: 10),
            titleText("분석"),
            const SizedBox(height: 10),
            Container(height: 120, decoration: BorderBoxDecoration.commonBox),
            const SizedBox(height: 15),
            Divider(),

            const SizedBox(height: 10),
            titleText("분석"),
            const SizedBox(height: 10),
            Container(height: 120, decoration: BorderBoxDecoration.commonBox),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget titleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(title, style: TitleTextStyle.titleBold16),
    );
  }
}
