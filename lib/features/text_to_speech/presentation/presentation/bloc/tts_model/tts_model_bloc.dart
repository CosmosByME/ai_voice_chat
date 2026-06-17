import 'package:ai_voice_chat/core/services/audio_sevice.dart';
import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/core/services/tts_service.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/domain/voice_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tts_model_event.dart';
part 'tts_model_state.dart';

class TtsModelBloc extends Bloc<TtsModelEvent, TtsModelState> {
  TtsService ttsService;
  AudioService audioService;
  TtsModelBloc({required this.ttsService, required this.audioService})
    : super(TtsModelInitial()) {
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
      await ttsService.initialize(voiceType: voice);
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
      final audio = await ttsService.speak(event.text);
      emit(TtsModelPlaying());
      await audioService.playPcm(audio);
      emit(TtsModelLoaded());
    } catch (e) {
      emit(TtsModelError(message: e.toString()));
    }
  }

  Future<void> _onTtsModelStop(
    TtsModelStop event,
    Emitter<TtsModelState> emit,
  ) async {
    ttsService.dispose();
    audioService.dispose();
  }
}
