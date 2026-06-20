import 'package:ai_voice_chat/core/services/system/local_storage.dart';

abstract class VoiceLocalDataSource {
  Future<void> casheVoiceKokoro(String text);
  String? getVoiceKokoro();

  Future<void> casheVoiceGoogle(String text);
  String? getVoiceGoogle();

  Future<void> saveIsFastMode(bool isFast);
  bool getIsFastMode();
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

  @override
  Future<void> saveIsFastMode(bool isFast) {
    return localStorage.saveString('isFastMode', isFast.toString());
  }

  @override
  bool getIsFastMode() {
    final val = localStorage.getString('isFastMode');
    return val == null || val == 'true';
  }
}