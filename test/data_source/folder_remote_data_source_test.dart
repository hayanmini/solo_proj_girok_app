import 'package:flutter_girok_app/data/models/folder_dto.dart';
import 'package:flutter_test/flutter_test.dart';

// 메모리용 DataSource 모의
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
    // 폴더만 삭제하는 시뮬레이션
    store[userId] = (store[userId] ?? [])
        .where((f) => f.id != folderId)
        .toList();
  }
}

void main() {
  test('MemoryFolderRemoteDataSource CRUD', () async {
    final ds = MemoryFolderRemoteDataSource();

    final dto = FolderDto(id: '1', name: '폴더', createdAt: DateTime.now());
    await ds.createFolder('user1', dto);

    var list = await ds.getFolders('user1');
    expect(list.length, 1);

    await ds.deleteFolderAndMoveRecords(
      userId: 'user1',
      folderId: '1',
      defaultFolderId: 'default',
    );
    list = await ds.getFolders('user1');
    expect(list.isEmpty, true);
  });
}
