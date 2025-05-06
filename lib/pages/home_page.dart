import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
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
          SizedBox(height: 10),
          SizedBox(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  Container(width: 200, height: 200, color: Colors.blue),
                  Container(width: 200, height: 200, color: Colors.blue),
                  Container(width: 200, height: 200, color: Colors.blue),
                  Container(width: 200, height: 200, color: Colors.blue),
                ],
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
