import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: const Color(0xFF00E5FF),
                controller: controller,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Type text to speak...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
            _SendButton(onSend: onSend),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onSend;
  const _SendButton({required this.onSend});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TtsModelBloc, TtsModelState>(
      builder: (context, state) {
        final isLoading = state is TtsModelLoading;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundColor: isLoading
                ? Colors.white10
                : const Color(0xFF00E5FF),
            radius: 20,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Color(0xFF0D0A1C),
                      size: 20,
                    ),
                    onPressed: onSend,
                  ),
          ),
        );
      },
    );
  }
}
