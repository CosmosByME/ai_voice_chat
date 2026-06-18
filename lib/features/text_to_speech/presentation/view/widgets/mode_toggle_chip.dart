import 'package:flutter/material.dart';

class ModeToggleChip extends StatelessWidget {
  final bool isFastMode;
  final ValueChanged<bool> onChanged;

  const ModeToggleChip({super.key, required this.isFastMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final accent = isFastMode ? const Color(0xFF00E5FF) : const Color(0xFF8E2DE2);
    final bg = isFastMode
        ? const Color(0xFF00E5FF).withValues(alpha: 0.15)
        : const Color(0xFF8E2DE2).withValues(alpha: 0.15);
    return GestureDetector(
      onTap: () => onChanged(!isFastMode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isFastMode ? Icons.bolt : Icons.auto_awesome, size: 14, color: accent),
            const SizedBox(width: 4),
            Text(
              isFastMode ? 'Fast' : 'Quality',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accent),
            ),
          ],
        ),
      ),
    );
  }
}
