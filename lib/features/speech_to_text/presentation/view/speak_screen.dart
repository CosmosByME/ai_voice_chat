import 'package:ai_voice_chat/core/services/ai_service/ai_service.dart';
import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/speach/speach_bloc.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/view/widgets/voice_control_bar.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/voice/voice_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/chat_message_bubble.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/view/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpeakScreen extends StatelessWidget {
  const SpeakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SpeachBloc()),
        BlocProvider(
          create: (_) => sl<VoiceBloc>()..add(GetVoiceGoogleEvent()),
        ),
        BlocProvider(
          create: (_) => sl<TtsModelBloc>()..add(TtsModelInitialize()),
        ),
      ],
      child: const SpeakScreenView(),
    );
  }
}

class SpeakScreenView extends StatefulWidget {
  const SpeakScreenView({super.key});

  @override
  State<SpeakScreenView> createState() => _SpeakScreenViewState();
}

class _SpeakScreenViewState extends State<SpeakScreenView> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isFastMode = true;

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text:
            'Hello! I am your AI Voice Assistant. Press the mic button to speak to me and I will respond.',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    context.read<TtsModelBloc>().add(TtsModelStop());
    context.read<SpeachBloc>().add(Dispose());
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

  Future<void> _onSpeechSubmitted(String text) async {
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _messages.add(
        ChatMessage(
          text: 'Thinking...',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();

    final response = await sl<AIService>().sendMessage(text);
    if (response.isNotEmpty && mounted) {
      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
        );
      });
      context.read<TtsModelBloc>().add(
        TtsModelSay(text: response, isFast: _isFastMode),
      );
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpeachBloc, SpeachState>(
      listenWhen: (prev, curr) =>
          prev is SpeachListening && curr is SpeechStop && curr.text.isNotEmpty,
      listener: (context, state) {
        if (state is SpeechStop && state.text.isNotEmpty) {
          _onSpeechSubmitted(state.text);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0A1C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0A1C),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'AI Voice Chat',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
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
            VoiceControlBar(
              onStop: () {
                context.read<TtsModelBloc>().add(TtsModelStop());
                context.read<SpeachBloc>().add(Dispose());
              },
            ),
          ],
        ),
      ),
    );
  }
}
