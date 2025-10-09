import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_girok_app/presentation/pages/record/widgets/save_button.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListPage extends ConsumerStatefulWidget {
  final DateTime date;
  final CheckList? editingRecord;

  const CheckListPage({super.key, required this.date, this.editingRecord});

  @override
  ConsumerState<CheckListPage> createState() => _CheckListPageState();
}

class _CheckListPageState extends ConsumerState<CheckListPage> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _itemControllers = [];
  final List<bool> _checkStates = [];

  @override
  void initState() {
    super.initState();

    if (widget.editingRecord != null) {
      _titleController.text = widget.editingRecord!.title;
      for (final item in widget.editingRecord!.items) {
        _itemControllers.add(TextEditingController(text: item.content));
        _checkStates.add(item.check);
      }
    } else {
      _itemControllers.add(TextEditingController());
      _checkStates.add(false);
    }

    _titleController.addListener(_onChanged);
    for (var controller in _itemControllers) {
      controller.addListener(_onChanged);
    }
  }

  void _onChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isSaveEnabled {
    final titleNotEmpty = _titleController.text.trim().isNotEmpty;
    final hasAtLeastOneItem = _itemControllers.any(
      (c) => c.text.trim().isNotEmpty,
    );
    return titleNotEmpty && hasAtLeastOneItem;
  }

  // 기록 저장 로직
  Future<void> _saveRecord() async {
    if (!_isSaveEnabled) {
      // TODO :  디자인 및 공통 위젯 생성
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("제목과 할 일을 모두 입력해주세요.")));
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

      final items = <CheckListItem>[];
      for (int i = 0; i < _itemControllers.length; i++) {
        final text = _itemControllers[i].text.trim();
        if (text.isNotEmpty) {
          items.add(CheckListItem(check: _checkStates[i], content: text));
        }
      }

      final now = DateTime.now();
      final record = CheckList(
        id: widget.editingRecord?.id ?? "",
        title: _titleController.text,
        createdAt: widget.editingRecord?.createdAt ?? now,
        updatedAt: now,
        date: widget.date,
        items: items,
      );

      // 저장 및 수정 처리
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
      ).showSnackBar(SnackBar(content: Text("저장 중 오류가 발생했습니다: $e")));
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
                      ...List.generate(_itemControllers.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _checkStates[i] = !_checkStates[i];
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BorderBoxDecoration.commonBox,
                                  child: _checkStates[i]
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BorderBoxDecoration.commonBox,
                                  child: TextFormField(
                                    controller: _itemControllers[i],
                                    cursorColor: Colors.white,
                                    textAlignVertical: i != 0
                                        ? TextAlignVertical.center
                                        : TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "할 일을 입력하세요.",
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      suffixIcon: i != 0
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _itemControllers
                                                      .removeAt(i)
                                                      .dispose();
                                                  _checkStates.removeAt(i);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                      // focusedBorder: ,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // 추가 버튼
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _itemControllers.add(TextEditingController());
                            _checkStates.add(false);
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
            ),
            SizedBox(height: 10),
            SaveButton(onPressed: _saveRecord),
          ],
        ),
      ),
    );
  }
}
