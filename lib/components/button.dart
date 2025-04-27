import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF03256C), // End color
              Color(0xFF06BEE1), // Start color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        // Add constraints to prevent stretching
        constraints: BoxConstraints(
          minWidth: 0, // Minimum width
          maxWidth: 300, // Maximum width
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
