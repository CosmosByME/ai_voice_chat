import 'package:ai_voice_chat/features/voice_chat/presentation/view/widgets/settings_voice_list.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/bloc/voice/voice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showVoiceSettingsDialog(BuildContext parentContext) {
  showDialog(
    context: parentContext,
    builder: (_) => BlocProvider.value(
      value: parentContext.read<VoiceBloc>(),
      child: const _VoiceSettingsDialog(),
    ),
  );
}

class _VoiceSettingsDialog extends StatefulWidget {
  const _VoiceSettingsDialog();

  @override
  State<_VoiceSettingsDialog> createState() => _VoiceSettingsDialogState();
}

class _VoiceSettingsDialogState extends State<_VoiceSettingsDialog> {
  @override
  void initState() {
    super.initState();
    context.read<VoiceBloc>().add(GetVoiceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF16122D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SettingsVoiceList(),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done', style: TextStyle(color: Color(0xFF00E5FF))),
            ),
          ],
        ),
      ),
    );
  }
}
