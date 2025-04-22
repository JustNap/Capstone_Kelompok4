import 'package:apk_pembukuan/components/my_button.dart';
import 'package:apk_pembukuan/components/my_loading_circle.dart';
import 'package:apk_pembukuan/components/text_field.dart';
import 'package:apk_pembukuan/pages/home_page.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:apk_pembukuan/pages/reset_password_page.dart';
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
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
      ;
    } catch (e) {
      // Error handling
      if (mounted) {
        hideLoadingCircle(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          true, // penting agar body menyesuaikan saat keyboard muncul
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              reverse: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      25,
                      0,
                      25,
                      MediaQuery.of(context).viewInsets.bottom + 25,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_open_rounded,
                            size: 72, color: Colors.blueAccent),
                        const SizedBox(height: 30),
                        Text(
                          "Welcome back Bos!",
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                        const SizedBox(height: 25),
                        MyTextField(
                          controller: emailController,
                          hintText: "Enter Email",
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: pwController,
                          hintText: "Enter Password",
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordPage()),
                              );
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Colors.blueGrey.shade300,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyButton(text: "Login", onTap: login),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Not a member?",
                                style: TextStyle(color: Colors.blueGrey)),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                "Register now",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                ),
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
          },
        ),
      ),
    );
  }
}
