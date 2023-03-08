import 'package:flutter/material.dart';
import 'package:delta/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:delta/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/main': (context) => const MyApp(),
        // other routes go here
      },
      home: const LoginScreen(),
    );
  }
}