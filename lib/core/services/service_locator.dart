import 'package:ai_voice_chat/core/services/audio_sevice.dart';
import 'package:ai_voice_chat/core/services/tts_service.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/data/voice_local_data_source.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/domain/voice_repository.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/presentation/bloc/voice/voice_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_voice_chat/core/services/local_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorage(sharedPreferences: sharedPreferences),
  );

  sl.registerLazySingleton<TtsService>(
    () => TtsService(),
  );

  sl.registerLazySingleton<AudioService>(
    () => AudioService(),
  );

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
  sl.registerLazySingleton<VoiceBloc>(
    () => VoiceBloc(voiceRepository: sl()),
  );

  sl.registerLazySingleton<TtsModelBloc>(
    () => TtsModelBloc(ttsService: sl(), audioService: sl()),
  );
}
