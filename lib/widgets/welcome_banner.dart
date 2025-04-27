import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'TASKIFY',
          style: TextStyle(
            fontFamily: GoogleFonts.montserrat().fontFamily,
            fontSize: 59,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 32, right: 32),
          child: Text(
            'This productive tool is designed to help you better manage and organize your tasks efficiently.',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
