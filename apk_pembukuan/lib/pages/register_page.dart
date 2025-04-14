import 'package:apk_pembukuan/components/my_button.dart';
import 'package:apk_pembukuan/components/text_field.dart';
import 'package:flutter/material.dart';

/*

REGISTER PAGE

- nama
- email
- password
- confirm password

______________________________________

Jika user berhasil membuat aku -> maka mereka akan ter-redirect ke halaman home page

Jika user sudah memiliki akun, mereka dapat ke halaman login dari sini

*/

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

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
                  Icons.person,
                  size: 72,
                  color: Colors.blueAccent,
                ),

                const SizedBox(
                  height: 50,
                ),

                // pesan buat akun
                Text(
                  "Let's create an account",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // name textfield
                MyTextField(
                    controller: nameController,
                    hintText: "Enter Name",
                    obscureText: false),

                const SizedBox(
                  height: 10,
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

                // confirm password textfield
                MyTextField(
                    controller: confirmPwController,
                    hintText: "Confirm Password",
                    obscureText: true),

                const SizedBox(
                  height: 25,
                ),

                // sign in button
                MyButton(text: "Register", onTap: () {}),

                const SizedBox(
                  height: 50,
                ),

                // already a member? login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login",
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
