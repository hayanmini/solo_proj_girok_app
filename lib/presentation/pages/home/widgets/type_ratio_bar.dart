import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/enums.dart';

class TypeRatioBar extends StatelessWidget {
  final Map<RecordType, double> typePercents;
  const TypeRatioBar({super.key, required this.typePercents});

  @override
  Widget build(BuildContext context) {
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
            children: RecordType.values
                .where((type) => typePercents[type]! > 0)
                .toList()
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final type = entry.value;
                  final percent = typePercents[type]!;

                  return Expanded(
                    flex: (percent * 1000).toInt(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorForType(type),
                        borderRadius: BorderRadius.horizontal(
                          left: index == 0
                              ? const Radius.circular(6)
                              : Radius.zero,
                          right:
                              index ==
                                  RecordType.values
                                          .where((t) => typePercents[t]! > 0)
                                          .length -
                                      1
                              ? const Radius.circular(6)
                              : Radius.zero,
                        ),
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ),
        const SizedBox(height: 8),

        // 아이콘 + % 표기
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: RecordType.values.map((type) {
              final percent = typePercents[type]!;
              return Column(
                children: [
                  const SizedBox(height: 5),
                  Icon(_iconForType(type), color: Colors.white),
                  const SizedBox(height: 5),
                  Text('${percent.toStringAsFixed(1)}%'),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _iconForType(RecordType type) {
    switch (type) {
      case RecordType.checklist:
        return Icons.check_box;
      case RecordType.daily:
        return Icons.emoji_emotions;
      case RecordType.series:
        return Icons.edit_document;
      case RecordType.memo:
        return Icons.my_library_books_sharp;
    }
  }
}
