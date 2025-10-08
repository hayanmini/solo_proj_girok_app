import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';
import 'package:flutter_girok_app/domain/models/daily.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/common_dialogs.dart';
import 'package:flutter_girok_app/presentation/pages/record/daily_page.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ViewDailyPage extends ConsumerStatefulWidget {
  final String userId;
  final Daily record;

  const ViewDailyPage({super.key, required this.userId, required this.record});

  @override
  ConsumerState<ViewDailyPage> createState() => _ViewDailyPageState();
}

class _ViewDailyPageState extends ConsumerState<ViewDailyPage> {
  late Daily _localRecord;

  @override
  void initState() {
    super.initState();
    _localRecord = widget.record;
  }

  String get formattedDate {
    return DateFormat("M월 d일 EEEE", "ko_KR").format(_localRecord.date);
  }

  Future<void> _changeEmotion(Emotion newEmotion) async {
    final updatedRecord = Daily(
      id: _localRecord.id,
      title: _localRecord.title,
      createdAt: _localRecord.createdAt,
      updatedAt: DateTime.now(),
      date: _localRecord.date,
      content: _localRecord.content,
      emotion: newEmotion,
    );
    setState(() {
      _localRecord = updatedRecord;
    });
    await ref
        .read(recordsProvider.notifier)
        .updateRecord(widget.userId, _localRecord);
  }

  Future<void> _deleteRecord() async {
    final confirm = await showConfirmDeleteDialog(
      context: context,
      title: "기록 삭제",
      content: "이 기록을 삭제하시겠습니까?",
    );
    if (confirm == true) {
      await ref
          .read(recordsProvider.notifier)
          .deleteRecord(widget.userId, _localRecord.id, _localRecord.date);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(formattedDate, style: TextStyle(color: Colors.white)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _deleteRecord();
            },
            icon: Icon(Icons.delete, color: Colors.white),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.emoji_emotions, color: Colors.white),
                ),
                SizedBox(width: 4),

                Expanded(
                  child: Text(
                    _localRecord.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: null,
                    softWrap: true,
                  ),
                ),

                IconButton(
                  onPressed: () async {
                    // 수정 페이지 이동
                    final updatedRecord = await Navigator.push<Daily>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DailyPage(
                          date: _localRecord.date,
                          editingRecord: _localRecord,
                        ),
                      ),
                    );
                    if (updatedRecord != null) {
                      setState(() {
                        _localRecord = updatedRecord;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BorderBoxDecoration.commonBox,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Emotion.values.map((emotion) {
                  final isSelected = _localRecord.emotion == emotion;
                  return GestureDetector(
                    onTap: () => _changeEmotion(emotion),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.pointColor : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        emotionIcon(emotion),
                        color: isSelected
                            ? AppColors.containerColor
                            : AppColors.textSecondary,
                        size: 30,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BorderBoxDecoration.commonBox,
                  child: Text(
                    _localRecord.content,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
