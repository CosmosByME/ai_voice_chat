part of 'tts_model_bloc.dart';

@immutable
sealed class TtsModelEvent {}

class TtsModelInitialize extends TtsModelEvent {
  final String? voiceType;
  TtsModelInitialize({this.voiceType});
}

class TtsModelSay extends TtsModelEvent {
  final String text;
  final bool isFast;
  TtsModelSay({required this.text, required this.isFast});
}

class TtsModelStop extends TtsModelEvent {}
