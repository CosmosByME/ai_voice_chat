import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/core/services/stt/stt_service.dart';
import 'package:ai_voice_chat/core/services/tts/audio_sevice.dart';
import 'package:ai_voice_chat/core/services/tts/tts_service_2.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'speach_event.dart';
part 'speach_state.dart';

class SpeachBloc extends Bloc<SpeachEvent, SpeachState> {
  /// Guards against duplicate submissions. Set to true once a SpeechStop
  /// with non-empty text is emitted. Reset only when a new StartListening
  /// begins a fresh recording session.
  bool _hasSubmitted = false;

  SpeachBloc() : super(SpeachInitial()) {
    sl<STTService>().setListeners(
      onStatus: (status) {
        add(SpeechStatusChanged(status: status));
      },
      onError: (error) {
        add(SpeechErrorOccurred(error: error.toString()));
      },
    );

    on<StartListening>((event, emit) async {
      _hasSubmitted = false;
      emit(SpeachListening(text: ''));
      try {
        await sl<AudioService>().stop();
        await sl<TTSService2>().stop();
      } catch (_) {}
      
      final isAvailable = await sl<STTService>().initialize();
      if (isAvailable) {
        await sl<STTService>().listen((p0) {
          add(SpeechResultUpdated(text: p0));
        });
      } else {
        add(SpeechErrorOccurred(error: 'Speech recognition is not available or permission denied'));
      }
    });

    on<SpeechResultUpdated>((event, emit) {
      // Only accept results while still in a listening session.
      if (!_hasSubmitted) {
        emit(SpeachListening(text: event.text));
      }
    });

    on<SpeechStatusChanged>((event, emit) {
      // If we've already submitted for this session, ignore all further
      // status changes (the plugin can fire 'notListening' and 'done'
      // multiple times).
      if (_hasSubmitted) return;

      final currentText = state is SpeachListening
          ? (state as SpeachListening).text
          : (state is SpeechStop ? (state as SpeechStop).text : '');

      if (event.status == 'listening') {
        emit(SpeachListening(text: currentText));
      } else if (event.status == 'notListening' || event.status == 'done') {
        _hasSubmitted = currentText.isNotEmpty;
        emit(SpeechStop(text: currentText));
      }
    });

    on<SpeechErrorOccurred>((event, emit) {
      emit(SpeechError(error: event.error));
    });

    on<StopListening>((event, emit) async {
      if (_hasSubmitted) return;
      _hasSubmitted = event.text.isNotEmpty;
      await sl<STTService>().stop();
      emit(SpeechStop(text: event.text));
    });

    on<Dispose>((event, emit) async {
      _hasSubmitted = false;
      await sl<STTService>().cancel();
      emit(SpeechStop(text: ''));
    });
  }


}

