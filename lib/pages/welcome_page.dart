import 'package:flutter/material.dart';
import 'package:taskify/components/button.dart';
import 'package:taskify/routes/app_routes.dart';
import 'package:taskify/widgets/welcome_banner.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      body: Center(
        child: Stack(
          children: [
            Image.asset('assets/images/banner_pic.png'),
            Padding(
              padding: const EdgeInsets.only(top: 350.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WelcomeBanner(),
                  SizedBox(height: 50),
                  CustomButton(
                    text: "Let's Start",
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
