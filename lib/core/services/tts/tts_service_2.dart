import 'package:ai_voice_chat/core/services/tts/tts_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService2 implements TtsService {
  final flutterTts = FlutterTts();

  @override
  Future<void> initialize({String? voiceType}) async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVoice({
      "name": voiceType ?? "en-us-x-tpc-local",
      "locale": "en-US",
    });
    await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers,
    ], IosTextToSpeechAudioMode.voicePrompt);
  }

  @override
  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> pause() async {
    await flutterTts.pause();
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> resume(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> changeLanguage(String language) async {
    await flutterTts.setLanguage(language);
  }

  Future<void> changePitch(double pitch) async {
    await flutterTts.setPitch(pitch);
  }

  Future<void> changeSpeechRate(double speechRate) async {
    await flutterTts.setSpeechRate(speechRate);
  }

  @override
  Future<void> changeVoice(String voiceType) async {
    await flutterTts.setVoice({'name': voiceType, 'locale': 'en-US'});
  }

  @override
  Future<void> dispose() async {
    await flutterTts.stop();
  }
}
