import 'package:flutter/material.dart';
import 'Piutang/piutang.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piutang App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: PiutangPage(),
    );
  }
}