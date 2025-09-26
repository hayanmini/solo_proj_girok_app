import 'package:flutter_girok_app/data/data_sources/ai_remote_data_source.dart';
import 'package:flutter_girok_app/data/models/ai_request_dto.dart';
import 'package:flutter_girok_app/domain/models/ai/ai_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('AI', () async {
    final apiKey = "API_KEY";
    final source = AiRemoteDataSource(apiKey: apiKey, client: http.Client());
    final response = await source.request(
      AiRequestDto.fromDomain(AiRequest(prompt: "PROMPT")),
    );
    expect(response.content, "");
  });
}
