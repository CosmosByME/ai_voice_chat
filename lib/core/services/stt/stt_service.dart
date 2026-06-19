import 'package:speech_to_text/speech_to_text.dart';

class STTService {
  final _stt = SpeechToText();

  bool get isAvailable => _stt.isAvailable;
  bool get isListening => _stt.isListening;

  Function(String)? _statusListener;
  Function(dynamic)? _errorListener;

  void setListeners({
    required Function(String) onStatus,
    required Function(dynamic) onError,
  }) {
    _statusListener = onStatus;
    _errorListener = onError;
  }

  Future<bool> initialize() async {
    if (_stt.isAvailable) return true;
    try {
      return await _stt.initialize(
        onStatus: (status) => _statusListener?.call(status),
        onError: (error) => _errorListener?.call(error),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> listen(Function(String) onSpeechResult) async {
    await _stt.listen(
      onResult: (result) {
        onSpeechResult(result.recognizedWords);
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        partialResults: true,
        pauseFor: const Duration(seconds: 10),
      ),
    );
  }

  Future<void> cancel() async {
    await _stt.cancel();
  }

  Future<void> stop() async {
    await _stt.stop();
  }
}
