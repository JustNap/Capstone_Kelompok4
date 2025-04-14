import 'package:apk_pembukuan/components/my_button.dart';
import 'package:apk_pembukuan/components/my_loading_circle.dart';
import 'package:apk_pembukuan/components/text_field.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
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
  // access auth service
  final _auth = AuthService();

  // text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register button tapped
  void register() async {
    // password match -> create user
    if (pwController.text == confirmPwController.text) {
      // show loading circle
      showLoadingCircle(context);
      // attempt to register new user
      try {
        //trying to register
        await _auth.registerEmailPassword(
            emailController.text, pwController.text);

        // finished loading
        if (mounted) hideLoadingCircle(context);
      }

      // catch any errors
      catch (e) {
        // finshed loading
        if (mounted) hideLoadingCircle(context);

        // let user know of the error
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    }

    // password don't match -> show error
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
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

                // Register button
                MyButton(text: "Register", onTap: register),

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
