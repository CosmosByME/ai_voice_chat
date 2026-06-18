part of 'speach_bloc.dart';

@immutable
sealed class SpeachState {}

final class SpeachInitial extends SpeachState {}


final class SpeachListening extends SpeachState {
  final String text;
  SpeachListening({required this.text});
}

final class SpeechStop extends SpeachState {
  final String text;
  SpeechStop({required this.text});
}

final class SpeechError extends SpeachState {
  final String error;
  SpeechError({required this.error});
}