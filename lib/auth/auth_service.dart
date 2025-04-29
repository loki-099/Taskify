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

  Map<String, dynamic>? getUserData() {
    final session = _supabase.auth.currentSession;
    final User? user = session?.user;
    final Map<String, dynamic>? metadata = user?.userMetadata;
    return metadata;
  }

  // String? getFirstName() {
  //   final metadata = getUserData();
  //   return metadata?['first_name'];
  // }

  Future<String?> getFirstName() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null; // User not logged in

    try {
      final response =
          await _supabase
              .from('profiles') // Query the profiles table
              .select('first_name') // Select the first_name column
              .eq('id', user.id) // Match the id with the user's UUID
              .single(); // Expect a single result

      if (response.isEmpty == true) {
        print("Error fetching first_name...");
        return null;
      }

      return response['first_name'];
    } catch (e) {
      print("Exception fetching first_name: $e");
      return null;
    }
  }
}
