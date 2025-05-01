import 'package:flutter/material.dart';
//import 'stock/stock_page.dart';
//import 'Piutang/piutang.dart';
import 'homepage/homepage.dart';
// import 'Setting/setting.dart';
void main() {
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
          home: Homepage() //PiutangPage(), //SettingPage(), 
        );
      },
    );
  }
}