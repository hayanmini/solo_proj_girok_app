import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/domain/models/daily.dart';
import 'package:flutter_girok_app/presentation/pages/record/widgets/save_button.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyPage extends ConsumerStatefulWidget {
  final Daily? editingRecord;
  final DateTime date;
  const DailyPage({super.key, required this.date, this.editingRecord});

  @override
  ConsumerState<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends ConsumerState<DailyPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Emotion _selectedEmotion = Emotion.normal;

  @override
  void initState() {
    super.initState();

    if (widget.editingRecord != null) {
      _titleController.text = widget.editingRecord!.title;
      _contentController.text = widget.editingRecord!.content;
      _selectedEmotion = widget.editingRecord!.emotion;
    }

    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _isSaveEnabled {
    final titleNotEmpty = _titleController.text.trim().isNotEmpty;
    final contentNotEmpty = _contentController.text.trim().isNotEmpty;
    return titleNotEmpty && contentNotEmpty;
  }

  Future<void> _saveRecord() async {
    if (!_isSaveEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("제목과 내용을 모두 입력해주세요.")));
      return;
    }

    final fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("로그인 후 사용 가능합니다.")));
      return;
    }
    try {
      final userId = fbUser.uid;
      final now = DateTime.now();

      final record = Daily(
        id: widget.editingRecord?.id ?? "",
        title: _titleController.text,
        createdAt: widget.editingRecord?.createdAt ?? now,
        updatedAt: now,
        date: widget.date,
        emotion: _selectedEmotion,
        content: _contentController.text,
      );

      if (widget.editingRecord == null) {
        await ref.read(recordsProvider.notifier).addRecord(userId, record);
      } else {
        await ref.read(recordsProvider.notifier).updateRecord(userId, record);
      }
      if (mounted) Navigator.pop(context, record);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("저장 중 오류가 발생했습니다. : $e ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateTitle =
        '${widget.date.month}월 ${widget.date.day}일 ${weekdayToKorean(widget.date.weekday)}요일';

    return Scaffold(
      appBar: AppBar(
        title: Text(dateTitle, style: TextStyle(color: Colors.white)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BorderBoxDecoration.commonBox,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: Emotion.values.map((emotion) {
                            final isSelected = _selectedEmotion == emotion;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedEmotion = emotion;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  emotionIcon(emotion),
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.white,
                                  size: 30,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 제목
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BorderBoxDecoration.commonBox,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          controller: _titleController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "제목을 입력하세요.",
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 내용
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: 200,
                          maxHeight: 300,
                        ),
                        decoration: BorderBoxDecoration.commonBox,
                        child: TextFormField(
                          controller: _contentController,
                          cursorColor: Colors.white,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "오늘 하루 있었던 일들을 자유롭게 적어보세요.",
                            contentPadding: EdgeInsets.all(15),
                          ),
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SaveButton(onPressed: _saveRecord),
          ],
        ),
      ),
    );
  }
}
