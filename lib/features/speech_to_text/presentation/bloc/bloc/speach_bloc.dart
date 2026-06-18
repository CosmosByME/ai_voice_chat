import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/core/services/stt_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'speach_event.dart';
part 'speach_state.dart';

class SpeachBloc extends Bloc<SpeachEvent, SpeachState> {
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
      emit(SpeachListening(text: ''));
      await sl<STTService>().listen((p0) {
        add(SpeechResultUpdated(text: p0));
      });
    });

    on<SpeechResultUpdated>((event, emit) {
      emit(SpeachListening(text: event.text));
    });

    on<SpeechStatusChanged>((event, emit) {
      final currentText = state is SpeachListening
          ? (state as SpeachListening).text
          : (state is SpeechStop ? (state as SpeechStop).text : '');

      if (event.status == 'listening') {
        emit(SpeachListening(text: currentText));
      } else if (event.status == 'notListening' || event.status == 'done') {
        emit(SpeechStop(text: currentText));
      }
    });

    on<SpeechErrorOccurred>((event, emit) {
      emit(SpeechError(error: event.error));
    });

    on<StopListening>((event, emit) async {
      await sl<STTService>().stop();
      emit(SpeechStop(text: event.text));
    });

    on<Dispose>((event, emit) async {
      await sl<STTService>().cancel();
      emit(SpeechStop(text: ''));
    });
  }


}
