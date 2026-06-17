import 'package:ai_voice_chat/core/services/local_storage.dart';

abstract class VoiceLocalDataSource {
  Future<void> casheVoice(String text);
  String? getVoice();
}

class VoiceLocalDataSourceImpl implements VoiceLocalDataSource {
  final LocalStorage localStorage;
  VoiceLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> casheVoice(String text) {
    return localStorage.saveString('voice', text);
  }

  @override
  String? getVoice() {
    return localStorage.getString('voice');
  }
}