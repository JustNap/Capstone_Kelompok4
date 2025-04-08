import 'package:flutter/material.dart';

/*

TEXT FIELD

Tempat dimana user bisa mengetik didalamnya

_____________________________________________________________

Untuk menggunakan widget ini, diperlukan:

- text controller (untuk mengakes apa yang user tulis)
- hint text (contoh: "Masukkan Password")
- obscure text (contoh: true -> hides pw *******)

*/

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  // Build UI
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          // border saat tidak di klik
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey.shade100,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade900,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400)),
    );
  }
}
