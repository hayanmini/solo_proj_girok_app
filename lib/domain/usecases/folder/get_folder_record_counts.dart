import 'package:flutter_girok_app/domain/repositories/folder_repository.dart';

class GetFolderRecordCounts {
  final FolderRepository repository;
  GetFolderRecordCounts(this.repository);

  Future<Map<String, int>> call(String userId) {
    return repository.getFolderRecordCounts(userId);
  }
}
