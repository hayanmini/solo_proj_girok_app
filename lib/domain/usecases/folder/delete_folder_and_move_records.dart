import 'package:flutter_girok_app/domain/repositories/folder_repository.dart';

class DeleteFolderAndMoveRecords {
  final FolderRepository repository;
  DeleteFolderAndMoveRecords(this.repository);

  Future<void> call({
    required String userId,
    required String folderId,
    required String defaultFolderId,
  }) {
    return repository.deleteFolderAndMoveRecords(
      userId: userId,
      folderId: folderId,
      defaultFolderId: defaultFolderId,
    );
  }
}
