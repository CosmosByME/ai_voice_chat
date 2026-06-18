abstract class TtsService {
  Future<void> initialize();
  Future<void> speak(String text);
  // Future<void> pause();
  // Future<void> stop();
  // Future<void> resume(String text);
  // Future<void> changeLanguage(String language);
  // Future<void> changePitch(double pitch);
  // Future<void> changeSpeechRate(double speechRate);
  Future<void> changeVoice(String voiceType);
  Future<void> dispose();
}
