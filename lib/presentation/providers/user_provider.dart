import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_girok_app/data/data_sources/firestore_datasource.dart';
import 'package:flutter_girok_app/data/repositories/user_repository_impl.dart';
import 'package:flutter_girok_app/domain/models/user.dart';

// FirestoreDatasourceProvider
final firestoreDatasourceProvider = Provider((ref) {
  return FirestoreDatasource(FirebaseFirestore.instance);
});

// UserRepositoryImpl 주입
final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final ds = ref.watch(firestoreDatasourceProvider);
  return UserRepositoryImpl(ds);
});

// 특정 uid의 User 프로필 로드
final userProfileProvider = FutureProvider.family<User?, String>((
  ref,
  userId,
) async {
  final repo = ref.watch(userRepositoryProvider);
  return await repo.getUser(userId);
});
