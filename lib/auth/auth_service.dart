import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  // Sign up
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user?.id;

        final profileResponse = await _supabase.from('profiles').insert([
          {'id': userId, 'first_name': firstName, 'last_name': lastName},
        ]);
      }

      return response;
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get user email
  String? getUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<List<Map<String, dynamic>>?> getUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id);

      if (response.isEmpty == true) {
        print("Error fetching...");
        return null;
      }

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<void> insertSchedTask(
    taskTitle,
    taskDescription,
    taskCategory,
    taskScheduleDay,
    taskScheduleTime,
    taskPriorityLevel,
    taskReminderMinutesBefore,
  ) async {
    try {
      await _supabase.from('task').insert([
        {
          'user_id': _supabase.auth.currentUser!.id,
          'task_title': taskTitle,
          'task_description': taskDescription,
          'task_category': taskCategory,
          'task_deadline': null,
          'task_schedule_day': taskScheduleDay,
          'task_schedule_time': taskScheduleTime,
          'task_priority_level': taskPriorityLevel,
          'task_status': "inp",
          'reminder_minutes_before': taskReminderMinutesBefore,
        },
      ]);
    } catch (e) {
      throw Exception('Error inserting: $e');
    }
  }

  Future<void> insertDeadTask(
    taskTitle,
    taskDescription,
    taskCategory,
    taskDeadline,
    taskPriorityLevel,
    taskReminderMinutesBefore,
  ) async {
    try {
      await _supabase.from('task').insert([
        {
          'user_id': _supabase.auth.currentUser!.id,
          'task_title': taskTitle,
          'task_description': taskDescription,
          'task_category': taskCategory,
          'task_deadline': taskDeadline,
          'task_schedule_day': null,
          'task_schedule_time': null,
          'task_priority_level': taskPriorityLevel,
          'task_status': "inp",
          'reminder_minutes_before': taskReminderMinutesBefore,
        },
      ]);
    } catch (e) {
      throw Exception('Error inserting: $e');
    }
  }
}
