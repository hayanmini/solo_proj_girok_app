import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
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
  static const int pageSize = 10;
  int _currentRecordCount = pageSize;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = ref.watch(userIdProvider);
      ref.read(recordsProvider.notifier).loadRecordList(userId!);
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
        ? AsyncValue.data([])
        : ref.watch(recordsProvider);

    return Scaffold(
      appBar: AppBar(title: Text("마이페이지")),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 폴더
            const SizedBox(height: 10),
            titleText("폴더"),
            const SizedBox(height: 10),
            foldersAsync.when(
              data: (folders) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final folder in folders)
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 12),
                          child: Container(
                            width: 170,
                            height: 100,
                            decoration: BorderBoxDecoration.commonBox,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.folder,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        folder.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (folder.id != "defaultFolderId") ...[
                                      IconButton(
                                        onPressed: () async {
                                          final controller =
                                              TextEditingController(
                                                text: folder.name,
                                              );
                                          final newName =
                                              await showDialog<String>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text("폴더 이름 변경"),
                                                  content: TextField(
                                                    controller: controller,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text("취소"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            controller.text,
                                                          ),
                                                      child: const Text("확인"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                          if (newName != null &&
                                              newName.trim().isNotEmpty) {
                                            await ref
                                                .read(
                                                  folderAsyncNotifierProvider
                                                      .notifier,
                                                )
                                                .updateFolderName(
                                                  folder.id,
                                                  newName,
                                                );
                                          }
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text("폴더 삭제"),
                                                  content: const Text(
                                                    "정말 삭제하시겠습니까?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            false,
                                                          ),
                                                      child: const Text("취소"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            true,
                                                          ),
                                                      child: const Text("삭제"),
                                                    ),
                                                  ],
                                                ),
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
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "개 글",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("오류: $e"),
            ),

            SizedBox(height: 15),
            Divider(),

            // Record List
            SizedBox(height: 10),
            titleText("내가 작성한 글"),
            SizedBox(height: 10),
            recordsAsync.when(
              data: (records) {
                final slicedRecords = records
                    .take(_currentRecordCount)
                    .toList();
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BorderBoxDecoration.commonBox,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          for (final record in slicedRecords)
                            _buildScheduleItem(record.title, record.type),
                          if (records.length > _currentRecordCount)
                            TextButton(
                              onPressed: _loadMore,
                              child: const Text("더보기"),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("오류: $e"),
            ),
          ],
        ),
      ),
    );
  }

  // 타이틀 속성
  Widget titleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(title, style: TitleTextStyle.titleBold16),
    );
  }

  Widget _buildScheduleItem(String title, dynamic type) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
