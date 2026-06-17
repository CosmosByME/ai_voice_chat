// lib/main.dart
import 'package:ai_voice_chat/features/text_to_speech/presentation/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:ai_voice_chat/core/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChatScreen());
  }
}
