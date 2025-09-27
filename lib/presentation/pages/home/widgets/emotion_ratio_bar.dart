import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/enums.dart';

class EmotionRatioBar extends StatelessWidget {
  final Map<Emotion, int> counts;
  const EmotionRatioBar({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold<int>(0, (p, e) => p + e);
    final allEmotions = Emotion.values;

    final nonZeroEmotions = allEmotions
        .where((e) => (counts[e] ?? 0) > 0)
        .toList();

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
              if (nonZeroEmotions.isEmpty)
                // 모든 값이 0일 때
                Expanded(child: Container(color: Colors.transparent))
              else
                for (int i = 0; i < nonZeroEmotions.length; i++)
                  Expanded(
                    flex: counts[nonZeroEmotions[i]]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: emotionColor(nonZeroEmotions[i]),
                        borderRadius: BorderRadius.horizontal(
                          left: i == 0 ? const Radius.circular(6) : Radius.zero,
                          right: i == nonZeroEmotions.length - 1
                              ? const Radius.circular(6)
                              : Radius.zero,
                        ),
                      ),
                    ),
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
              for (int i = 0; i < allEmotions.length; i++)
                Column(
                  children: [
                    SizedBox(height: 5),

                    Icon(
                      emotionIcon(allEmotions[i]),
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(height: 5),
                    Text(
                      total == 0
                          ? "0%"
                          : "${((counts[allEmotions[i]] ?? 0) / total * 100).toStringAsFixed(0)}%",
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
