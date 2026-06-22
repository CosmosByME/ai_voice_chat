part of 'speach_bloc.dart';

@immutable
sealed class SpeachEvent {}

final class StartListening extends SpeachEvent {}

final class StopListening extends SpeachEvent {
  final String text;
  StopListening({required this.text});
}

final class Dispose extends SpeachEvent {}

final class SpeechResultUpdated extends SpeachEvent {
  final String text;
  SpeechResultUpdated({required this.text});
}

final class SpeechStatusChanged extends SpeachEvent {
  final String status;
  SpeechStatusChanged({required this.status});
}

final class SpeechErrorOccurred extends SpeachEvent {
  final String error;
  SpeechErrorOccurred({required this.error});
}

