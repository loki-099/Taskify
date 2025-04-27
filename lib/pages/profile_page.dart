import 'package:flutter/material.dart';
import 'package:taskify/auth/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentEmail = AuthService().getUserEmail();
    return Scaffold(
      body: Text(currentEmail.toString()),
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          IconButton(
            onPressed: AuthService().signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
