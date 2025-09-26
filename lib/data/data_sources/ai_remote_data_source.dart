import 'dart:convert';

import 'package:flutter_girok_app/data/models/ai_request_dto.dart';
import 'package:flutter_girok_app/data/models/ai_response_dto.dart';
import 'package:http/http.dart' as http;

class AiRemoteDataSource {
  final String apiKey;
  final String baseUrl;
  final http.Client client;

  AiRemoteDataSource({
    required this.apiKey,
    this.baseUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent",
    required this.client,
  });

  Future<AiResponseDto> request(AiRequestDto dto) async {
    final url = Uri.parse(baseUrl);
    final resp = await client.post(
      url,
      headers: {"Content-Type": "application/json", "X-goog-api-key": apiKey},
      body: json.encode({
        "contents": [
          {
            "parts": [
              {"text": dto.prompt},
            ],
          },
        ],
      }),
    );

    if (resp.statusCode == 200) {
      final Map<String, dynamic> j = json.decode(resp.body);
      return AiResponseDto.fromJson(j);
    } else {
      throw Exception("AI API error : ${resp.statusCode}, ${resp.body}");
    }
  }

  // 스트리밍 모드 사용 시
  Stream<String> streamRequest(AiRequestDto dto) async* {
    final url = Uri.parse("$baseUrl/chat/completions");
    final Map<String, dynamic> bodyMap = dto.toJson();
    bodyMap["stream"] = true;

    final request = http.Request("POST", url)
      ..headers.addAll({
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      })
      ..body = json.encode(bodyMap);

    final streamedResponse = await client.send(request);
    if (streamedResponse.statusCode != 200) {
      final err = await streamedResponse.stream.bytesToString();
      throw Exception("Streaming AI API error : $err");
    }

    // 청크 단위 스트림 처리
    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      for (final line in const LineSplitter().convert(chunk)) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        if (trimmed.startsWith("data:")) {
          final data = trimmed.substring(5).trim();
          if (data == "[DONE]") {
            return;
          }
          try {
            final Map<String, dynamic> j = json.decode(data);
            final delta = j["choices"]?[0]?["delta"]?["content"] as String?;
            if (delta != null) {
              yield delta;
            }
          } catch (e) {
            // 파싱 불가 무시
          }
        }
      }
    }
  }
}
