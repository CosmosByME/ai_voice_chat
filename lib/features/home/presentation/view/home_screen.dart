import 'package:ai_voice_chat/features/home/presentation/view/widgets/home_nav_bar.dart';
import 'package:ai_voice_chat/features/voice_chat/presentation/view/speak_screen.dart';
import 'package:ai_voice_chat/features/text_chat/presentation/view/chat_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    SpeakScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: HomeNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
