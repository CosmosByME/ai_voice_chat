part of 'tts_model_bloc.dart';

@immutable
sealed class TtsModelState {}

final class TtsModelInitial extends TtsModelState {}

final class TtsModelLoading extends TtsModelState {}

final class TtsModelLoaded extends TtsModelState {}

final class TtsModelPlaying extends TtsModelState {}

final class TtsModelError extends TtsModelState {
  final String message;
  TtsModelError({required this.message});
}
