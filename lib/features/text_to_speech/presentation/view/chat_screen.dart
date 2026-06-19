import 'package:ai_voice_chat/core/services/ai_service/ai_service.dart';
import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/bloc/voice/voice_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/chat_app_bar.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/chat_input_bar.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/chat_message_bubble.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'widgets/chat_message_bubble.dart' show ChatMessage;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VoiceBloc>()..add(GetVoiceGoogleEvent()),
      child: BlocProvider(
        create: (_) => sl<TtsModelBloc>()..add(TtsModelInitialize()),
        child: const ChatScreenView(),
      ),
    );
  }
}

class ChatScreenView extends StatefulWidget {
  const ChatScreenView({super.key});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isFastMode = true;

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
    context.read<TtsModelBloc>().add(TtsModelStop());
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
    setState(() {
      _messages.add(
        ChatMessage(
          text: 'Thinking...',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    final response = await sl<AIService>().sendMessage(text);
    if (response.isNotEmpty) {
      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
        );
      });
      if (mounted) {
        context.read<TtsModelBloc>().add(
          TtsModelSay(text: response, isFast: _isFastMode),
        );
      }
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A1C),
      appBar: ChatAppBar(
        isFastMode: _isFastMode,
        onModeChanged: (val) {
          setState(() => _isFastMode = val);
          if (val) {
            context.read<VoiceBloc>().add(GetVoiceGoogleEvent());
          } else {
            context.read<VoiceBloc>().add(GetVoiceKokoroEvent());
          }
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: _messages,
              scrollController: _scrollController,
            ),
          ),
          const ChatErrorBar(),
          ChatInputBar(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
