import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/domain/models/memo.dart';
import 'package:flutter_girok_app/presentation/pages/record/widgets/save_button.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoPage extends ConsumerStatefulWidget {
  final Memo? editingRecord;
  final DateTime date;
  const MemoPage({super.key, required this.date, this.editingRecord});

  @override
  ConsumerState<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends ConsumerState<MemoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.editingRecord != null) {
      _titleController.text = widget.editingRecord!.title;
      _contentController.text = widget.editingRecord!.content;
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

      final record = Memo(
        id: widget.editingRecord?.id ?? "",
        title: _titleController.text,
        createdAt: widget.editingRecord?.createdAt ?? now,
        updatedAt: now,
        date: widget.date,
        content: _contentController.text,
      );
      if (widget.editingRecord == null) {
        await ref.read(allRecordsProvider.notifier).addRecord(userId, record);
      } else {
        await ref
            .read(allRecordsProvider.notifier)
            .updateRecord(userId, record);
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
                            hintText: "원하는 메모를 작성해보세요.",
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
