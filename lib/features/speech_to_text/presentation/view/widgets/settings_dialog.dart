import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/core/services/system/is_64_bit.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/view/widgets/settings_voice_list.dart';
import 'package:ai_voice_chat/features/speech_to_text/domain/voice_repository.dart';
import 'package:ai_voice_chat/features/speech_to_text/presentation/bloc/voice/voice_bloc.dart';
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
  bool _isFastMode = true;
  bool _show64bitOption = false;

  @override
  void initState() {
    super.initState();
    _isFastMode = sl<VoiceRepository>().getFastMode();
    _check64bit();
    if (_isFastMode) {
      context.read<VoiceBloc>().add(GetVoiceGoogleEvent());
    } else {
      context.read<VoiceBloc>().add(GetVoiceKokoroEvent());
    }
  }

  Future<void> _check64bit() async {
    final is64 = await is64bit();
    if (mounted) setState(() => _show64bitOption = is64);
  }

  void _onModeChanged(bool val) async {
    setState(() => _isFastMode = val);
    await sl<VoiceRepository>().setFastMode(val);
    if (val) {
      context.read<VoiceBloc>().add(GetVoiceGoogleEvent());
    } else {
      context.read<VoiceBloc>().add(GetVoiceKokoroEvent());
    }
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
            if (_show64bitOption) ...[
              _ModeSegmentedButton(isFastMode: _isFastMode, onChanged: _onModeChanged),
              const SizedBox(height: 20),
            ],
            SettingsVoiceList(isFastMode: _isFastMode),
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

class _ModeSegmentedButton extends StatelessWidget {
  final bool isFastMode;
  final ValueChanged<bool> onChanged;

  const _ModeSegmentedButton({required this.isFastMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment<bool>(value: true, label: Text('Fast'), icon: Icon(Icons.bolt)),
        ButtonSegment<bool>(value: false, label: Text('Quality'), icon: Icon(Icons.auto_awesome)),
      ],
      selected: {isFastMode},
      onSelectionChanged: (s) => onChanged(s.first),
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
        selectedForegroundColor: const Color(0xFF00E5FF),
        foregroundColor: Colors.white54,
      ),
    );
  }
}
