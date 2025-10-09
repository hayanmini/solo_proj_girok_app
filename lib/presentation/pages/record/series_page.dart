import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/domain/models/folder.dart';
import 'package:flutter_girok_app/domain/models/series.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/common_dialogs.dart';
import 'package:flutter_girok_app/presentation/pages/record/widgets/save_button.dart';
import 'package:flutter_girok_app/presentation/providers/folder_provider.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeriesPage extends ConsumerStatefulWidget {
  final Series? editingRecord;
  final DateTime date;

  const SeriesPage({super.key, required this.date, this.editingRecord});

  @override
  ConsumerState<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends ConsumerState<SeriesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedFolderId;
  String? _selectedFolderName;

  static const String defaultFolderId = "defaultFolderId";
  static const String defaultFolderName = "기본 폴더";

  @override
  void initState() {
    super.initState();

    if (widget.editingRecord != null) {
      _titleController.text = widget.editingRecord!.title;
      _contentController.text = widget.editingRecord!.content;
      _selectedFolderId = widget.editingRecord!.folder;
      _selectedFolderName = widget.editingRecord!.folder == defaultFolderId
          ? defaultFolderName
          : "폴더";
    } else {
      _selectedFolderId = defaultFolderId;
      _selectedFolderName = defaultFolderName;
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
    return _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty &&
        _selectedFolderId != null &&
        _selectedFolderName != null;
  }

  Future<void> _saveRecord() async {
    if (!_isSaveEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("제목과 내용을 입력해주세요.")));
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
      final record = Series(
        id: widget.editingRecord?.id ?? "",
        title: _titleController.text,
        createdAt: widget.editingRecord?.createdAt ?? now,
        updatedAt: now,
        date: widget.date,
        folder: _selectedFolderId!,
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
      ).showSnackBar(SnackBar(content: Text("저장 중 오류가 발생했습니다: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(folderAsyncNotifierProvider);
    String getFolderName(String folderId, List<Folder> folders) {
      try {
        return folders.firstWhere((f) => f.id == folderId).name;
      } catch (e) {
        return "알 수 없음";
      }
    }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    InkWell(
                      onTap: () => _openFolderSelector(context, foldersAsync),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),

                        decoration: BorderBoxDecoration.commonBox,
                        child: Row(
                          children: [
                            const Icon(Icons.folder, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: foldersAsync.when(
                                data: (folders) {
                                  final folderName =
                                      _selectedFolderId == defaultFolderId
                                      ? defaultFolderName
                                      : getFolderName(
                                          _selectedFolderId!,
                                          folders,
                                        );
                                  return Text(
                                    folderName,
                                    style: const TextStyle(color: Colors.white),
                                  );
                                },
                                loading: () => const Text(
                                  "로딩중...",
                                  style: TextStyle(color: Colors.white),
                                ),
                                error: (_, __) => const Text(
                                  "폴더 정보 없음",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 제목
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BorderBoxDecoration.commonBox,
                      child: TextFormField(
                        controller: _titleController,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "제목을 입력하세요.",
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 내용 입력
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BorderBoxDecoration.commonBox,
                      child: TextFormField(
                        controller: _contentController,
                        cursorColor: Colors.white,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "내용을 입력하세요.",
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
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

  void _openFolderSelector(
    BuildContext context,
    AsyncValue<List<Folder>> foldersAsync,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Consumer(
          builder: (_, WidgetRef ref2, _) {
            final foldersAsync = ref2.watch(folderAsyncNotifierProvider);
            return foldersAsync.when(
              data: (folders) {
                final allFolders = [
                  Folder(
                    id: defaultFolderId,
                    name: defaultFolderName,
                    createdAt: DateTime.now(),
                  ),
                  ...folders.where((f) => f.id != defaultFolderId),
                ];

                return ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.create_new_folder_rounded),
                      title: const Text('새 폴더 만들기'),
                      onTap: () async {
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          final name = await showNewFolderDialog(context);
                          if (name != null && name.trim().isNotEmpty) {
                            await ref
                                .read(folderAsyncNotifierProvider.notifier)
                                .createFolder(name);

                            final updatedFolders =
                                ref.read(folderAsyncNotifierProvider).value ??
                                [];
                            final newFolder = updatedFolders.firstWhere(
                              (f) => f.name == name,
                            );
                            setState(() {
                              _selectedFolderId = newFolder.id;
                              _selectedFolderName = newFolder.name;
                            });
                          }
                        });
                      },
                    ),
                    const Divider(),

                    for (final folder in allFolders)
                      ListTile(
                        leading: const Icon(Icons.folder),
                        title: Text(folder.name),
                        trailing: folder.id != defaultFolderId
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final controller = TextEditingController(
                                        text: folder.name,
                                      );
                                      final newName = await showDialog<String>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("폴더 이름 수정"),
                                          content: TextField(
                                            controller: controller,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("취소"),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                context,
                                                controller.text.trim(),
                                              ),
                                              child: const Text("저장"),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (newName != null &&
                                          newName.isNotEmpty) {
                                        await ref
                                            .read(
                                              folderAsyncNotifierProvider
                                                  .notifier,
                                            )
                                            .updateFolderName(
                                              folder.id,
                                              newName,
                                            );
                                        if (_selectedFolderId == folder.id) {
                                          setState(() {
                                            _selectedFolderName = newName;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await _deleteFolder(context, folder.id);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedFolderId = folder.id;
                            _selectedFolderName = folder.name;
                          });
                          Navigator.pop(context);
                        },
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text("오류: $e")),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteFolder(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('폴더 삭제'),
        content: const Text('정말 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref
          .read(folderAsyncNotifierProvider.notifier)
          .deleteFolder(id, "defaultFolderId");
      if (_selectedFolderId == id) {
        setState(() {
          _selectedFolderId = "defaultFolderId";
          _selectedFolderName = "기본 폴더";
        });
      }
    }
  }
}
