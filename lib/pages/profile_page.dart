import 'package:flutter/material.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/components/custom_appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentEmail = AuthService().getUserEmail();
    return Scaffold(
      body: Center(child: Text(currentEmail.toString())),
      appBar: CustomAppbar(),
      extendBody: true, // Ensures the FAB overlaps the BottomAppBar
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[Color(0xFF03256C), Color(0xFF06BEE1)],
            stops: <double>[0, 1],
          ),
        ),
        child: FloatingActionButton(
          onPressed: () => print("Floating Action Button Pressed"),
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 45),
          backgroundColor: Colors.transparent, // Set to transparent
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: kBottomNavigationBarHeight + 10,
        shape: const CircularNotchedRectangle(), // Creates the notch
        notchMargin: 6.0, // Margin around the notch
        color: const Color(0xFFCAE7FF), // Background color of the BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => print("Home Pressed"),
              icon: const Icon(Icons.home_filled),
              color: const Color(0xFF1A6DB0),
            ),
            IconButton(
              onPressed: () => print("Daily Pressed"),
              icon: const Icon(Icons.calendar_month_rounded),
              color: const Color(0xFF1A6DB0),
            ),
            const SizedBox(width: 48), // Space for the FAB
            IconButton(
              onPressed: () => print("Tasks Pressed"),
              icon: const Icon(Icons.insert_drive_file_rounded),
              color: const Color(0xFF1A6DB0),
            ),
            IconButton(
              onPressed: () => print("Account Pressed"),
              icon: const Icon(Icons.supervisor_account_sharp),
              color: const Color(0xFF1A6DB0),
            ),
          ],
        ),
      ),
    );
  }
}
