import 'package:ai_voice_chat/features/voice_chat/presentation/bloc/speach/speach_bloc.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/view/widgets/gradient_indicator.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/view/widgets/settings_dialog.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceControlBar extends StatelessWidget {
  final VoidCallback onStop;

  const VoiceControlBar({super.key, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeachBloc, SpeachState>(
      builder: (context, sttState) {
        return BlocBuilder<TtsModelBloc, TtsModelState>(
          builder: (context, ttsState) {
            final isUserSpeaking = sttState is SpeachListening;
            final isAiTalking = ttsState is TtsModelPlaying;
            final transcribedText = sttState is SpeachListening
                ? sttState.text
                : '';

            return Container(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24, top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TranscribedText(text: transcribedText),
                  const SizedBox(height: 10),
                  GradientIndicator(isUserSpeaking: isUserSpeaking, isAiTalking: isAiTalking),
                  const SizedBox(height: 12),
                  _ControlRow(onStop: onStop, isUserSpeaking: isUserSpeaking),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TranscribedText extends StatelessWidget {
  final String text;
  const _TranscribedText({required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.75),
          fontSize: 14,
          fontStyle: FontStyle.italic,
          height: 1.4,
        ),
      ),
    );
  }
}

class _ControlRow extends StatelessWidget {
  final VoidCallback onStop;
  final bool isUserSpeaking;

  const _ControlRow({required this.onStop, required this.isUserSpeaking});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _IconBtn(
          icon: Icons.settings_outlined,
          onTap: () => showVoiceSettingsDialog(context),
        ),
        const Spacer(),
        _IconBtn(
          icon: isUserSpeaking ? Icons.mic_off_outlined : Icons.mic_none_outlined,
          onTap: () {
            if (isUserSpeaking) {
              final text = (context.read<SpeachBloc>().state as SpeachListening).text;
              context.read<SpeachBloc>().add(StopListening(text: text));
            } else {
              context.read<SpeachBloc>().add(StartListening());
            }
          },
        ),
        const SizedBox(width: 12),
        _IconBtn(
          icon: Icons.stop_circle_outlined,
          onTap: onStop,
          accent: const Color(0xFFFF5252),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.accent = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.07),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: accent, size: 24),
      ),
    );
  }
}
