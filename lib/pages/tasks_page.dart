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
  static List<String> tasksClass = ["allTasks", "level3", "level2", "level1"];
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
                    onTap: () => setSelectedTasksClass("level3"),
                  ),
                  TasksClassButton(
                    textButton: "Medium",
                    isSelected: selectedTasksClass == tasksClass[2],
                    onTap: () => setSelectedTasksClass("level2"),
                  ),
                  TasksClassButton(
                    textButton: "Low",
                    isSelected: selectedTasksClass == tasksClass[3],
                    onTap: () => setSelectedTasksClass("level1"),
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
                  final filteredTasks =
                      (selectedTasksClass == "allTasks"
                              ? state.taskDatas
                              : state.taskDatas.where(
                                (task) =>
                                    task['task_priority_level'] ==
                                    selectedTasksClass,
                              ))
                          .toList();

                  filteredTasks.sort((a, b) {
                    final aIsCom = a['task_status'] == 'com' ? 1 : 0;
                    final bIsCom = b['task_status'] == 'com' ? 1 : 0;
                    return aIsCom.compareTo(bIsCom);
                  });

                  final prioTaskCards =
                      filteredTasks
                          .mapIndexed((index, task) {
                            if (task['task_deadline'] == null) {
                              return PrioTaskCard.scheduled(
                                task['id'],
                                task['task_title'],
                                task['task_schedule_day'],
                                task['task_schedule_time'],
                                task['task_priority_level'],
                                task['task_status'] == 'com',
                              );
                            } else if (task['task_schedule_time'] == null) {
                              return PrioTaskCard.deadline(
                                task['id'],
                                task['task_title'],
                                task['task_deadline'],
                                task['task_priority_level'],
                                task['task_status'] == 'com',
                              );
                            }
                            return null;
                          })
                          .whereType<Widget>()
                          .toList();
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
