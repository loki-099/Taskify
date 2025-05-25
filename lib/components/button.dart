import 'package:flutter/material.dart';
import 'package:taskify/utils/colors.dart';

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

class PrefButton extends StatefulWidget {
  const PrefButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.selected,
  });

  final String text;
  final VoidCallback onPressed;
  final bool selected;

  @override
  State<PrefButton> createState() => _PrefButtonState();
}

class _PrefButtonState extends State<PrefButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          gradient:
              widget.selected
                  ? LinearGradient(
                    colors: [
                      Color(0xFF03256C), // End color
                      Color(0xFF06BEE1), // Start color
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )
                  : null,
          border: Border.all(
            color: widget.selected ? Colors.transparent : AppColors.color1,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        // Add constraints to prevent stretching
        constraints: BoxConstraints(
          minWidth: 0, // Minimum width
          maxWidth: 300, // Maximum width
        ),
        child: Center(
          child:
              widget.selected
                  ? Text(
                    widget.text,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: <Color>[Color(0xFF03256C), Color(0xFF06BEE1)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      );
                    },
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.white, // This will be masked by the shader
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
