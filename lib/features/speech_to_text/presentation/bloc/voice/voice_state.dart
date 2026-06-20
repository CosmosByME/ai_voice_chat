part of 'voice_bloc.dart';

@immutable
sealed class VoiceState {}

final class VoiceInitial extends VoiceState {}

final class VoiceLoading extends VoiceState {}

final class VoiceLoaded extends VoiceState {
  final String? text;
  VoiceLoaded({this.text});
}

final class VoiceError extends VoiceState {
  final String message;
  VoiceError({required this.message});
}
