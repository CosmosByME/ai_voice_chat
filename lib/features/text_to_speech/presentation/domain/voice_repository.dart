import 'package:ai_voice_chat/features/text_to_speech/presentation/data/voice_local_data_source.dart';

abstract class VoiceRepository {
  Future<void> setVoice(String text);
  String? getVoice();
}

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceLocalDataSource voiceLocalDataSource;
  VoiceRepositoryImpl({required this.voiceLocalDataSource});

  @override
  Future<void> setVoice(String text) {
    return voiceLocalDataSource.casheVoice(text);
  }

  @override
  String? getVoice() {
    return voiceLocalDataSource.getVoice();
  }
}