import 'package:flutter_girok_app/data/data_sources/ai_remote_data_source.dart';
import 'package:flutter_girok_app/data/models/ai_request_dto.dart';
import 'package:flutter_girok_app/domain/models/ai/ai_request.dart';
import 'package:flutter_girok_app/domain/models/ai/ai_response.dart';
import 'package:flutter_girok_app/domain/repositories/ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remote;

  AiRepositoryImpl({required this.remote});

  @override
  Future<AiResponse> request(AiRequest req) async {
    final dto = AiRequestDto.fromDomain(req);
    final respDto = await remote.request(dto);
    return respDto.toDomain();
  }

  @override
  Stream<String> streamRequest(AiRequest req) {
    final dto = AiRequestDto.fromDomain(req);
    return remote.streamRequest(dto);
  }
}
