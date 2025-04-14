import 'package:apk_pembukuan/firebase_options.dart';
import 'package:apk_pembukuan/pages/home_page.dart';
import 'package:apk_pembukuan/services/auth/auth_gate.dart';
import 'package:apk_pembukuan/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Keuangan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}
