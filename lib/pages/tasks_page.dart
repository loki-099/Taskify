import 'package:flutter/material.dart';
import 'package:taskify/components/notif_button.dart';
import 'package:taskify/utils/colors.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "My Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.colorText,
          ),
        ),
        actions: [NotificationButton()],
      ),
    );
  }
}
