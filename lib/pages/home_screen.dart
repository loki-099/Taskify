import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/components/custom_appbar.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/cubit/user_cubit.dart';
import 'package:taskify/pages/calendar_page.dart';
import 'package:taskify/pages/home_page.dart';
import 'package:taskify/pages/profile_page.dart';
import 'package:taskify/pages/tasks_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {'page': HomePage(), 'icon': 'assets/icons/home-icon.svg'},
    {'page': CalendarPage(), 'icon': 'assets/icons/calendar-icon.svg'},
    {'page': TasksPage(), 'icon': 'assets/icons/tasks-icon.svg'},
    {'page': ProfilePage(), 'icon': 'assets/icons/profile-icon.svg'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    context.read<UserCubit>().updateUserData();
    context.read<TaskCubit>().updateTaskDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      body: _pages[_selectedIndex]['page'],
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
          backgroundColor: Colors.transparent, // Set to transparent
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 45),
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
              onPressed: () => _onItemTapped(0),
              icon: SvgPicture.asset(_pages[0]['icon'], semanticsLabel: "Home"),
              color: const Color(0xFF1A6DB0),
            ),
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: SvgPicture.asset(
                _pages[1]['icon'],
                semanticsLabel: "Calendar",
              ),
              color: const Color(0xFF1A6DB0),
            ),
            const SizedBox(width: 48), // Space for the FAB
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: SvgPicture.asset(
                _pages[2]['icon'],
                semanticsLabel: "Tasks",
              ),
              color: const Color(0xFF1A6DB0),
            ),
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: SvgPicture.asset(
                _pages[3]['icon'],
                semanticsLabel: "Profile",
              ),
              color: const Color(0xFF1A6DB0),
            ),
          ],
        ),
      ),
    );
  }
}
