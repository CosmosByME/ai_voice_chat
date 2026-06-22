import 'package:ai_voice_chat/core/services/ai_service/ai_service.dart';
import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/features/text_chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:ai_voice_chat/features/text_chat/presentation/view/widgets/chat_input_bar.dart';
import 'package:ai_voice_chat/features/text_chat/presentation/view/widgets/chat_message_bubble.dart';
import 'package:ai_voice_chat/features/text_chat/presentation/view/widgets/chat_message_list.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/view/speak_screen.dart';
import 'package:flutter/material.dart';

export 'widgets/chat_message_bubble.dart' show ChatMessage;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text:
            'Hello! I am your AI Voice Assistant. Type any text below and I will speak it back to you. Select a voice model at the top left to customize my voice.',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });
    _controller.clear();
    _scrollToBottom();
    final response = sl<AIService>().sendMessage(text);

    setState(() {
      _messages.add(
        ChatMessage(stream: response, isUser: false, timestamp: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A1C),
      appBar: ChatAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: _messages,
              scrollController: _scrollController,
              onStreamChunk: _scrollToBottom,
            ),
          ),
          // const ChatErrorBar(),
          ChatInputBar(
            controller: _controller,
            onSend: _sendMessage,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => SpeakScreen()));
            },
          ),
        ],
      ),
    );
  }
}
