import 'package:flutter_girok_app/data/data_sources/folder_remote_data_source.dart';
import 'package:flutter_girok_app/domain/models/folder.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
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
  @override
  Future<List<Folder>> build() async {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return [];
    return ref.read(folderRepositoryProvider).getFolders(userId);
  }

  Future<void> refreshFolders() async {
    state = const AsyncLoading();
    final userId = ref.watch(userIdProvider);
    if (userId == null) return;
    final folders = await ref.read(folderRepositoryProvider).getFolders(userId);
    state = AsyncData(folders);
  }

  Future<void> createFolder(String name) async {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return;
    await ref.read(folderRepositoryProvider).createFolder(userId, name);
    await refreshFolders();
  }

  Future<void> deleteFolder(String folderId, String defaultFolderId) async {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return;
    await ref
        .read(folderRepositoryProvider)
        .deleteFolderAndMoveRecords(
          userId: userId,
          folderId: folderId,
          defaultFolderId: defaultFolderId,
        );
    await refreshFolders();
  }

  Future<void> updateFolderName(String folderId, String newName) async {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return;
    await ref
        .read(folderRepositoryProvider)
        .updateFolderName(userId: userId, folderId: folderId, newName: newName);
    await refreshFolders();
  }
}

// Notifier Provider
final folderAsyncNotifierProvider =
    AsyncNotifierProvider<FolderAsyncNotifier, List<Folder>>(
      FolderAsyncNotifier.new,
    );
