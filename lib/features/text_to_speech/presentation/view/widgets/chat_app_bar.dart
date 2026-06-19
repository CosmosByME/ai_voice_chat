import 'package:ai_voice_chat/features/text_to_speech/presentation/bloc/voice/voice_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/mode_toggle_chip.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/speaking_indicator.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/voice_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isFastMode;
  final ValueChanged<bool> onModeChanged;

  const ChatAppBar({super.key, required this.isFastMode, required this.onModeChanged});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D0A1C),
      elevation: 0,
      titleSpacing: 16,
      title: _VoiceSelector(isFastMode: isFastMode),
      actions: [
        ModeToggleChip(isFastMode: isFastMode, onChanged: onModeChanged),
        const SizedBox(width: 8),
        const SpeakingIndicator(),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _VoiceSelector extends StatelessWidget {
  final bool isFastMode;
  const _VoiceSelector({required this.isFastMode});

  String _kokoroLabel(String code) {
    switch (code) {
      case 'af_heart':   return 'Heart';
      case 'af_nicole':  return 'Nicole';
      case 'am_eric':    return 'Eric';
      case 'am_michael': return 'Michael';
      default:           return 'Heart';
    }
  }

  String _googleLabel(String code) {
    switch (code) {
      case 'en-us-x-tpc-local': return 'Female';
      case 'en-us-x-tpd-local': return 'Male';
      default:                  return 'Female';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceBloc, VoiceState>(
      builder: (context, state) {
        final defaultVoice = isFastMode ? 'en-us-x-tpc-local' : 'af_heart';
        final selectedVoice = state is VoiceLoaded ? (state.text ?? defaultVoice) : defaultVoice;
        return InkWell(
          onTap: () => isFastMode
              ? showGoogleVoicePicker(context, selectedVoice)
              : showKokoroVoicePicker(context, selectedVoice),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isFastMode ? Icons.language : Icons.auto_awesome,
                    color: const Color(0xFF00E5FF), size: 16),
                const SizedBox(width: 8),
                Text(isFastMode ? _googleLabel(selectedVoice) : _kokoroLabel(selectedVoice),
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
