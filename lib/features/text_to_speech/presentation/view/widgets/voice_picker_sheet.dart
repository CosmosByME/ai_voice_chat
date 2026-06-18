import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/google_voice_sheet.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/kokoro_voice_sheet.dart';
import 'package:flutter/material.dart';

const _kSheetBg = Color(0xFF16122D);
const _kSheetRadius = BorderRadius.only(
  topLeft: Radius.circular(28),
  topRight: Radius.circular(28),
);

void showGoogleVoicePicker(BuildContext context, String currentVoice) {
  showModalBottomSheet(
    context: context,
    backgroundColor: _kSheetBg,
    shape: const RoundedRectangleBorder(borderRadius: _kSheetRadius),
    builder: (_) => GoogleVoiceSheet(blocContext: context, currentVoice: currentVoice),
  );
}

void showKokoroVoicePicker(BuildContext context, String currentVoice) {
  showModalBottomSheet(
    context: context,
    backgroundColor: _kSheetBg,
    shape: const RoundedRectangleBorder(borderRadius: _kSheetRadius),
    builder: (_) => KokoroVoiceSheet(blocContext: context, currentVoice: currentVoice),
  );
}
