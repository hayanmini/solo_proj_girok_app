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

  Future<void> updateFolderName({
    required String userId,
    required String folderId,
    required String newName,
  }) async {
    final folders = store[userId];
    if (folders == null) return;

    for (var f in folders) {
      if (f.id == folderId) {
        // FolderDto는 일반 class라면 이렇게 직접 필드 변경 가능
        // 테스트에서는 DTO name에서 final 지우고 테스트
        // 실전에서는 상관없음.
        // f.name = newName;
        break;
      }
    }
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

  @override
  Future<void> updateFolderName({
    required String userId,
    required String folderId,
    required String newName,
  }) async {
    await remote.updateFolderName(
      userId: userId,
      folderId: folderId,
      newName: newName,
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

  test('MemoryFolderRepositoryImpl updateFolderName', () async {
    final remote = MemoryFolderRemoteDataSource();
    final repo = MemoryFolderRepositoryImpl(remote);

    await repo.createFolder('user1', '폴더');

    var folders = await repo.getFolders('user1');
    final id = folders.first.id;

    // 이름 변경
    await repo.updateFolderName(userId: 'user1', folderId: id, newName: '새폴더');

    folders = await repo.getFolders('user1');
    expect(folders.first.name, '새폴더');
  });
}
