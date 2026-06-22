import 'package:ai_voice_chat/features/voice_chat/presentation/bloc/voice/voice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsVoiceList extends StatelessWidget {
  const SettingsVoiceList({super.key});

  static const _googleVoices = ['en-us-x-tpc-local', 'en-us-x-tpd-local'];
  static const _googleLabels = {
    'en-us-x-tpc-local': 'Female (Local)',
    'en-us-x-tpd-local': 'Male (Local)',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceBloc, VoiceState>(
      builder: (context, state) {
        const defaultVoice = 'en-us-x-tpc-local';
        final selectedVoice = state is VoiceLoaded ? (state.text ?? defaultVoice) : defaultVoice;

        return Column(
          children: _googleVoices.map((code) => _VoiceTile(
            icon: Icons.record_voice_over,
            label: _googleLabels[code]!,
            desc: null,
            isSelected: code == selectedVoice,
            accent: const Color(0xFF00E5FF),
            onTap: () => context.read<VoiceBloc>().add(SetVoiceEvent(text: code)),
          )).toList(),
        );
      },
    );
  }
}

class _VoiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? desc;
  final bool isSelected;
  final Color accent;
  final VoidCallback onTap;

  const _VoiceTile({
    required this.icon,
    required this.label,
    this.desc,
    required this.isSelected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? accent.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? accent : Colors.white54, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: isSelected ? accent : Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  if (desc != null)
                    Text(desc!, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: accent, size: 18),
          ],
        ),
      ),
    );
  }
}
