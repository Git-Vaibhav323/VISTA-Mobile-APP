import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.instance.client;

  // Sign up with email
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Sign in with email
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Listen to auth changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Check if user is authenticated
  bool get isAuthenticated => _client.auth.currentUser != null;

  // Create or update user profile
  Future<Map<String, dynamic>?> createUserProfile({
    required String fullName,
    required String businessName,
    required String role,
    String? city,
    String? phoneNumber,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No authenticated user');

      final response = await _client
          .from('user_profiles')
          .upsert({
            'id': user.id,
            'email': user.email,
            'full_name': fullName,
            'business_name': businessName,
            'role': role,
            'city': city,
            'phone_number': phoneNumber,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Failed to send reset password email: $e');
    }
  }
}
