import 'package:flutter/material.dart';
import 'package:mindful/resource_screen.dart';
import 'package:mindful/splash_screen.dart';
import 'package:mindful/login_page.dart';
import 'package:mindful/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat_screen.dart';
import 'face_detection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 👇 Start the app from SplashScreen
      initialRoute: '/splash',

      // 👇 All your screens go here
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/chat': (context) => const MindfulAIScreen(),
        '/emotion': (context) => const EmotionDetectionScreen(),
        '/resources': (context) => const ResourcesScreen(),
      },
    );
  }
}
