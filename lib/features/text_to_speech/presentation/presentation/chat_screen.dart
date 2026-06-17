import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/presentation/bloc/tts_model/tts_model_bloc.dart';
import 'package:ai_voice_chat/features/text_to_speech/presentation/presentation/bloc/voice/voice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VoiceBloc>()..add(GetVoiceEvent()),
      child: BlocProvider(
        create: (context) => sl<TtsModelBloc>()..add(TtsModelInitialize()),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    context.read<TtsModelBloc>().add(TtsModelStop());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chatbot TTS')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<TtsModelBloc, TtsModelState>(
              builder: (context, state) {
                if (state is TtsModelPlaying) {
                  return Text("Playing...");
                } else if (state is TtsModelError) {
                  return Text(state.message);
                } else if (state is TtsModelLoading) {
                  return Text("Loading...");
                } else {
                  return Text("Ready");
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter text to speak...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<VoiceBloc, VoiceState>(
              builder: (context, state) {
                if (state is VoiceLoaded) {
                  return DropdownMenu(
                    onSelected: (value) {
                      context.read<VoiceBloc>().add(
                        SetVoiceEvent(text: value!),
                      );
                    },
                    initialSelection: state.text ?? 'af_heart',
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 'af_heart', label: 'Heart'),
                      DropdownMenuEntry(value: 'af_nicole', label: 'Nicole'),
                      DropdownMenuEntry(value: 'am_eric', label: 'Eric'),
                      DropdownMenuEntry(value: 'am_michael', label: 'Michael'),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<TtsModelBloc, TtsModelState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<TtsModelBloc>().add(
                      TtsModelSay(text: _controller.text),
                    );
                  },
                  child: state is TtsModelLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: const CircularProgressIndicator(),
                        )
                      : const Text('Speak'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
