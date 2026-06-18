// lib/main.dart
import 'package:ai_voice_chat/core/services/stt_service.dart';
import 'package:ai_voice_chat/core/widgets/on_tap_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:ai_voice_chat/core/services/service_locator.dart';
import 'package:ai_voice_chat/features/home/presentation/view/home_screen.dart';
import 'package:ai_voice_chat/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await sl<STTService>().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme,
      home: OnTapUnfocus(child: HomeScreen()),
    );
  }
}
