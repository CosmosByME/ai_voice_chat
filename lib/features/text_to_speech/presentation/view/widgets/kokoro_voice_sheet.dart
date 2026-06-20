import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/voice/voice_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/voice_model_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KokoroVoiceSheet extends StatelessWidget {
  final BuildContext blocContext;
  final String currentVoice;

  const KokoroVoiceSheet({
    super.key,
    required this.blocContext,
    required this.currentVoice,
  });

  static const _voices = ['af_heart', 'af_nicole', 'am_eric', 'am_michael'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            )),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Select Voice Model',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            ..._voices.map((code) {
              final isSelected = code == currentVoice;
              final accent = const Color(0xFF00E5FF);
              return InkWell(
                onTap: () {
                  blocContext.read<VoiceBloc>().add(SetVoiceKokoroEvent(text: code));
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: isSelected ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: isSelected ? accent.withValues(alpha: 0.2) : Colors.white12,
                      child: Icon(voiceModelIcon(code),
                          color: isSelected ? accent : Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(voiceModelLabel(code), style: TextStyle(
                            color: isSelected ? accent : Colors.white,
                            fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(voiceModelDesc(code),
                            style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    )),
                    if (isSelected) Icon(Icons.check_circle, color: accent),
                  ]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
