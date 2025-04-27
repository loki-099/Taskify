import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/components/button.dart';
import 'package:taskify/routes/app_routes.dart';
import 'package:taskify/utils/colors.dart';
import 'package:taskify/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // get auth service
  final authService = AuthService();

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // login button pressed
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailPassword(email, password);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(
            context,
          ).unfocus(); // Dismiss the keyboard when tapping outside
        },
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.color1, AppColors.color4],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 24,
                      right: 24,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 165,
                          fit: BoxFit.fitHeight,
                        ),
                        Text(
                          "TASKIFY",
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0),
                        Text(
                          "Manage and organize your tasks efficiently.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 450,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login to your account",
                          style: TextStyle(
                            color: AppColors.colorText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: AppColors.colorText),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.colorText,
                              ), // Bottom border color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.color1,
                                width: 2,
                              ), // Bottom border when focused
                            ),
                            suffixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.colorText,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: AppColors.colorText),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.colorText,
                              ), // Bottom border color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.color1,
                                width: 2,
                              ), // Bottom border when focused
                            ),
                            suffixIcon: Icon(
                              Icons.key,
                              color: AppColors.colorText,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: login,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                        Center(
                          child: CustomButton(
                            text: "Sign In",
                            onPressed: login,
                          ),
                        ),
                        Center(
                          heightFactor: 2,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Color(0xFF000000),
                              ),
                              children: <TextSpan>[
                                TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF06BEE1),
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap =
                                            () => Navigator.pushNamed(
                                              context,
                                              AppRoutes.register,
                                            ),
                                  text: "Register",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
