part of 'voice_bloc.dart';

@immutable
sealed class VoiceEvent {}

class SetVoiceEvent extends VoiceEvent {
  final String text;
  SetVoiceEvent({required this.text});
}

class GetVoiceEvent extends VoiceEvent {}