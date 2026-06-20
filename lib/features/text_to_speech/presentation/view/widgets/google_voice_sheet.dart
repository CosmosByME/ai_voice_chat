import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/voice/voice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleVoiceSheet extends StatelessWidget {
  final BuildContext blocContext;
  final String currentVoice;

  const GoogleVoiceSheet({
    super.key,
    required this.blocContext,
    required this.currentVoice,
  });

  static const _voices = ['en-us-x-tpc-local', 'en-us-x-tpd-local'];
  static const _labels = {
    'en-us-x-tpc-local': 'Female (Local)',
    'en-us-x-tpd-local': 'Male (Local)',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: _SheetHandle()),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Select Google Voice',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            ..._voices.map((code) {
              final isSelected = code == currentVoice;
              final accent = const Color(0xFF00E5FF);
              return InkWell(
                onTap: () {
                  blocContext.read<VoiceBloc>().add(SetVoiceGoogleEvent(text: code));
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: isSelected ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
                  child: Row(children: [
                    Icon(Icons.record_voice_over, color: isSelected ? accent : Colors.white70),
                    const SizedBox(width: 16),
                    Expanded(child: Text(_labels[code]!,
                        style: TextStyle(color: isSelected ? accent : Colors.white))),
                    if (isSelected) Icon(Icons.check_circle, color: accent),
                  ]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();
  @override
  Widget build(BuildContext context) => Container(
        width: 40, height: 4,
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
      );
}
