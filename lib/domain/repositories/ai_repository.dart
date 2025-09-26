import 'package:flutter_girok_app/domain/models/ai/ai_request.dart';
import 'package:flutter_girok_app/domain/models/ai/ai_response.dart';

abstract class AiRepository {
  Future<AiResponse> request(AiRequest req);
  Stream<String> streamRequest(AiRequest request);
}
