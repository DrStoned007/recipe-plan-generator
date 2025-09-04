import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/services.dart';

// Service Providers
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});

final mealPlanServiceProvider = Provider<MealPlanService>((ref) {
  return MealPlanService();
});

// Authentication State Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// User Profile Provider
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  
  final authService = ref.watch(authServiceProvider);
  return authService.getUserProfile(user.id);
});

// Authentication Loading State
final authLoadingProvider = StateProvider<bool>((ref) => false);

// Authentication Error State
final authErrorProvider = StateProvider<String?>((ref) => null);