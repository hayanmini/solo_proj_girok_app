import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_girok_app/data/data_sources/firestore_datasource.dart';

/// FirestoreDatasource 인스턴스를 주입해주는 Provider
final firestoreDatasourceProvider = Provider<FirestoreDatasource>((ref) {
  return FirestoreDatasource(FirebaseFirestore.instance);
});
