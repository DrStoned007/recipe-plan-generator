import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/supabase_config.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

class MealPlanService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Get meal plans for a specific date range
  Future<List<MealPlan>> getMealPlans({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase
          .from('meal_plans')
          .select('''
            *,
            recipe:recipes(
              id, title, description, image_url, prep_time, cook_time, servings, diet_type
            )
          ''')
          .eq('user_id', userId)
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', endDate.toIso8601String().split('T')[0])
          .order('date', ascending: true)
          .order('meal_type', ascending: true);

      return (response as List).map((json) {
        // Handle the nested recipe object
        final mealPlanJson = Map<String, dynamic>.from(json);
        if (json['recipe'] != null) {
          mealPlanJson['recipe'] = json['recipe'];
        }
        return MealPlan.fromJson(mealPlanJson);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get meal plans for a specific date
  Future<DailyMealPlan> getDailyMealPlan({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('meal_plans')
          .select('''
            *,
            recipe:recipes(
              id, title, description, image_url, prep_time, cook_time, servings, diet_type
            )
          ''')
          .eq('user_id', userId)
          .eq('date', dateString);

      final mealPlans = (response as List).map((json) {
        final mealPlanJson = Map<String, dynamic>.from(json);
        if (json['recipe'] != null) {
          mealPlanJson['recipe'] = json['recipe'];
        }
        return MealPlan.fromJson(mealPlanJson);
      }).toList();

      MealPlan? breakfast, lunch, dinner;
      
      for (final meal in mealPlans) {
        switch (meal.mealType) {
          case MealType.breakfast:
            breakfast = meal;
            break;
          case MealType.lunch:
            lunch = meal;
            break;
          case MealType.dinner:
            dinner = meal;
            break;
        }
      }

      return DailyMealPlan(
        date: date,
        breakfast: breakfast,
        lunch: lunch,
        dinner: dinner,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Add a meal to the plan
  Future<MealPlan> addMealToPlan({
    required String userId,
    required String recipeId,
    required DateTime date,
    required MealType mealType,
    String? notes,
  }) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];
      
      final mealPlanData = {
        'user_id': userId,
        'recipe_id': recipeId,
        'date': dateString,
        'meal_type': mealType.name,
        'notes': notes,
      };

      final response = await _supabase
          .from('meal_plans')
          .insert(mealPlanData)
          .select('''
            *,
            recipe:recipes(
              id, title, description, image_url, prep_time, cook_time, servings, diet_type
            )
          ''')
          .single();

      final mealPlanJson = Map<String, dynamic>.from(response);
      if (response['recipe'] != null) {
        mealPlanJson['recipe'] = response['recipe'];
      }
      
      return MealPlan.fromJson(mealPlanJson);
    } catch (e) {
      rethrow;
    }
  }

  // Update a meal plan
  Future<MealPlan> updateMealPlan({
    required String id,
    String? recipeId,
    DateTime? date,
    MealType? mealType,
    String? notes,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (recipeId != null) updateData['recipe_id'] = recipeId;
      if (date != null) updateData['date'] = date.toIso8601String().split('T')[0];
      if (mealType != null) updateData['meal_type'] = mealType.name;
      if (notes != null) updateData['notes'] = notes;

      if (updateData.isEmpty) {
        throw Exception('No fields to update');
      }

      final response = await _supabase
          .from('meal_plans')
          .update(updateData)
          .eq('id', id)
          .select('''
            *,
            recipe:recipes(
              id, title, description, image_url, prep_time, cook_time, servings, diet_type
            )
          ''')
          .single();

      final mealPlanJson = Map<String, dynamic>.from(response);
      if (response['recipe'] != null) {
        mealPlanJson['recipe'] = response['recipe'];
      }
      
      return MealPlan.fromJson(mealPlanJson);
    } catch (e) {
      rethrow;
    }
  }

  // Remove a meal from the plan
  Future<void> removeMealFromPlan(String id) async {
    try {
      await _supabase.from('meal_plans').delete().eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  // Get weekly meal plan (7 days)
  Future<List<DailyMealPlan>> getWeeklyMealPlan({
    required String userId,
    required DateTime startDate,
  }) async {
    try {
      final endDate = startDate.add(const Duration(days: 6));
      final mealPlans = await getMealPlans(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );

      final dailyPlans = <DailyMealPlan>[];
      
      for (int i = 0; i < 7; i++) {
        final date = startDate.add(Duration(days: i));
        final dayMeals = mealPlans.where((meal) => 
          meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day
        ).toList();

        MealPlan? breakfast, lunch, dinner;
        
        for (final meal in dayMeals) {
          switch (meal.mealType) {
            case MealType.breakfast:
              breakfast = meal;
              break;
            case MealType.lunch:
              lunch = meal;
              break;
            case MealType.dinner:
              dinner = meal;
              break;
          }
        }

        dailyPlans.add(DailyMealPlan(
          date: date,
          breakfast: breakfast,
          lunch: lunch,
          dinner: dinner,
        ));
      }

      return dailyPlans;
    } catch (e) {
      rethrow;
    }
  }

  // Get monthly meal plan overview
  Future<List<DailyMealPlan>> getMonthlyMealPlan({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);
      
      final mealPlans = await getMealPlans(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );

      final dailyPlans = <DailyMealPlan>[];
      final daysInMonth = endDate.day;
      
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(year, month, day);
        final dayMeals = mealPlans.where((meal) => 
          meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day
        ).toList();

        MealPlan? breakfast, lunch, dinner;
        
        for (final meal in dayMeals) {
          switch (meal.mealType) {
            case MealType.breakfast:
              breakfast = meal;
              break;
            case MealType.lunch:
              lunch = meal;
              break;
            case MealType.dinner:
              dinner = meal;
              break;
          }
        }

        dailyPlans.add(DailyMealPlan(
          date: date,
          breakfast: breakfast,
          lunch: lunch,
          dinner: dinner,
        ));
      }

      return dailyPlans;
    } catch (e) {
      rethrow;
    }
  }

  // Clear all meals for a specific date
  Future<void> clearDayMeals({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];
      
      await _supabase
          .from('meal_plans')
          .delete()
          .eq('user_id', userId)
          .eq('date', dateString);
    } catch (e) {
      rethrow;
    }
  }
}