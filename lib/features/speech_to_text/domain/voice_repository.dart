import 'package:ai_voice_chat/features/speech_to_text/data/voice_local_data_source.dart';

abstract class VoiceRepository {
  Future<void> setVoiceKokoro(String text);
  String? getVoiceKokoro();

  Future<void> setVoiceGoogle(String text);
  String? getVoiceGoogle();

  Future<void> setFastMode(bool isFast);
  bool getFastMode();
}

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceLocalDataSource voiceLocalDataSource;
  VoiceRepositoryImpl({required this.voiceLocalDataSource});

  @override
  Future<void> setVoiceKokoro(String text) {
    return voiceLocalDataSource.casheVoiceKokoro(text);
  }

  @override
  String? getVoiceKokoro() {
    return voiceLocalDataSource.getVoiceKokoro();
  }

  @override
  Future<void> setVoiceGoogle(String text) {
    return voiceLocalDataSource.casheVoiceGoogle(text);
  }

  @override
  String? getVoiceGoogle() {
    return voiceLocalDataSource.getVoiceGoogle();
  }

  @override
  Future<void> setFastMode(bool isFast) {
    return voiceLocalDataSource.saveIsFastMode(isFast);
  }

  @override
  bool getFastMode() {
    return voiceLocalDataSource.getIsFastMode();
  }
}
