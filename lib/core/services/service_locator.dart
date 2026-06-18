import 'package:ai_voice_chat/core/services/audio_sevice.dart';
import 'package:ai_voice_chat/core/services/stt_service.dart';
import 'package:ai_voice_chat/core/services/tts_service1.dart';
import 'package:ai_voice_chat/core/services/tts_service_2.dart';
import 'package:ai_voice_chat/features/text_to_speech/data/voice_local_data_source.dart';
import 'package:ai_voice_chat/features/text_to_speech/domain/voice_repository.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/bloc/voice/voice_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_voice_chat/core/services/local_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorage(sharedPreferences: sharedPreferences),
  );

  sl.registerLazySingleton<TtsService1>(() => TtsService1(audioService: sl()));
  sl.registerLazySingleton<TTSService2>(() => TTSService2());

  sl.registerLazySingleton<AudioService>(() => AudioService());

  sl.registerLazySingleton<STTService>(() => STTService());

  //text-to-speech
  //data source
  sl.registerLazySingleton<VoiceLocalDataSource>(
    () => VoiceLocalDataSourceImpl(localStorage: sl()),
  );

  //repository
  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(voiceLocalDataSource: sl()),
  );

  //bloc
  sl.registerLazySingleton<VoiceBloc>(() => VoiceBloc(voiceRepository: sl()));

  sl.registerLazySingleton<TtsModelBloc>(
    () => TtsModelBloc(
      ttsService1: sl(),
      ttsService2: sl(),
      audioService: sl(),
    ),
  );
}
