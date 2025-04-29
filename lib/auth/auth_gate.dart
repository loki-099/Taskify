// AUTH GATE - will continuously listen for auth state change

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/pages/login_page.dart';
import 'package:taskify/pages/profile_page.dart';
// import 'package:taskify/routes/app_routes.dart';
// import 'package:taskify/pages/welcome_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;
        // final session = null;

        if (session != null) {
          return ProfilePage();
          // Navigator.pushNamed(context, AppRoutes.profilePage);
        } else {
          return LoginPage();
          // Navigator.pushNamed(context, AppRoutes.login);
        }
      },
    );
  }
}
