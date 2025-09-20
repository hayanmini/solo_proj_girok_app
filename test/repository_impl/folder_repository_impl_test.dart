import 'package:flutter_girok_app/data/models/folder_dto.dart';
import 'package:flutter_girok_app/domain/models/folder.dart';
import 'package:flutter_girok_app/domain/repositories/folder_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// Memory RemoteDataSource
class MemoryFolderRemoteDataSource {
  final Map<String, List<FolderDto>> store = {};

  Future<List<FolderDto>> getFolders(String userId) async {
    return store[userId] ?? [];
  }

  Future<void> createFolder(String userId, FolderDto dto) async {
    store.putIfAbsent(userId, () => []);
    store[userId]!.add(dto);
  }

  Future<void> deleteFolderAndMoveRecords({
    required String userId,
    required String folderId,
    required String defaultFolderId,
  }) async {
    store[userId] = (store[userId] ?? [])
        .where((f) => f.id != folderId)
        .toList();
  }
}

// Memory RepositoryImpl
class MemoryFolderRepositoryImpl implements FolderRepository {
  final MemoryFolderRemoteDataSource remote;
  MemoryFolderRepositoryImpl(this.remote);

  @override
  Future<List<Folder>> getFolders(String userId) async {
    final dtos = await remote.getFolders(userId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Map<String, int>> getFolderRecordCounts(String userId) async {
    return {};
  }

  @override
  Future<void> createFolder(String userId, String name) async {
    final dto = FolderDto(id: '1', name: name, createdAt: DateTime.now());
    await remote.createFolder(userId, dto);
  }

  @override
  Future<void> deleteFolderAndMoveRecords({
    required String userId,
    required String folderId,
    required String defaultFolderId,
  }) async {
    await remote.deleteFolderAndMoveRecords(
      userId: userId,
      folderId: folderId,
      defaultFolderId: defaultFolderId,
    );
  }
}

void main() {
  test('MemoryFolderRepositoryImpl works', () async {
    final remote = MemoryFolderRemoteDataSource();
    final repo = MemoryFolderRepositoryImpl(remote);

    await repo.createFolder('user1', '폴더');

    final folders = await repo.getFolders('user1');
    expect(folders.length, 1);
    expect(folders.first.name, '폴더');

    await repo.deleteFolderAndMoveRecords(
      userId: 'user1',
      folderId: '1',
      defaultFolderId: 'default',
    );
    final folders2 = await repo.getFolders('user1');
    expect(folders2.isEmpty, true);
  });
}
