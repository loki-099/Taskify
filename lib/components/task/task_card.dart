import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:taskify/widgets/task_dialog.dart';

class TaskCard extends StatefulWidget {
  final int taskId;
  final String taskTitle;
  final String taskCategory;
  final String? taskDueDate;
  final String? taskDueDays;
  final String? taskDueTime;
  final String taskPrio;
  final bool taskStatus;
  final VoidCallback? onStatusChanged;

  // Main constructor (private)
  const TaskCard._(
    this.taskId,
    this.taskTitle,
    this.taskCategory,
    this.taskDueDate,
    this.taskDueDays,
    this.taskDueTime,
    this.taskPrio,
    this.taskStatus, {
    super.key,
    this.onStatusChanged,
  });

  // Named constructor for scheduled tasks (exclude taskDueDate)
  factory TaskCard.scheduled(
    int taskId,
    String taskTitle,
    String taskCategory,
    String taskDueDays,
    String taskDueTime,
    String taskPrio,
    bool taskStatus, {
    Key? key,
    VoidCallback? onStatusChanged,
  }) {
    return TaskCard._(
      taskId,
      taskTitle,
      taskCategory,
      null, // taskDueDate is excluded
      taskDueDays,
      taskDueTime,
      taskPrio,
      taskStatus,
      key: key,
      onStatusChanged: onStatusChanged,
    );
  }

  // Named constructor for deadline tasks (exclude taskDueTime)
  factory TaskCard.deadline(
    int taskId,
    String taskTitle,
    String taskCategory,
    String taskDueDate,
    String taskPrio,
    bool taskStatus, {
    Key? key,
    VoidCallback? onStatusChanged,
  }) {
    return TaskCard._(
      taskId,
      taskTitle,
      taskCategory,
      taskDueDate,
      null,
      null, // taskDueTime is excluded
      taskPrio,
      taskStatus,
      key: key,
      onStatusChanged: onStatusChanged,
    );
  }

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool isVisible = true;

  void updateTaskStatus(String value) async {
    setState(() {
      isVisible = false;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      await _supabase
          .from('task')
          .update({'task_status': value})
          .eq('id', widget.taskId);
      if (mounted) {
        context.read<TaskCubit>().updateTaskDatas();
      }
    } catch (e) {
      throw Exception("Error updating task status: $e");
    }
  }

  Map<String, LinearGradient> gradientClass = {
    "level3": LinearGradient(
      colors: [Color(0xeeBD1919), Color(0xffEF4444)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    "level2": LinearGradient(
      colors: [Color(0xeeF59E0B), Color(0xffF2D200)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    "level1": LinearGradient(
      colors: [Color(0xff00BA4D), Color(0xee10B984)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  };

  List convertDeadline(String? raw) {
    // Parse the string into DateTime
    if (raw != null) {
      DateTime parsed = DateTime.parse(raw);

      // Convert to local time if needed
      DateTime local = parsed.toLocal();

      // Format
      String formattedDate = DateFormat(
        'MMMM d, y',
      ).format(local); // e.g., May 31, 2025
      String formattedTime = DateFormat(
        'h:mm a',
      ).format(local); // e.g., 4:00 PM

      // String result = "Due: $formattedDate | $formattedTime";
      List results = [formattedDate, formattedTime];
      return results;
    } else {
      return List.empty();
    }
  }

  String formatTime(String? input) {
    // Parse as DateTime (assuming today's date)
    DateTime dateTime = DateTime.parse("2024-01-01T${input ?? "00:00:00+08"}");

    // Format to 12-hour time
    String formatted = DateFormat('hh:mm a').format(dateTime.toLocal());

    return formatted;
  }

  Map<String, String> prioTexts = {
    "level3": "!!!",
    "level2": "!!",
    "level1": "!",
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      onEnd: () {
        if (!isVisible && widget.onStatusChanged != null) {
          widget.onStatusChanged!();
        }
      },
      child: GestureDetector(
        onTap: () async {
          final result = await showDialog(
            context: context,
            builder:
                (context) => TaskDialog(
                  widget.taskId,
                  widget.taskDueDays ?? "bruh",
                  formatTime(widget.taskDueTime),
                  convertDeadline(widget.taskDueDate),
                ),
          );
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task deleted successfully!'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Color(0xffCAE7FF),
            // gradient: gradientClass[widget.taskPrio],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: gradientClass[widget.taskPrio],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    prioTexts[widget.taskPrio]!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskTitle,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.taskDueDate != null
                          ? "${widget.taskCategory} | ${convertDeadline(widget.taskDueDate!)[0]} | ${convertDeadline(widget.taskDueDate!)[1]}"
                          : "${widget.taskCategory} | ${widget.taskDueDays} | ${formatTime(widget.taskDueTime!)}",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.colorText,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 2,
                child: Checkbox(
                  activeColor: Colors.transparent,
                  checkColor: AppColors.color2,
                  value: widget.taskStatus,
                  side: BorderSide(color: AppColors.color2),
                  onChanged: (value) {
                    String stringValue = value == false ? "inp" : "com";
                    updateTaskStatus(stringValue);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
