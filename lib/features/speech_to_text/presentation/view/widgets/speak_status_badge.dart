import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/bloc/speach_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpeakStatusBadge extends StatelessWidget {
  const SpeakStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeachBloc, SpeachState>(
      builder: (context, state) {
        String statusText = 'Ready';
        Color badgeColor = Colors.grey.shade800;
        Color textColor = Colors.white70;

        if (state is SpeachListening) {
          statusText = 'Listening...';
          badgeColor = const Color(0xFF00E5FF).withValues(alpha: 0.2);
          textColor = const Color(0xFF00E5FF);
        } else if (state is SpeechStop) {
          statusText = 'Speech Stopped';
          badgeColor = const Color(0xFF6C63FF).withValues(alpha: 0.2);
          textColor = const Color(0xFFB39DDB);
        } else if (state is SpeechError) {
          statusText = 'Error';
          badgeColor = Colors.red.withValues(alpha: 0.2);
          textColor = const Color(0xFFFF8A80);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: textColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: textColor.withValues(alpha: 0.6),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
