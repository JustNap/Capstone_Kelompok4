import 'package:apk_pembukuan/components/my_button.dart';
import 'package:apk_pembukuan/components/text_field.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  final _auth = AuthService();
  bool _emailSent = false;

  void sendResetLink() async {
    try {
      await _auth.resetPassword(emailController.text);
      setState(() => _emailSent = true);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reset Password",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: _emailSent
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mark_email_read_rounded,
                        color: Colors.green, size: 64),
                    const SizedBox(height: 20),
                    Text(
                      "Reset link sent! Please check your email.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_reset_rounded,
                        color: Colors.greenAccent, size: 64),
                    const SizedBox(height: 20),
                    Text(
                      "Enter your email to reset password",
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false),
                    const SizedBox(height: 20),
                    MyButton(text: "Send Reset Link", onTap: sendResetLink),
                  ],
                ),
        ),
      ),
    );
  }
}
