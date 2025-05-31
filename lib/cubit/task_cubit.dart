import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/cubit/task_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskify/utils/notification_service.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState.initialize());
  final SupabaseClient _supabase = Supabase.instance.client;

  void updateTaskDatas() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final response = await _supabase
            .from('task')
            .select()
            .eq('user_id', user.id);

        if (response.isEmpty == true) {
          print("Error fetching...");
          emit(TaskState.initialize());
        } else {
          emit(TaskState(response));
          print("Success updating bloc");

          NotificationService.cancelAllNotifications();
          for (var task in response) {
            await NotificationService.setReminders(task);
          }
        }
      } catch (e) {
        print("Error: $e");
        emit(TaskState.initialize());
      }
    } else {
      emit(TaskState.initialize());
    }
  }
}
