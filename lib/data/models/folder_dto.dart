import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girok_app/domain/models/folder.dart';

class FolderDto {
  final String id;
  final String name;
  final DateTime createdAt;

  FolderDto({required this.id, required this.name, required this.createdAt});

  factory FolderDto.fromFirestore(Map<String, dynamic> json, String id) {
    return FolderDto(
      id: id,
      name: json["name"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {"name": name, "createdAt": createdAt};
  }

  Folder toDomain() {
    return Folder(id: id, name: name, createdAt: createdAt);
  }

  static FolderDto fromDomain(Folder folder) {
    return FolderDto(
      id: folder.id,
      name: folder.name,
      createdAt: folder.createdAt,
    );
  }
}
