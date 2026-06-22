import 'package:ai_voice_chat/core/services/system/local_storage.dart';

abstract class VoiceLocalDataSource {
  Future<void> cacheVoice(String text);
  String? getVoice();
}

class VoiceLocalDataSourceImpl implements VoiceLocalDataSource {
  final LocalStorage localStorage;
  VoiceLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> cacheVoice(String text) {
    return localStorage.saveString('voiceGoogle', text);
  }

  @override
  String? getVoice() {
    return localStorage.getString('voiceGoogle');
  }
}