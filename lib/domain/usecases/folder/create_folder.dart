import 'package:flutter_girok_app/domain/repositories/folder_repository.dart';

class CreateFolder {
  final FolderRepository repository;
  CreateFolder(this.repository);

  Future<void> call(String userId, String name) {
    return repository.createFolder(userId, name);
  }
}
