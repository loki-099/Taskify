import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/utils/colors.dart';

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
                      ? "${widget.schedDays} | ${widget.schedTime}"
                      : "${widget.dues[0]} | ${widget.dues[1]}",
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
                    onPressed: () {},
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
