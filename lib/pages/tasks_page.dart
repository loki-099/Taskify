import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/components/notif_button.dart';
import 'package:taskify/components/task/prio_task_card.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/cubit/task_state.dart';
import 'package:taskify/pages/home_page.dart';
import 'package:taskify/utils/colors.dart';
import 'package:collection/collection.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  static List<String> tasksClass = ["allTasks", "high", "medium", "low"];
  String selectedTasksClass = "allTasks";

  void setSelectedTasksClass(String tasksClass) {
    setState(() {
      selectedTasksClass = tasksClass;
    });
  }

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
        actionsPadding: EdgeInsets.only(right: 8),
        actions: [NotificationButton()],
      ),
      body: Column(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                spacing: 8,
                children: [
                  TasksClassButton(
                    textButton: "All Tasks",
                    isSelected: selectedTasksClass == tasksClass[0],
                    onTap: () => setSelectedTasksClass("allTasks"),
                  ),
                  TasksClassButton(
                    textButton: "High",
                    isSelected: selectedTasksClass == tasksClass[1],
                    onTap: () => setSelectedTasksClass("high"),
                  ),
                  TasksClassButton(
                    textButton: "Medium",
                    isSelected: selectedTasksClass == tasksClass[2],
                    onTap: () => setSelectedTasksClass("medium"),
                  ),
                  TasksClassButton(
                    textButton: "Low",
                    isSelected: selectedTasksClass == tasksClass[3],
                    onTap: () => setSelectedTasksClass("low"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  final prioTaskCards =
                      state.taskDatas.mapIndexed((index, task) {
                        return PrioTaskCard(
                          task['task_title'],
                          "Today",
                          "7:00 AM",
                          task['task_priority_level'],
                          task['task_status'],
                        );
                      }).toList();
                  return Column(spacing: 8, children: prioTaskCards);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
