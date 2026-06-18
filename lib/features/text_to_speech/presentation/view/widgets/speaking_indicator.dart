import 'package:ai_voice_chat/features/text_to_speech/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpeakingIndicator extends StatelessWidget {
  const SpeakingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TtsModelBloc, TtsModelState>(
      builder: (context, state) {
        if (state is! TtsModelPlaying) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.volume_up, color: Color(0xFF00E5FF), size: 14),
              SizedBox(width: 4),
              Text('Speaking',
                  style: TextStyle(
                      color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }
}
