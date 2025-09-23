import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_girok_app/presentation/pages/record/widgets/save_button.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListPage extends ConsumerStatefulWidget {
  final CheckList? editingRecord;
  const CheckListPage({super.key, this.editingRecord});

  @override
  ConsumerState<CheckListPage> createState() => _CheckListPageState();
}

class _CheckListPageState extends ConsumerState<CheckListPage> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _itemControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.editingRecord != null) {
      _titleController.text = widget.editingRecord!.title;
      for (final item in widget.editingRecord!.items) {
        final c = TextEditingController(text: item.content);
        _itemControllers.add(c);
      }
    } else {
      _itemControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // 기록 저장 로직
  Future<void> _saveRecord() async {
    final fbUser = fb.FirebaseAuth.instance.currentUser;

    /// fbUser != null지만 예외 처리를 위해 설정
    if (fbUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("로그인 후 사용 가능합니다.")));
      return;
    }

    final userId = fbUser.uid;
    print(userId);

    final items = _itemControllers
        .map((c) => CheckListItem(check: false, content: c.text))
        .toList();

    final now = DateTime.now();
    final record = CheckList(
      id: widget.editingRecord?.id ?? "",
      title: _titleController.text,
      createdAt: widget.editingRecord?.createdAt ?? now,
      updatedAt: now,
      // TODO : 캘린더 날짜 연동 필요
      date: now,
      items: items,
    );

    // 저장 및 수정 처리
    if (widget.editingRecord == null) {
      await ref.read(recordsProvider.notifier).addRecord(userId, record);
      debugPrint('Firestore addRecord OK: $userId, ${record.title}');
    } else {
      await ref.read(recordsProvider.notifier).updateRecord(userId, record);
    }
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // TODO : 캘린더 날짜 변경
          "9월 20일 토요일",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Title
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

                    // Check Item
                    ..._itemControllers.map((controller) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BorderBoxDecoration.commonBox,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BorderBoxDecoration.commonBox,
                                child: TextFormField(
                                  controller: controller,
                                  cursorColor: Colors.white,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "할 일을 입력하세요.",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),

                                    // focusedBorder:
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Add Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _itemControllers.add(TextEditingController());
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BorderBoxDecoration.commonBox,
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),

            // Button
            SaveButton(onPressed: _saveRecord),
          ],
        ),
      ),
    );
  }
}
