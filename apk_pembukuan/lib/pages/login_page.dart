import 'package:apk_pembukuan/components/my_button.dart';
import 'package:apk_pembukuan/components/text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      backgroundColor: Colors.white,

      // Body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),

                // Logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 72,
                  color: Colors.blueAccent,
                ),

                const SizedBox(
                  height: 50,
                ),

                // Welcome
                Text(
                  "Welcome back Bos!",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // email textfield
                MyTextField(
                    controller: emailController,
                    hintText: "Enter Email",
                    obscureText: false),

                const SizedBox(
                  height: 10,
                ),

                // password textfield
                MyTextField(
                    controller: pwController,
                    hintText: "Enter Password",
                    obscureText: true),

                const SizedBox(
                  height: 10,
                ),

                // forgot password?
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot password?",
                      style: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontWeight: FontWeight.bold)),
                ),

                const SizedBox(
                  height: 25,
                ),

                // sign in button
                MyButton(text: "Login", onTap: () {}),

                const SizedBox(
                  height: 50,
                ),

                // register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Register now",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
