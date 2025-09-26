import 'package:flutter_girok_app/domain/models/ai/ai_response.dart';

class AiResponseDto {
  final String content;

  AiResponseDto({required this.content});

  factory AiResponseDto.fromJson(Map<String, dynamic> json) {
    final content =
        json["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] as String? ??
        "";
    return AiResponseDto(content: content);
  }

  AiResponse toDomain() => AiResponse(content: content);
}
