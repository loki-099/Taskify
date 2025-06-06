import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/cubit/user_cubit.dart';
import 'package:taskify/pages/calendar_page.dart';
import 'package:taskify/pages/home_page.dart';
import 'package:taskify/pages/profile_page.dart';
import 'package:taskify/pages/tasks_page.dart';
import 'package:taskify/routes/app_routes.dart';
import 'package:taskify/utils/colors.dart';
import 'package:taskify/utils/notification_service.dart';

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

  void updateAllData() async {
    await context.read<UserCubit>().updateUserData();
    await context.read<TaskCubit>().updateTaskDatas();
    NotificationService.cancelAllNotifications();
  }

  @override
  void initState() {
    updateAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex]['page'],
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
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.newtaskScreen,
            );
            if (result == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task created successfully!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
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
              icon: SvgPicture.asset(
                _pages[0]['icon'],
                semanticsLabel: "Home",
                color:
                    _selectedIndex == 0
                        ? AppColors.color1
                        : const Color(0xFF1A6DB0),
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: SvgPicture.asset(
                _pages[1]['icon'],
                semanticsLabel: "Calendar",
                color:
                    _selectedIndex == 1
                        ? AppColors.color1
                        : const Color(0xFF1A6DB0),
              ),
            ),
            const SizedBox(width: 48), // Space for the FAB
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: SvgPicture.asset(
                _pages[2]['icon'],
                semanticsLabel: "Tasks",
                color:
                    _selectedIndex == 2
                        ? AppColors.color1
                        : const Color(0xFF1A6DB0),
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: SvgPicture.asset(
                _pages[3]['icon'],
                semanticsLabel: "Profile",
                color:
                    _selectedIndex == 3
                        ? AppColors.color1
                        : const Color(0xFF1A6DB0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
