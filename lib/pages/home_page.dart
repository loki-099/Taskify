import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/components/custom_appbar.dart';
import 'package:taskify/components/task/task_card.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/cubit/task_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTasksClass = "inp";
  static List<String> tasksClass = ["inp", "com", "mis"];

  List<Map<String, dynamic>> _visibleTasks = [];

  @override
  void initState() {
    super.initState();
    // _visibleTasks will be initialized in BlocBuilder's first build
  }

  void setSelectedTasksClass(String tasksClass) {
    setState(() {
      selectedTasksClass = tasksClass;
      // Reset _visibleTasks when changing tab
      _visibleTasks = [];
    });
  }

  void _removeTask(int index) {
    setState(() {
      _visibleTasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: [
          CustomAppbar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                TasksClassButton(
                  textButton: "In-progress",
                  isSelected: selectedTasksClass == tasksClass[0],
                  onTap: () => setSelectedTasksClass(tasksClass[0]),
                ),
                const SizedBox(width: 8),
                TasksClassButton(
                  textButton: "Completed",
                  isSelected: selectedTasksClass == tasksClass[1],
                  onTap: () => setSelectedTasksClass(tasksClass[1]),
                ),
                const SizedBox(width: 8),
                TasksClassButton(
                  textButton: "Missed",
                  isSelected: selectedTasksClass == tasksClass[2],
                  onTap: () => setSelectedTasksClass(tasksClass[2]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              final filteredTasks =
                  state.taskDatas
                      .where(
                        (task) => task['task_status'] == selectedTasksClass,
                      )
                      .toList();

              // Only update _visibleTasks if it's empty (first build or after tab change)
              if (_visibleTasks.isEmpty ||
                  _visibleTasks.length != filteredTasks.length) {
                _visibleTasks = List<Map<String, dynamic>>.from(filteredTasks);
              }

              return _visibleTasks.isNotEmpty
                  ? Column(
                    children: [
                      for (int i = 0; i < _visibleTasks.length; i++) ...[
                        _buildTaskCard(_visibleTasks[i], i),
                        const SizedBox(height: 8),
                      ],
                    ],
                  )
                  : Text(
                    "No ${selectedTasksClass == 'com' ? 'completed' : 'missed'} tasks",
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    if (task['task_deadline'] == null) {
      return TaskCard.scheduled(
        task['id'],
        task['task_title'],
        task['task_category'],
        task['task_schedule_day'],
        task['task_schedule_time'],
        task['task_priority_level'],
        task['task_status'] == 'com',
        key: ValueKey(task['id']),
        onStatusChanged: () {
          // Remove by index directly, as this matches the current visible list
          if (index >= 0 && index < _visibleTasks.length) {
            setState(() {
              _visibleTasks.removeAt(index);
            });
          }
        },
      );
    } else if (task['task_schedule_time'] == null) {
      return TaskCard.deadline(
        task['id'],
        task['task_title'],
        task['task_category'],
        task['task_deadline'],
        task['task_priority_level'],
        task['task_status'] == 'com',
        key: ValueKey(task['id']),
        onStatusChanged: () {
          if (index >= 0 && index < _visibleTasks.length) {
            setState(() {
              _visibleTasks.removeAt(index);
            });
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class TasksClassButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xfff9f9f9) : const Color(0xffE0EFF8),
        padding: const EdgeInsets.all(12),
      ),
      child: Text(
        textButton,
        style: TextStyle(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? const Color(0xff06BEE1) : const Color(0xff1C2D51),
        ),
      ),
    );
  }
}
