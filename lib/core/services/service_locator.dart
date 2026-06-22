import 'package:ai_voice_chat/core/services/ai_service/ai_service.dart';
import 'package:ai_voice_chat/core/services/tts/audio_sevice.dart';
import 'package:ai_voice_chat/core/services/stt/stt_service.dart';
import 'package:ai_voice_chat/core/services/tts/tts_service_2.dart';
import 'package:ai_voice_chat/features/voice_chat/data/voice_local_data_source.dart';
import 'package:ai_voice_chat/features/voice_chat/domain/voice_repository.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/bloc/voice/voice_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_voice_chat/core/services/system/local_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorage(sharedPreferences: sharedPreferences),
  );

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
      ttsService2: sl(),
      audioService: sl(),
    ),
  );

  sl.registerLazySingleton<AIService>(() => AIService());
}
