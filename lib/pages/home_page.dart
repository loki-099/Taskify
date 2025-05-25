import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/components/custom_appbar.dart';
import 'package:taskify/components/task/task_card.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/cubit/task_state.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTasksClass = "inProgress";
  static List<String> tasksClass = ["inProgress", "completed", "missed"];

  void setSelectedTasksClass(String tasksClass) {
    setState(() {
      selectedTasksClass = tasksClass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          CustomAppbar(),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                spacing: 8,
                children: [
                  TasksClassButton(
                    textButton: "In-progress",
                    isSelected: selectedTasksClass == tasksClass[0],
                    onTap: () => setSelectedTasksClass("inProgress"),
                  ),
                  TasksClassButton(
                    textButton: "Completed",
                    isSelected: selectedTasksClass == tasksClass[1],
                    onTap: () => setSelectedTasksClass("completed"),
                  ),
                  TasksClassButton(
                    textButton: "Missed",
                    isSelected: selectedTasksClass == tasksClass[2],
                    onTap: () => setSelectedTasksClass("missed"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(4),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4),
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  final taskCards =
                      state.taskDatas.mapIndexed((index, task) {
                        return TaskCard(index, task['task_title']);
                      }).toList();
                  return Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: taskCards,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TasksClassButton extends StatefulWidget {
  final String textButton;
  final bool isSelected;
  final VoidCallback onTap;

  const TasksClassButton({
    super.key,
    required this.textButton,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<TasksClassButton> createState() => _TasksClassButtonState();
}

class _TasksClassButtonState extends State<TasksClassButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            widget.isSelected ? Color(0xfff9f9f9) : Color(0xffE0EFF8),
        padding: EdgeInsets.all(12),
      ),
      child: Text(
        widget.textButton,
        style: TextStyle(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: widget.isSelected ? Color(0xff06BEE1) : Color(0xff1C2D51),
        ),
      ),
    );
  }
}
