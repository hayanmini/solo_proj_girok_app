import 'package:flutter_girok_app/data/data_sources/folder_remote_data_source.dart';
import 'package:flutter_girok_app/domain/models/folder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/folder_repository_impl.dart';
import '../../domain/repositories/folder_repository.dart';

// Firestore 인스턴스 Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// DataSource Provider
final folderRemoteDataSourceProvider = Provider<FolderRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FolderRemoteDataSource(firestore);
});

// Repository Provider
final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final remote = ref.watch(folderRemoteDataSourceProvider);
  return FolderRepositoryImpl(remote);
});

// Folder 목록 + CRUD 관리 AsyncNotifier
class FolderAsyncNotifier extends AsyncNotifier<List<Folder>> {
  final String id;

  FolderAsyncNotifier(this.id);

  @override
  Future<List<Folder>> build() async {
    // 초기 로드 (현재 로그인된 유저 ID 예: user1)
    return ref.read(folderRepositoryProvider).getFolders(id);
  }

  Future<void> refreshFolders() async {
    state = const AsyncLoading();
    final folders = await ref
        .read(folderRepositoryProvider)
        .getFolders('user1');
    state = AsyncData(folders);
  }

  Future<void> createFolder(String name) async {
    await ref.read(folderRepositoryProvider).createFolder('user1', name);
    await refreshFolders();
  }

  Future<void> deleteFolder(String folderId, String defaultFolderId) async {
    await ref
        .read(folderRepositoryProvider)
        .deleteFolderAndMoveRecords(
          userId: 'user1',
          folderId: folderId,
          defaultFolderId: defaultFolderId,
        );
    await refreshFolders();
  }
}

// Notifier Provider
final folderAsyncNotifierProvider =
    AsyncNotifierProvider.family<FolderAsyncNotifier, List<Folder>, String>(
      FolderAsyncNotifier.new,
    );
