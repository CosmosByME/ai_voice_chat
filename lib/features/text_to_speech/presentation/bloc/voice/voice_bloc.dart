import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/core/services/tts/tts_service1.dart';
import 'package:ai_voice_chat/core/services/tts/tts_service_2.dart';
import 'package:ai_voice_chat/features/text_to_speech/domain/voice_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final VoiceRepository voiceRepository;
  VoiceBloc({required this.voiceRepository}) : super(VoiceInitial()) {
    on<SetVoiceKokoroEvent>(_onSetVoiceKokoro);
    on<SetVoiceGoogleEvent>(_onSetVoiceGoogle);
    on<GetVoiceKokoroEvent>(_onGetVoiceKokoro);
    on<GetVoiceGoogleEvent>(_onGetVoiceGoogle);
  }

  Future<void> _onSetVoiceKokoro(
    SetVoiceKokoroEvent event,
    Emitter<VoiceState> emit,
  ) async {
    emit(VoiceLoading());
    try {
      await voiceRepository.setVoiceKokoro(event.text);
      await sl<TtsService1>().changeVoice(event.text);
      add(GetVoiceKokoroEvent());
    } catch (e) {
      emit(VoiceError(message: e.toString()));
    }
  }

  Future<void> _onGetVoiceKokoro(
    GetVoiceKokoroEvent event,
    Emitter<VoiceState> emit,
  ) async {
    emit(VoiceLoading());
    try {
      final text = voiceRepository.getVoiceKokoro();
      emit(VoiceLoaded(text: text));
    } catch (e) {
      emit(VoiceError(message: e.toString()));
    }
  }

  Future<void> _onSetVoiceGoogle(
    SetVoiceGoogleEvent event,
    Emitter<VoiceState> emit,
  ) async {
    emit(VoiceLoading());
    try {
      await voiceRepository.setVoiceGoogle(event.text);
      await sl<TTSService2>().changeVoice(event.text);
      add(GetVoiceGoogleEvent());
    } catch (e) {
      emit(VoiceError(message: e.toString()));
    }
  }

  Future<void> _onGetVoiceGoogle(
    GetVoiceGoogleEvent event,
    Emitter<VoiceState> emit,
  ) async {
    emit(VoiceLoading());
    try {
      final text = voiceRepository.getVoiceGoogle();
      emit(VoiceLoaded(text: text));
    } catch (e) {
      emit(VoiceError(message: e.toString()));
    }
  }
}
