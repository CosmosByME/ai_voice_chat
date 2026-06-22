import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onPressed,
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
            _VoiceInputButton(onPressed: onPressed),
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
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundColor: const Color(0xFF00E5FF),
        radius: 20,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_upward,
            color: Color(0xFF0D0A1C),
            size: 20,
          ),
          onPressed: onSend,
        ),
      ),
    );
  }
}

class _VoiceInputButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _VoiceInputButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundColor: const Color(0xFFF58A07),
        radius: 20,
        child: IconButton(
          icon: const Icon(
            Icons.voice_chat,
            color: Color(0xFF0D0A1C),
            size: 20,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
