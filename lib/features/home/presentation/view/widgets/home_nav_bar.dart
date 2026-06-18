import 'package:flutter/material.dart';

class HomeNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(
            color: cs.onSurface.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: cs.surface,
        selectedItemColor: Colors.white,
        unselectedItemColor: cs.onSurface.withValues(alpha: 0.38),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.mic),
            activeIcon: Icon(Icons.mic, color: Colors.white),

            label: 'Voice Assistant',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble, color: Colors.white),
            label: 'AI Chatbot',
          ),
        ],
      ),
    );
  }
}
