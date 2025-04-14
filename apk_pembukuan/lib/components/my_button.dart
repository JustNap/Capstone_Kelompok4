import 'package:flutter/material.dart';

/*

Button

*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({super.key, required this.text, required this.onTap});

  // Build UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
