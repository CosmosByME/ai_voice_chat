import 'package:ai_voice_chat/features/text_chat/presentation/view/widgets/chat_message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatMessageBubble(
          message: messages[index],
          showVoiceLabel: index > 0,
        );
      },
    );
  }
}

class ChatErrorBar extends StatelessWidget {
  final String message;
  const ChatErrorBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.red.withValues(alpha: 0.15),
      width: double.infinity,
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFFFF8A80), fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}
