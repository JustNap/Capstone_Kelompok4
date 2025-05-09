import 'package:apk_pembukuan/firebase_options.dart';
import 'package:apk_pembukuan/services/auth/auth_gate.dart';
//import 'stock/stock_page.dart';
//import 'Piutang/piutang.dart';
//import 'homepage/homepage.dart';
// import 'Setting/setting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentTheme,
          home: const AuthGate(), //PiutangPage(), //SettingPage(),
        );
      },
    );
  }
}
