import 'package:flutter_girok_app/domain/models/ai/ai_request.dart';
import 'package:flutter_girok_app/domain/models/ai/ai_response.dart';

abstract class AiRepository {
  Future<AiResponse> request(AiRequest req);

  // 스트리밍 모드 사용 시
  Stream<String> streamRequest(AiRequest request);
}
