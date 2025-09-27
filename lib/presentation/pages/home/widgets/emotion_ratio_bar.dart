import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/enums.dart';

class EmotionRatioBar extends StatelessWidget {
  final Map<Emotion, int> counts;
  const EmotionRatioBar({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold<int>(0, (p, e) => p + e);

    // 5개의 감정(Emotion.values) 순서 고정
    final allEmotions = Emotion.values;

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
              for (int i = 0; i < allEmotions.length; i++)
                Expanded(
                  flex: total == 0 ? 1 : counts[allEmotions[i]] ?? 0,
                  child: Container(
                    color: (counts[allEmotions[i]] ?? 0) > 0
                        ? _emotionColor(allEmotions[i])
                        : Colors.transparent,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 아이콘 + % 줄
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      ],
    );
  }

  Color _emotionColor(Emotion emotion) {
    switch (emotion) {
      case Emotion.veryBad:
        return Colors.red;
      case Emotion.bad:
        return Colors.orange;
      case Emotion.normal:
        return Colors.grey;
      case Emotion.happy:
        return Colors.lightGreen;
      case Emotion.veryHappy:
        return Colors.green;
    }
  }
}
