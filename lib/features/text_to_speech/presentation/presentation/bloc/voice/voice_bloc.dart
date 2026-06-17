import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/core/services/tts_service.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/domain/voice_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final VoiceRepository voiceRepository;
  VoiceBloc({required this.voiceRepository}) : super(VoiceInitial()) {
    on<SetVoiceEvent>(_onSetVoice);
    on<GetVoiceEvent>(_onGetVoice);
  }

  Future<void> _onSetVoice(SetVoiceEvent event, Emitter<VoiceState> emit) async {
    emit(VoiceLoading());
    try {
      await voiceRepository.setVoice(event.text);
      await sl<TtsService>().changeVoice(event.text);
      add(GetVoiceEvent());
    } catch (e) {
      emit(VoiceError(message: e.toString()));
    }
  }

  Future<void> _onGetVoice(GetVoiceEvent event, Emitter<VoiceState> emit) async {
    emit(VoiceLoading());
    try {
      final text = voiceRepository.getVoice();
      emit(VoiceLoaded(text: text));
    } catch (e) {
      emit(VoiceError(message: e.toString()));
    }
  }
}
