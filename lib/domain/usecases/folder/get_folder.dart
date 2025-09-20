import 'package:flutter_girok_app/domain/models/folder.dart';
import 'package:flutter_girok_app/domain/repositories/folder_repository.dart';

class GetFolder {
  final FolderRepository repository;
  GetFolder(this.repository);

  Future<List<Folder>> call(String userId) {
    return repository.getFolders(userId);
  }
}
