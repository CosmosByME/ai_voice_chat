import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.1-flash-lite',
    systemInstruction: Content.system(
      'You are a helpful voice assistant. '
      'Keep responses concise and conversational — no bullet points, '
      'no markdown, no long lists. Respond in 2–3 sentences max. '
      'Sound natural when spoken aloud.',
    ),
    generationConfig: GenerationConfig(
      temperature: 0.8,
      topP: 0.92,
      topK: 40,
      maxOutputTokens: 300,
    ),
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none, null),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none, null),
      SafetySetting(
        HarmCategory.dangerousContent,
        HarmBlockThreshold.none,
        null,
      ),
    ],
  );

  Future<String> sendMessage(String message) async {
    try {
      final chat = model.startChat(
        history: [
          Content.text("Hello, my name is Muhammad"),
          Content.model([const TextPart("Nice to meet you Muhammad")]),
        ],
      );

      final response = await chat.sendMessage(Content.text(message));

      return response.text ?? "";
    } catch (e) {
      return 'Error: $e';
    }
  }
}
