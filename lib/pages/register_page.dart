import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/components/button.dart';
import 'package:taskify/utils/colors.dart';
import 'package:taskify/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  // Get auth service
  final authService = AuthService();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool isPasswordSame(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Login button pressed
  void login() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (isPasswordSame(password, confirmPassword)) {
      try {
        await authService.signUpWithEmailPassword(
          email,
          password,
          firstName,
          lastName,
        );
        Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(
          context,
        ).unfocus(); // Dismiss the keyboard when tapping outside
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff9f9f9),
        appBar: AppBar(
          backgroundColor: Color(0xfff9f9f9),
          automaticallyImplyLeading: false,
          // title: Text(
          //   "Create an account",
          //   style: TextStyle(
          //     color: AppColors.colorText,
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    color: AppColors.colorText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // First Name
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  labelStyle: TextStyle(color: AppColors.colorText),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorText),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1, width: 2),
                  ),
                  suffixIcon: Icon(Icons.person, color: AppColors.colorText),
                ),
              ),
              const SizedBox(height: 10),
              // Last Name
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  labelStyle: TextStyle(color: AppColors.colorText),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorText),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1, width: 2),
                  ),
                  suffixIcon: Icon(Icons.person, color: AppColors.colorText),
                ),
              ),
              const SizedBox(height: 10),
              // Email TextField
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: AppColors.colorText),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorText),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1, width: 2),
                  ),
                  suffixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.colorText,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: AppColors.colorText),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorText),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1, width: 2),
                  ),
                  suffixIcon: Icon(Icons.key, color: AppColors.colorText),
                ),
              ),
              const SizedBox(height: 10),

              // Confirm Password TextField
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: AppColors.colorText),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorText),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color1, width: 2),
                  ),
                  suffixIcon: Icon(Icons.key, color: AppColors.colorText),
                ),
              ),
              const SizedBox(height: 50),

              // Sign Up Button
              Center(child: CustomButton(text: "Sign Up", onPressed: login)),
              const SizedBox(height: 20),

              // Already Have an Account
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: const Color(0xFF000000),
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF06BEE1),
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () => Navigator.pop(context),
                        text: "Sign In",
                      ),
                    ],
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
