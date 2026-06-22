import 'package:ai_voice_chat/features/voice_chat/presentation/bloc/speach/speach_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpeechTextCard extends StatelessWidget {
  const SpeechTextCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocBuilder<SpeachBloc, SpeachState>(
          builder: (context, state) {
            String displayedText = '';
            bool isEmpty = true;

            if (state is SpeachListening) {
              displayedText = state.text;
              isEmpty = state.text.isEmpty;
            } else if (state is SpeechStop) {
              displayedText = state.text;
              isEmpty = state.text.isEmpty;
            } else if (state is SpeechError) {
              displayedText = 'Error occurred: ${state.error}';
              isEmpty = false;
            }

            if (isEmpty) return const _EmptyPrompt();

            return Text(
              displayedText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                height: 1.6,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.graphic_eq, color: Colors.white24, size: 48),
            SizedBox(height: 16),
            Text(
              'Tap the microphone below\nand start speaking...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
