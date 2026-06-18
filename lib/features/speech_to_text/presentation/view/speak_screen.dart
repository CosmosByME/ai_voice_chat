import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/bloc/speach_bloc.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/view/widgets/mic_button.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/view/widgets/speak_status_badge.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/view/widgets/speech_text_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpeakScreen extends StatelessWidget {
  const SpeakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpeachBloc(),
      child: const SpeakScreenView(),
    );
  }
}

class SpeakScreenView extends StatefulWidget {
  const SpeakScreenView({super.key});

  @override
  State<SpeakScreenView> createState() => _SpeakScreenViewState();
}

class _SpeakScreenViewState extends State<SpeakScreenView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    context.read<SpeachBloc>().add(Dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'AI Voice Assistant',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0A1C), Color(0xFF191336), Color(0xFF0F0B21)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Center(child: SpeakStatusBadge()),
                const SizedBox(height: 32),
                const Expanded(child: SpeechTextCard()),
                const SizedBox(height: 32),
                Center(child: MicButton(pulseController: _pulseController)),
                const SizedBox(height: 12),
                const Center(child: MicLabel()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
