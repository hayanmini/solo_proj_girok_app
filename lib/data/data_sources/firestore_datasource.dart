import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girok_app/data/models/record_dto.dart';
import 'package:flutter_girok_app/data/models/user_dto.dart';

extension _DeleteCollection on CollectionReference {
  Future<void> deleteAll() async {
    final snapshots = await get();
    for (final doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}

class FirestoreDatasource {
  final FirebaseFirestore firestore;
  FirestoreDatasource(this.firestore);

  // User
  Future<void> addUser(UserDto user) async {
    await firestore
        .collection("users")
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true));

    // 처음 생성 시 기본 폴더 생성
    final defaultRef = firestore
        .collection('users')
        .doc(user.id)
        .collection('folders')
        .doc("defaultFolderId");

    final doc = await defaultRef.get();
    if (!doc.exists) {
      await defaultRef.set({'name': "기본 폴더", 'createdAt': DateTime.now()});
    }
  }

  Future<UserDto?> getUser(String userId) async {
    final doc = await firestore.collection("users").doc(userId).get();
    if (!doc.exists) return null;
    return UserDto.fromFirestore(doc.data()!);
  }

  Future<void> deleteUser(String userId) async {
    final userRef = firestore.collection("users").doc(userId);

    // 모든 데이터 삭제
    await userRef.collection("records").deleteAll();
    await userRef.collection("folders").deleteAll();
    await userRef.delete();
  }

  // Record
  Future<void> addRecord(String userId, RecordDto record) async {
    final docRef = firestore
        .collection("users")
        .doc(userId)
        .collection("records")
        .doc();

    // 여기서 미리 생성된 ID 사용
    final recordWithId = RecordDto(
      id: docRef.id,
      title: record.title,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      date: record.date,
      type: record.type,
      extra: record.extra,
    );
    await docRef.set(recordWithId.toJson());
  }

  Future<void> updateRecord(String userId, RecordDto record) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("records")
        .doc(record.id)
        .update(record.toJson());
  }

  Future<void> deleteRecord(String userId, String recordId) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("records")
        .doc(recordId)
        .delete();
  }

  Future<List<RecordDto>> getRecord(String userId) async {
    final snap = await firestore
        .collection("users")
        .doc(userId)
        .collection("records")
        .orderBy('date', descending: true)
        .get();

    return snap.docs.map((doc) => RecordDto.fromFirestore(doc.data())).toList();
  }

  Future<List<RecordDto>> getRecordByDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day); // 00:00
    final endOfDay = startOfDay.add(const Duration(days: 1)); // 다음날 00:00
    final snap = await firestore
        .collection("users")
        .doc(userId)
        .collection("records")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("date", isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    return snap.docs.map((doc) => RecordDto.fromFirestore(doc.data())).toList();
  }
}
