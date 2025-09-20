import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girok_app/data/models/folder_dto.dart';

class FolderRemoteDataSource {
  final FirebaseFirestore firestore;
  FolderRemoteDataSource(this.firestore);

  Future<void> createFolder(String userId, FolderDto dto) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('folders')
        .add(dto.toFirestore());
  }

  Future<List<FolderDto>> getFolders(String userId) async {
    final snap = await firestore
        .collection('users')
        .doc(userId)
        .collection('folders')
        .orderBy('createdAt')
        .get();

    return snap.docs
        .map((doc) => FolderDto.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> deleteFolderAndMoveRecords({
    required String userId,
    required String folderId,
    required String defaultFolderId,
  }) async {
    final batch = firestore.batch();

    final recordsSnap = await firestore
        .collection('users')
        .doc(userId)
        .collection('folders')
        .doc(folderId)
        .collection('records')
        .get();

    // Move Records
    for (final doc in recordsSnap.docs) {
      final defaultRef = firestore
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(defaultFolderId)
          .collection('records')
          .doc(doc.id);

      batch.set(defaultRef, doc.data());
      batch.delete(doc.reference);
    }

    // Folder Delete
    final folderRef = firestore
        .collection("users")
        .doc(userId)
        .collection("folders")
        .doc(folderId);

    batch.delete(folderRef);

    await batch.commit();
  }

  Future<Map<String, int>> getFolderRecordCounts(String userId) async {
    final folderSnapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("folders")
        .get();

    // Folder ID Count
    final counts = <String, int>{};
    for (final doc in folderSnapshot.docs) {
      final recordsSnap = await firestore
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(doc.id)
          .collection('records')
          .get();
      counts[doc.id] = recordsSnap.docs.length;
    }
    return counts;
  }
}
