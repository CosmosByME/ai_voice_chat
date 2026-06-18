import 'package:ai_voice_chat/features/text_to_speech/data/voice_local_data_source.dart';

abstract class VoiceRepository {
  Future<void> setVoiceKokoro(String text);
  String? getVoiceKokoro();

  Future<void> setVoiceGoogle(String text);
  String? getVoiceGoogle();
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
}
