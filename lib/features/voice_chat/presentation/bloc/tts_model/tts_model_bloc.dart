import 'package:ai_voice_chat/core/services/tts/audio_sevice.dart';
import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/core/services/tts/tts_service_2.dart';
import 'package:ai_voice_chat/features/voice_chat/domain/voice_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tts_model_event.dart';
part 'tts_model_state.dart';

class TtsModelBloc extends Bloc<TtsModelEvent, TtsModelState> {
  final TTSService2 ttsService2;
  final AudioService audioService;
  TtsModelBloc({
    required this.audioService,
    required this.ttsService2,
  }) : super(TtsModelInitial()) {
    on<TtsModelInitialize>(_onTtsModelInitialize);
    on<TtsModelSay>(_onTtsModelSay);
    on<TtsModelStop>(_onTtsModelStop);
  }

  Future<void> _onTtsModelInitialize(
    TtsModelInitialize event,
    Emitter<TtsModelState> emit,
  ) async {
    emit(TtsModelLoading());
    try {
      final voice = sl<VoiceRepository>().getVoice();
      await ttsService2.initialize(voiceType: voice);
      emit(TtsModelLoaded());
    } catch (e) {
      emit(TtsModelError(message: e.toString()));
    }
  }

  Future<void> _onTtsModelSay(
    TtsModelSay event,
    Emitter<TtsModelState> emit,
  ) async {
    emit(TtsModelLoading());
    try {
      emit(TtsModelPlaying());
      await ttsService2.speak(event.text);
      emit(TtsModelLoaded());
    } catch (e) {
      emit(TtsModelError(message: e.toString()));
    }
  }

  Future<void> _onTtsModelStop(
    TtsModelStop event,
    Emitter<TtsModelState> emit,
  ) async {
    ttsService2.dispose();
    audioService.dispose();
  }
}
