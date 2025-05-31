import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/utils/colors.dart';
import 'package:taskify/widgets/edit_task.dart';

class TaskDialog extends StatefulWidget {
  final int taskId;
  final String? schedDays;
  final String schedTime;
  final List dues;

  const TaskDialog(
    this.taskId,
    this.schedDays,
    this.schedTime,
    this.dues, {
    super.key,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> deleteTask(int taskId) async {
    try {
      await _supabase.from('task').delete().eq('id', taskId);
      context.read<TaskCubit>().updateTaskDatas();
    } catch (e) {
      throw Exception("Error updating task status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = context.read<TaskCubit>().state.taskDatas.firstWhere(
      (task) => task['id'] == widget.taskId,
      orElse: () => <String, dynamic>{},
    );

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.color2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['task_category'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.dues.isEmpty
                      ? "${widget.schedDays == "Sun,Mon,Tue,Wed,Thu,Fri,Sat" ? "Everyday" : widget.schedDays} | ${widget.schedTime}"
                      : "${widget.dues[0]} | ${widget.dues[1]}",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              task['task_title'],
              style: TextStyle(
                color: AppColors.colorText,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text("Description:"),
            Text(task['task_description']),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 8,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditTask(
                                taskId: widget.taskId,
                                initialTitle: task['task_title'] ?? '',
                                initialDescription:
                                    task['task_description'] ?? '',
                                initialCategory:
                                    task['task_category'] ?? 'School',
                                initialtSchedFDead:
                                    task['task_deadline'] == null
                                        ? true
                                        : false,
                                initialSchedTime:
                                    task['task_schedule_time'] != null
                                        ? TimeOfDay(
                                          hour: int.parse(
                                            task['task_schedule_time'].split(
                                              ":",
                                            )[0],
                                          ),
                                          minute: int.parse(
                                            task['task_schedule_time'].split(
                                              ":",
                                            )[1],
                                          ),
                                        )
                                        : null,
                                initialDeadTime:
                                    task['task_deadline'] != null
                                        ? TimeOfDay(
                                          hour:
                                              DateTime.parse(
                                                task['task_deadline'],
                                              ).hour,
                                          minute:
                                              DateTime.parse(
                                                task['task_deadline'],
                                              ).minute,
                                        )
                                        : null,
                                initialDate:
                                    task['task_deadline'] != null
                                        ? DateTime.parse(task['task_deadline'])
                                        : null,
                                initialSchedDays:
                                    task['task_schedule_day'] ?? "",
                                initialTaskPrio: task['task_priority_level'],
                                initialSelectedDays: List<bool>.filled(
                                  7,
                                  false,
                                ),
                                initialReminderMinutesBefore:
                                    task['reminder_minutes_before'] ?? 0,
                                onUpdate: () {},
                              ),
                        ),
                      );
                      if (result == true) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task updated successfully!'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.color1,
                      side: BorderSide(color: AppColors.color1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text("Edit"),
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await deleteTask(widget.taskId);
                      Navigator.pop(context, true);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
