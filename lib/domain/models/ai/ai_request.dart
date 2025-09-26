class AiRequest {
  final String prompt;
  final String model;
  final int maxTokens;
  final double temperature;

  AiRequest({
    required this.prompt,
    this.model = "gemini-2.5-flash",
    this.maxTokens = 256,
    this.temperature = 0.7,
  });
}
