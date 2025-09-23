import 'package:flutter_girok_app/data/data_sources/folder_remote_data_source.dart';
import 'package:flutter_girok_app/data/models/folder_dto.dart';
import 'package:flutter_girok_app/domain/models/folder.dart';
import 'package:flutter_girok_app/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderRemoteDataSource remote;
  FolderRepositoryImpl(this.remote);

  @override
  Future<void> createFolder(String userId, String name) async {
    final dto = FolderDto(id: '', name: name, createdAt: DateTime.now());
    await remote.createFolder(userId, dto);
  }

  @override
  Future<List<Folder>> getFolders(String userId) async {
    final dtos = await remote.getFolders(userId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> deleteFolderAndMoveRecords({
    required String userId,
    required String folderId,
    required String defaultFolderId,
  }) {
    return remote.deleteFolderAndMoveRecords(
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
  }) => remote.updateFolderName(
    userId: userId,
    folderId: folderId,
    newName: newName,
  );

  @override
  Future<Map<String, int>> getFolderRecordCounts(String userId) {
    return remote.getFolderRecordCounts(userId);
  }
}
