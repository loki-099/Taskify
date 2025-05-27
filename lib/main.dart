import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/cubit/user_cubit.dart';
import 'package:taskify/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/utils/colors.dart';
// import 'pages/welcome_page.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://bbbswdglfdzcupmdnprc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJiYnN3ZGdsZmR6Y3VwbWRucHJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQxODI2ODksImV4cCI6MjA1OTc1ODY4OX0.fP0b17Fe5y57aq-Z__7qMhaUwUtXKEcquZYxwh0hrd4',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) => UserCubit()..updateUserData(),
        ),
        BlocProvider<TaskCubit>(create: (context) => TaskCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.color1,
            primary: AppColors.color1,
            secondary: AppColors.color4,
          ),
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        initialRoute: AppRoutes.welcome,
        routes: AppRoutes.routes,
      ),
    );
  }
}
