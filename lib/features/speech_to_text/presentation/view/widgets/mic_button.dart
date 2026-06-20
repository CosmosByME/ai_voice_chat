import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/speach/speach_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MicButton extends StatelessWidget {
  final AnimationController pulseController;
  const MicButton({super.key, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeachBloc, SpeachState>(
      builder: (context, state) {
        final isListening = state is SpeachListening;
        return Stack(
          alignment: Alignment.center,
          children: [
            if (isListening)
              ...List.generate(3, (i) => _PulseRing(controller: pulseController, index: i)),
            _MicCircle(
              isListening: isListening,
              onTap: () => isListening
                  ? context.read<SpeachBloc>().add(StopListening(text: state.text))
                  : context.read<SpeachBloc>().add(StartListening()),
            ),
          ],
        );
      },
    );
  }
}

class _PulseRing extends StatelessWidget {
  final AnimationController controller;
  final int index;
  const _PulseRing({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        final p = (controller.value + index / 3) % 1.0;
        return Container(
          width: 80 + p * 100, height: 80 + p * 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6C63FF).withValues(alpha: (1 - p) * 0.4),
          ),
        );
      },
    );
  }
}

class _MicCircle extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;
  const _MicCircle({required this.isListening, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84, height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isListening
                ? [const Color(0xFF00E5FF), const Color(0xFF00B0FF)]
                : [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)],
          ),
          boxShadow: [BoxShadow(
            color: (isListening ? const Color(0xFF00E5FF) : const Color(0xFF8E2DE2))
                .withValues(alpha: 0.5),
            blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 4),
          )],
        ),
        child: Icon(isListening ? Icons.square : Icons.mic, color: Colors.white, size: 36),
      ),
    );
  }
}

class MicLabel extends StatelessWidget {
  const MicLabel({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeachBloc, SpeachState>(
      builder: (context, state) {
        final isListening = state is SpeachListening;
        return Text(
          isListening ? 'Tap to Stop' : 'Tap to Speak',
          style: TextStyle(
            color: isListening ? const Color(0xFF00E5FF) : Colors.white54,
            fontSize: 14, fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
