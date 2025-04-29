import 'package:flutter/material.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/components/custom_appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentEmail = AuthService().getUserEmail();
    return Scaffold(
      body: Text(currentEmail.toString()),
      appBar: CustomAppbar(),
    );
  }
}
