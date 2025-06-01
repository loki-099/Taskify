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

  Future<void> createUserProfile(
    String email,
    String firstName,
    String lastName,
  ) async {
    print("Creating User Profile...");
    final user = _supabase.auth.currentUser;
    if (user != null) {
      print("User not null..");
      print("User: $user");
      final response = await _supabase.from('profiles').insert({
        'id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        // add other fields as needed
      });
      print("Profile Created: $response");
    }
  }

  // Sign up
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    print("Signing up to database...");
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      // if (response.user != null) {
      //   final userId = response.user?.id;

      //   final profileResponse = await _supabase.from('profiles').insert([
      //     {'id': userId, 'first_name': firstName, 'last_name': lastName},
      //   ]);
      // }
      print("Success signing up: $response");
      return response;
    } catch (e) {
      throw Exception('Error signing up to database: $e');
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
    print("Getting user data...");
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id);

      print("User Get Date response: $response");

      if (response.isEmpty == true) {
        print("User data is empty...");
        return null;
      }

      return response;
    } catch (e) {
      print("Error getting user data...");
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

  Future<void> updateDeadTask(
    taskId,
    taskTitle,
    taskDescription,
    taskCategory,
    taskDeadline,
    taskPriorityLevel,
    taskReminderMinutesBefore,
  ) async {
    try {
      await _supabase
          .from('task')
          .update({
            'task_title': taskTitle,
            'task_description': taskDescription,
            'task_category': taskCategory,
            'task_deadline': taskDeadline,
            'task_schedule_day': null,
            'task_schedule_time': null,
            'task_priority_level': taskPriorityLevel,
            'task_status': "inp",
            'reminder_minutes_before': taskReminderMinutesBefore,
          })
          .eq('id', taskId);
    } catch (e) {
      throw Exception('Error updating: $e');
    }
  }
}
