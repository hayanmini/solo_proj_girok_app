import 'package:flutter_girok_app/domain/models/ai/ai_response.dart';

class AiResponseDto {
  final String content;

  AiResponseDto({required this.content});

  factory AiResponseDto.fromJson(Map<String, dynamic> json) {
    final content =
        json["choices"]?[0]?["message"]?["content"] as String? ?? "";
    return AiResponseDto(content: content);
  }

  AiResponse toDomain() => AiResponse(content: content);
}
