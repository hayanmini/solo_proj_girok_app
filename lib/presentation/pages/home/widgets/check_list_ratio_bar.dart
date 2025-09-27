// widgets/checklist_ratio_bar.dart
import 'package:flutter/material.dart';

class CheckListRatioBar extends StatelessWidget {
  final int doneCount;
  final int totalCount;
  const CheckListRatioBar({
    super.key,
    required this.doneCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final donePercent = totalCount == 0 ? 0.0 : doneCount / totalCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 가로 막대
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (donePercent * 100).round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(6),
                      right: donePercent == 1.0
                          ? Radius.circular(6)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: (100 - (donePercent * 100).round()),
                child: Container(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 아이콘 + % 줄
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 5),
                  const Icon(Icons.check_box, color: Colors.white, size: 20),
                  const SizedBox(height: 5),
                  Text(
                    "${(donePercent * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 5),
                  const Icon(
                    Icons.disabled_by_default_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${(100 - donePercent * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
