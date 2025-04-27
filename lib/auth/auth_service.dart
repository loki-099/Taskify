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
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
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
}
