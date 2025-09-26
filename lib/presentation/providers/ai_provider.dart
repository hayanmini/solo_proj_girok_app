import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_girok_app/data/data_sources/ai_remote_data_source.dart';
import 'package:flutter_girok_app/data/repositories/ai_repository_impl.dart';
import 'package:flutter_girok_app/domain/repositories/ai_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final aiRemoteDataSourceProvider = Provider<AiRemoteDataSource>((ref) {
  final apiKey = dotenv.env['API_KEY'] ?? "";
  final client = ref.watch(httpClientProvider);
  return AiRemoteDataSource(apiKey: apiKey, client: client);
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  final ds = ref.watch(aiRemoteDataSourceProvider);
  return AiRepositoryImpl(remote: ds);
});
