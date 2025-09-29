import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/common_dialogs.dart';
import 'package:flutter_girok_app/presentation/pages/record/check_list_page.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ViewCheckListPage extends ConsumerStatefulWidget {
  final String userId;
  final CheckList record;

  const ViewCheckListPage({
    super.key,
    required this.userId,
    required this.record,
  });

  @override
  ConsumerState<ViewCheckListPage> createState() => _ViewCheckListPageState();
}

class _ViewCheckListPageState extends ConsumerState<ViewCheckListPage> {
  late CheckList _localRecord;

  @override
  void initState() {
    super.initState();
    _localRecord = widget.record;
  }

  String get formattedDate {
    return DateFormat("M월 d일 EEEE", "ko_KR").format(_localRecord.date);
  }

  Future<void> _toggleItem(int index) async {
    final updatedItems = List<CheckListItem>.from(_localRecord.items);

    final oldItem = updatedItems[index];
    updatedItems[index] = CheckListItem(
      check: !oldItem.check,
      content: oldItem.content,
    );

    final updatedRecord = CheckList(
      id: _localRecord.id,
      title: _localRecord.title,
      createdAt: _localRecord.createdAt,
      updatedAt: DateTime.now(),
      date: _localRecord.date,
      items: updatedItems,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.check_box, color: Colors.white),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _localRecord.title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () async {
                    final updatedRecord = await Navigator.push<CheckList>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckListPage(
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
                  icon: Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemCount: _localRecord.items.length,
                itemBuilder: (context, i) {
                  final item = _localRecord.items[i];
                  return GestureDetector(
                    onTap: () => _toggleItem(i),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BorderBoxDecoration.commonBox,
                          alignment: Alignment.center,
                          child: item.check
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 15,
                            ),
                            decoration: BorderBoxDecoration.commonBox,
                            child: Text(
                              item.content,
                              maxLines: null,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                decoration: item.check
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
