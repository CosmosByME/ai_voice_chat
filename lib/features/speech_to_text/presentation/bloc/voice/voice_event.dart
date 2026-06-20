part of 'voice_bloc.dart';

@immutable
sealed class VoiceEvent {}

class SetVoiceKokoroEvent extends VoiceEvent {
  final String text;
  SetVoiceKokoroEvent({required this.text});
}

class SetVoiceGoogleEvent extends VoiceEvent {
  final String text;
  SetVoiceGoogleEvent({required this.text});
}

class GetVoiceKokoroEvent extends VoiceEvent {}

class GetVoiceGoogleEvent extends VoiceEvent {}