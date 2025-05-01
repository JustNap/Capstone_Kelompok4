/*

AUTH GATE

chek user sudah login atau tidak

*/

import 'package:apk_pembukuan/homepage/homepage.dart';
import 'package:apk_pembukuan/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapShot) {
            // user is logged in
            if (snapShot.hasData) {
              return const Homepage();
            }

            // user is NOT logged in
            else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
