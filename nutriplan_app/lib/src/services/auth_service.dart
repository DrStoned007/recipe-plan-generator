import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/supabase_config.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;
  
  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;
  
  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      
      // Create user profile if sign up was successful
      if (response.user != null) {
        await _createUserProfile(
          userId: response.user!.id,
          name: fullName,
          email: email,
        );
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // Sign in with Google
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      // Sign in to Supabase with Google tokens
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Create user profile if this is a new user
      if (response.user != null) {
        await _createUserProfile(
          userId: response.user!.id,
          name: googleUser.displayName ?? 'User',
          email: googleUser.email,
        );
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _supabase.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _supabase
          .from('users')
          .update(updates)
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('No user logged in');

      // Delete user profile (cascade will handle related data)
      await _supabase.from('users').delete().eq('id', userId);
      
      // Sign out
      await signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Private helper to create user profile
  Future<void> _createUserProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      // Check if profile already exists
      final existingProfile = await getUserProfile(userId);
      if (existingProfile != null) return;

      // Create new profile
      await _supabase.from('users').insert({
        'id': userId,
        'name': name,
        'diet_type': 'none',
        'allergies': [],
        'preferences': {},
      });
    } catch (e) {
      // Log error but don't rethrow to avoid breaking auth flow
      debugPrint('Failed to create user profile: $e');
    }
  }
}