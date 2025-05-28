import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/utils/colors.dart';
import 'package:intl/intl.dart';

class PrioTaskCard extends StatefulWidget {
  final int taskId;
  final String taskTitle;
  final String? taskDueDate;
  final String? taskDueDays;
  final String? taskDueTime;
  final String taskPrio;
  final bool taskStatus;

  // Main constructor (private)
  const PrioTaskCard._(
    this.taskId,
    this.taskTitle,
    this.taskDueDate,
    this.taskDueDays,
    this.taskDueTime,
    this.taskPrio,
    this.taskStatus, {
    super.key,
  });

  // Named constructor for scheduled tasks (exclude taskDueDate)
  factory PrioTaskCard.scheduled(
    int taskId,
    String taskTitle,
    String taskDueDays,
    String taskDueTime,
    String taskPrio,
    bool taskStatus, {
    Key? key,
  }) {
    return PrioTaskCard._(
      taskId,
      taskTitle,
      null, // taskDueDate is excluded
      taskDueDays,
      taskDueTime,
      taskPrio,
      taskStatus,
      key: key,
    );
  }

  // Named constructor for deadline tasks (exclude taskDueTime)
  factory PrioTaskCard.deadline(
    int taskId,
    String taskTitle,
    String taskDueDate,
    String taskPrio,
    bool taskStatus, {
    Key? key,
  }) {
    return PrioTaskCard._(
      taskId,
      taskTitle,
      taskDueDate,
      null,
      null, // taskDueTime is excluded
      taskPrio,
      taskStatus,
      key: key,
    );
  }

  @override
  State<PrioTaskCard> createState() => _PrioTaskCardState();
}

class _PrioTaskCardState extends State<PrioTaskCard> {
  // bool taskStatus = widget.taskStatus;

  // Map<String, bool> taskStatuses = {"inp": false, "com": true};
  // // TODO

  // void setTaskStatus() {
  //   taskStatus = taskStatuses[widget.taskStatus]!;
  //   print(taskStatus);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   DateTime dateTime = DateTime.parse("2024-01-01T${widget.taskDueTime}");
  //   setState(() {
  //     widget.taskDueDate = DateFormat('hh:mm a').format(dateTime.toLocal());
  //   });
  //   // widget.taskDueTime = DateFormat('hh:mm a').format(dateTime.toLocal());
  // }

  final SupabaseClient _supabase = Supabase.instance.client;

  void updateTaskStatus(String value) async {
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

  String convertDeadline(String raw) {
    // Parse the string into DateTime
    DateTime parsed = DateTime.parse(raw);

    // Convert to local time if needed
    DateTime local = parsed.toLocal();

    // Format
    String formattedDate = DateFormat(
      'MMMM d, y',
    ).format(local); // e.g., May 31, 2025
    String formattedTime = DateFormat('h:mm a').format(local); // e.g., 4:00 PM

    String result = "Due: $formattedDate | $formattedTime";
    return result;
  }

  String formatTime(String input) {
    // Parse as DateTime (assuming today's date)
    DateTime dateTime = DateTime.parse("2024-01-01T$input");

    // Format to 12-hour time
    String formatted = DateFormat('hh:mm a').format(dateTime.toLocal());

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: gradientClass[widget.taskPrio],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.taskDueDate != null
                      ? convertDeadline(widget.taskDueDate!)
                      : "Days: ${widget.taskDueDays} | ${formatTime(widget.taskDueTime!)}",
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 2,
            child: Checkbox(
              activeColor: Colors.transparent,
              checkColor: Colors.white,
              value: widget.taskStatus,
              side: BorderSide(color: AppColors.white),
              onChanged: (value) {
                setState(() {
                  String stringValue = value == false ? "inp" : "com";
                  updateTaskStatus(stringValue);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
