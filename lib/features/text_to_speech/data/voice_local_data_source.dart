import 'package:ai_voice_chat/core/services/local_storage.dart';

abstract class VoiceLocalDataSource {
  Future<void> casheVoiceKokoro(String text);
  String? getVoiceKokoro();

  Future<void> casheVoiceGoogle(String text);
  String? getVoiceGoogle();
}

class VoiceLocalDataSourceImpl implements VoiceLocalDataSource {
  final LocalStorage localStorage;
  VoiceLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> casheVoiceKokoro(String text) {
    return localStorage.saveString('voiceKokoro', text);
  }

  @override
  String? getVoiceKokoro() {
    return localStorage.getString('voiceKokoro');
  }

  @override
  Future<void> casheVoiceGoogle(String text) {
    return localStorage.saveString('voiceGoogle', text);
  }

  @override
  String? getVoiceGoogle() {
    return localStorage.getString('voiceGoogle');
  }
}