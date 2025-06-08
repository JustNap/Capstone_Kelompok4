import 'package:apk_pembukuan/components/my_button.dart';
import 'package:apk_pembukuan/components/my_loading_circle.dart';
import 'package:apk_pembukuan/components/text_field.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  final _db = DatabaseService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  void register() async {
    if (pwController.text == confirmPwController.text) {
      showLoadingCircle(context);
      try {
        await _auth.registerEmailPassword(
            emailController.text, pwController.text);
        if (mounted) hideLoadingCircle(context);
        await _db.saveUserInfoInFirebase(
          name: nameController.text,
          email: emailController.text,
        );
      } catch (e) {
        if (mounted) hideLoadingCircle(context);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceAll("Exception:", "").trim(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        const SizedBox(height: 40),
                        const Icon(Icons.person_add_alt_1,
                            size: 72, color: Colors.greenAccent),
                        const SizedBox(height: 20),
                        const Text(
                          "Create your account",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Join and manage your finances better.",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 30),

                        // Name
                        MyTextField(
                          controller: nameController,
                          hintText: "Full Name",
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),

                        // Email
                        MyTextField(
                          controller: emailController,
                          hintText: "Email",
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),

                        // Password
                        MyTextField(
                          controller: pwController,
                          hintText: "Password",
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),

                        // Confirm Password
                        MyTextField(
                          controller: confirmPwController,
                          hintText: "Confirm Password",
                          obscureText: true,
                        ),
                        const SizedBox(height: 25),

                        // Register Button
                        MyButton(
                          text: "Register",
                          onTap: register,
                          color: Colors.greenAccent.withOpacity(0.1),
                        ),
                        const SizedBox(height: 30),

                        // Already a member
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already a member?",
                                style: TextStyle(color: Colors.blueGrey)),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
