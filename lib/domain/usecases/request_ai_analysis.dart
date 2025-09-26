import 'package:flutter_girok_app/domain/models/ai/ai_request.dart';
import 'package:flutter_girok_app/domain/models/ai/ai_response.dart';
import 'package:flutter_girok_app/domain/repositories/ai_repository.dart';

class RequestAiAnalysis {
  final AiRepository _repo;

  RequestAiAnalysis(this._repo);

  Future<AiResponse> call(String prompt) async {
    // 필요하면 여기서 전처리/후처리
    final req = AiRequest(prompt: prompt);
    return await _repo.request(req);
  }
}
