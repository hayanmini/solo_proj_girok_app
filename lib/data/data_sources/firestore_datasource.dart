import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girok_app/data/models/record_dto.dart';
import 'package:flutter_girok_app/data/models/user_dto.dart';

class FirestoreDatasource {
  final FirebaseFirestore firestore;
  FirestoreDatasource(this.firestore);

  // User
  Future<void> addUser(UserDto user) async {
    await firestore.collection("users").doc(user.id).set(user.toJson());
  }

  Future<UserDto?> getUser(String userId) async {
    final doc = await firestore.collection("users").doc(userId).get();
    if (!doc.exists) return null;
    return UserDto.fromFirestore(doc.data()!);
  }

  // Record
  Future<void> addRecord(String userId, RecordDto record) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("records")
        .doc(record.id)
        .set(record.toJson());
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

  Future<List<RecordDto>> getRecordByDate(String userId, DateTime date) async {
    final snap = await firestore
        .collection("users")
        .doc(userId)
        .collection("records")
        .where(
          "date",
          isEqualTo: Timestamp.fromDate(
            DateTime(date.year, date.month, date.day),
          ),
        )
        .get();

    return snap.docs.map((doc) => RecordDto.fromFirestore(doc.data())).toList();
  }
}
