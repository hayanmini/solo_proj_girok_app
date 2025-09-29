import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/domain/models/series.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/common_dialogs.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_check_list_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_daily_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_memo_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_series_page.dart';
import 'package:flutter_girok_app/presentation/providers/folder_provider.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MypageTab extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const MypageTab({super.key, required this.scrollController});

  @override
  ConsumerState<MypageTab> createState() => _MypageTabState();
}

class _MypageTabState extends ConsumerState<MypageTab> {
  bool _editMode = false;

  static const int pageSize = 10;
  int _currentRecordCount = pageSize;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = ref.watch(userIdProvider);
      if (userId != null) {
        ref.read(recordsProvider.notifier).loadRecordList(userId);
        ref.read(folderAsyncNotifierProvider.notifier).refreshFolders();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadMore() {
    setState(() {
      _currentRecordCount += pageSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userIdProvider);

    // 폴더 정보
    final foldersAsync = ref.watch(folderAsyncNotifierProvider);

    // 글 목록
    final recordsAsync = userId == null
        ? const AsyncValue<List<RecordModel>>.data([])
        : ref.watch(recordsProvider);

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (_editMode) setState(() => _editMode = false);
          },
          child: RefreshIndicator(
            color: Colors.white,
            onRefresh: () async {
              final userId = ref.read(userIdProvider);
              if (userId != null) {
                await ref.read(recordsProvider.notifier).loadRecordList(userId);
                await ref
                    .read(folderAsyncNotifierProvider.notifier)
                    .refreshFolders();
              }
            },
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 폴더
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleText("폴더"),
                      TextButton(
                        onPressed: () => setState(() => _editMode = !_editMode),
                        child: Text(
                          _editMode ? "완료" : "편집",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  foldersAsync.when(
                    data: (folders) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: folders.map((folder) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                                bottom: 12,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  if (!_editMode) return;
                                  if (folder.id == "defaultFolderId") return;

                                  final newName = await showEditNameDialog(
                                    context: context,
                                    title: "폴더 이름 수정",
                                    initialName: folder.name,
                                  );
                                  if (newName != null && newName.isNotEmpty) {
                                    await ref
                                        .read(
                                          folderAsyncNotifierProvider.notifier,
                                        )
                                        .updateFolderName(folder.id, newName);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 170,
                                      height: 100,
                                      decoration: BorderBoxDecoration.commonBox,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              const SizedBox(width: 15),
                                              const Icon(
                                                Icons.folder,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  folder.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16,
                                            ),
                                            child: recordsAsync.when(
                                              data: (records) {
                                                var count = 0;
                                                for (var record in records) {
                                                  if (record is Series) {
                                                    if (record.folder ==
                                                        folder.id) {
                                                      count++;
                                                    }
                                                  }
                                                }
                                                return Text(
                                                  "작성한 기록 : $count개",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                              loading: () => Text(
                                                "작성한 기록 로딩중",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              error: (_, _) => Text(
                                                "작성한 기록 불러오기 오류",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_editMode &&
                                        folder.id != "defaultFolderId")
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            final confirm =
                                                await showDeleteDialog(
                                                  context: context,
                                                  title: "폴더 삭제",
                                                  content: "정말 삭제하시겠습니까?",
                                                );
                                            if (confirm == true) {
                                              await ref
                                                  .read(
                                                    folderAsyncNotifierProvider
                                                        .notifier,
                                                  )
                                                  .deleteFolder(
                                                    folder.id,
                                                    "defaultFolderId",
                                                  );
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                    loading: () => Center(
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    error: (e, _) => Text("오류: $e"),
                  ),

                  SizedBox(height: 5),
                  Divider(),

                  // Record List
                  Consumer(
                    builder: (context, ref, _) {
                      final count = recordsAsync.value?.length ?? 0;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleText("내가 작성한 기록 ($count)"),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.grey),
                            onPressed: () async {
                              final userId = ref.read(userIdProvider);
                              if (userId != null) {
                                await ref
                                    .read(recordsProvider.notifier)
                                    .loadRecordList(userId);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  recordsAsync.when(
                    data: (records) {
                      if (records.isEmpty) {
                        return Container(
                          width: double.infinity,
                          decoration: BorderBoxDecoration.commonBox,
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            "작성한 기록이 없습니다.\nCreate 버튼을 눌러 새로운 기록을 작성해보세요!",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final slicedRecords = records
                          .take(_currentRecordCount)
                          .toList();
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BorderBoxDecoration.commonBox,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                for (final record in slicedRecords)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: _buildScheduleItem(
                                      record,
                                      record.title,
                                      record.type,
                                    ),
                                  ),
                                if (records.length > _currentRecordCount)
                                  TextButton(
                                    onPressed: _loadMore,
                                    child: const Text(
                                      "더보기",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    error: (e, _) => Text("오류: $e"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 타이틀 속성
  Widget titleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(title, style: TitleTextStyle.titleBold16),
    );
  }

  Widget _buildScheduleItem(dynamic record, String title, dynamic type) {
    return InkWell(
      onTap: () {
        final userId = ref.watch(userIdProvider);

        if (type.toString() == "RecordType.checklist") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ViewCheckListPage(userId: userId!, record: record),
            ),
          );
        } else if (type.toString() == "RecordType.daily") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewDailyPage(userId: userId!, record: record),
            ),
          );
        } else if (type.toString() == "RecordType.series") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewSeriesPage(userId: userId!, record: record),
            ),
          );
        } else if (type.toString() == "RecordType.memo") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewMemoPage(userId: userId!, record: record),
            ),
          );
        } else {
          Center(child: Text("오류가 발생했습니다."));
        }
      },
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 8),
            decoration: BorderBoxDecoration.commonBox,
            child: Icon(typeIcon(type), color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
