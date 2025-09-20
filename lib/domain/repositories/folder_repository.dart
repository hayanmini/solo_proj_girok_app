import 'package:flutter_girok_app/domain/models/folder.dart';

abstract class FolderRepository {
  Future<String> createFolder(String userId, String name);
  Future<List<Folder>> getFolders(String userId);

  Future<void> deleteFolderAndMoveRecords({
    required String userId,
    required String folderId,
    required String defaultFolderId,
  });

  Future<Map<String, int>> getFolderRecordCounts(String userId);
}
