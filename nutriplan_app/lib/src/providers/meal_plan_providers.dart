import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import 'auth_providers.dart';

// Meal Plan Loading States
final mealPlanLoadingProvider = StateProvider<bool>((ref) => false);
final mealPlanErrorProvider = StateProvider<String?>((ref) => null);

// Current Date Provider
final currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Selected Date Provider (for meal planning)
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Daily Meal Plan Provider
final dailyMealPlanProvider = FutureProvider.family<DailyMealPlan, DateTime>(
  (ref, date) async {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return DailyMealPlan(date: date);
    }
    
    final mealPlanService = ref.watch(mealPlanServiceProvider);
    return mealPlanService.getDailyMealPlan(
      userId: user.id,
      date: date,
    );
  },
);

// Weekly Meal Plan Provider
final weeklyMealPlanProvider = FutureProvider.family<List<DailyMealPlan>, DateTime>(
  (ref, startDate) async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];
    
    final mealPlanService = ref.watch(mealPlanServiceProvider);
    return mealPlanService.getWeeklyMealPlan(
      userId: user.id,
      startDate: startDate,
    );
  },
);

// Monthly Meal Plan Provider
final monthlyMealPlanProvider = FutureProvider.family<List<DailyMealPlan>, MonthYear>(
  (ref, monthYear) async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];
    
    final mealPlanService = ref.watch(mealPlanServiceProvider);
    return mealPlanService.getMonthlyMealPlan(
      userId: user.id,
      year: monthYear.year,
      month: monthYear.month,
    );
  },
);

// Meal Plan Manager (for CRUD operations)
final mealPlanManagerProvider = StateNotifierProvider<MealPlanManager, MealPlanState>(
  (ref) => MealPlanManager(
    ref.watch(mealPlanServiceProvider),
    ref.watch(currentUserProvider)?.id,
  ),
);

// Current Week Start Date Provider
final currentWeekStartProvider = Provider<DateTime>((ref) {
  final currentDate = ref.watch(currentDateProvider);
  final weekday = currentDate.weekday;
  return currentDate.subtract(Duration(days: weekday - 1));
});

// Current Month Provider
final currentMonthProvider = Provider<MonthYear>((ref) {
  final currentDate = ref.watch(currentDateProvider);
  return MonthYear(year: currentDate.year, month: currentDate.month);
});

// Meal Plan State
class MealPlanState {
  final bool isLoading;
  final String? error;
  final List<MealPlan> recentMeals;

  const MealPlanState({
    this.isLoading = false,
    this.error,
    this.recentMeals = const [],
  });

  MealPlanState copyWith({
    bool? isLoading,
    String? error,
    List<MealPlan>? recentMeals,
  }) {
    return MealPlanState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      recentMeals: recentMeals ?? this.recentMeals,
    );
  }
}

// Meal Plan Manager
class MealPlanManager extends StateNotifier<MealPlanState> {
  final MealPlanService _mealPlanService;
  final String? _userId;

  MealPlanManager(this._mealPlanService, this._userId) 
      : super(const MealPlanState());

  Future<MealPlan?> addMealToPlan({
    required String recipeId,
    required DateTime date,
    required MealType mealType,
    String? notes,
  }) async {
    final userId = _userId;
    if (userId == null) {
      state = state.copyWith(error: 'User not authenticated');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final mealPlan = await _mealPlanService.addMealToPlan(
        userId: userId,
        recipeId: recipeId,
        date: date,
        mealType: mealType,
        notes: notes,
      );
      
      state = state.copyWith(
        isLoading: false,
        recentMeals: [mealPlan, ...state.recentMeals.take(9)],
      );
      
      return mealPlan;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<MealPlan?> updateMealPlan({
    required String id,
    String? recipeId,
    DateTime? date,
    MealType? mealType,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedMealPlan = await _mealPlanService.updateMealPlan(
        id: id,
        recipeId: recipeId,
        date: date,
        mealType: mealType,
        notes: notes,
      );
      
      state = state.copyWith(isLoading: false);
      return updatedMealPlan;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<bool> removeMealFromPlan(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _mealPlanService.removeMealFromPlan(id);
      
      state = state.copyWith(
        isLoading: false,
        recentMeals: state.recentMeals.where((meal) => meal.id != id).toList(),
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> clearDayMeals(DateTime date) async {
    final userId = _userId;
    if (userId == null) {
      state = state.copyWith(error: 'User not authenticated');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _mealPlanService.clearDayMeals(
        userId: userId,
        date: date,
      );
      
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Month-Year Data Class
class MonthYear {
  final int year;
  final int month;

  const MonthYear({required this.year, required this.month});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthYear && other.year == year && other.month == month;
  }

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => 'MonthYear(year: $year, month: $month)';
}