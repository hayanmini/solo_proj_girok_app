import 'package:flutter_girok_app/data/models/folder_dto.dart';
import 'package:flutter_girok_app/domain/models/folder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FolderDto toDomain and fromDomain works', () {
    final now = DateTime.now();
    final folder = Folder(id: '1', name: '폴더', createdAt: now);
    final dto = FolderDto.fromDomain(folder);

    expect(dto.id, '1');
    expect(dto.name, '폴더');

    final domain = dto.toDomain();
    expect(domain.id, '1');
    expect(domain.name, '폴더');
  });
}
