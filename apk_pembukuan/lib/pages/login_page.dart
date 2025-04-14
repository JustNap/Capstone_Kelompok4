import 'package:apk_pembukuan/components/my_button.dart';
import 'package:apk_pembukuan/components/my_loading_circle.dart';
import 'package:apk_pembukuan/components/text_field.dart';
import 'package:apk_pembukuan/pages/home_page.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // access auth service
  final _auth = AuthService();

  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // login method
  void login() async {
    // show loading circle
    showLoadingCircle(context);

    try {
      // trying to login
      await _auth.loginEmailPassword(
        emailController.text,
        pwController.text,
      );

      // finished loading
      if (mounted) {
        hideLoadingCircle(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const Homepage(
                      userName: "Nama",
                    )));
      }
      ;
    } catch (e) {
      // Error handling
      if (mounted) {
        hideLoadingCircle(context);
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")),
        );
      }
    }
  }

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
                MyButton(
                  text: "Login",
                  onTap: login,
                ),

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
                      onTap: widget.onTap,
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
