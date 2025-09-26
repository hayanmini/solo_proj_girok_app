import 'package:flutter_girok_app/domain/models/ai/ai_request.dart';

class AiRequestDto {
  final String prompt;
  final String model;
  final int maxTokens;
  final double temperature;

  AiRequestDto({
    required this.prompt,
    required this.model,
    required this.maxTokens,
    required this.temperature,
  });

  factory AiRequestDto.fromDomain(AiRequest domain) {
    return AiRequestDto(
      prompt: domain.prompt,
      model: domain.model,
      maxTokens: domain.maxTokens,
      temperature: domain.temperature,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "model": model,
      "message": [
        {"role": "user", "content": prompt},
      ],
      "max_tokens": maxTokens,
      "temperature": temperature,

      // 스트리밍 모드 사용 시
      "stream": true,
    };
  }
}
