// import 'package:flutter/material.dart';
import 'package:taskify/auth/auth_gate.dart';
import 'package:taskify/components/task/newtask_screen.dart';
import 'package:taskify/pages/home_page.dart';
import 'package:taskify/pages/notifications_screen.dart';
import 'package:taskify/pages/profile_page.dart';
import 'package:taskify/pages/register_page.dart';
import 'package:taskify/pages/welcome_page.dart';
// import '../pages/welcome_page.dart';
// import '../pages/login_page.dart';

class AppRoutes {
  static const welcome = '/';
  static const login = '/login';
  static const register = '/register';
  static const profilePage = '/profilePage';
  static const homePage = '/homePage';
  static const newtaskScreen = '/newtask';
  static const notificationsScreen = '/notifications';

  static final routes = {
    welcome: (context) => WelcomePage(),
    login: (context) => AuthGate(),
    register: (context) => RegisterPage(),
    profilePage: (context) => ProfilePage(),
    homePage: (context) => HomePage(),
    newtaskScreen: (context) => NewTaskScreen(),
    notificationsScreen: (context) => NotificationsScreen(),
  };
}
