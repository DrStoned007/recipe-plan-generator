import 'package:json_annotation/json_annotation.dart';
import '../constants/app_constants.dart';
import 'recipe.dart';

part 'meal_plan.g.dart';

@JsonSerializable()
class MealPlan {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'recipe_id')
  final String? recipeId;
  final DateTime date;
  @JsonKey(name: 'meal_type')
  final MealType mealType;
  final String? notes;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  // Optional recipe object when joined
  final Recipe? recipe;

  const MealPlan({
    required this.id,
    required this.userId,
    this.recipeId,
    required this.date,
    required this.mealType,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.recipe,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);
  
  Map<String, dynamic> toJson() => _$MealPlanToJson(this);

  MealPlan copyWith({
    String? id,
    String? userId,
    String? recipeId,
    DateTime? date,
    MealType? mealType,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Recipe? recipe,
  }) {
    return MealPlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recipeId: recipeId ?? this.recipeId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recipe: recipe ?? this.recipe,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Helper class for meal planning operations
@JsonSerializable()
class DailyMealPlan {
  final DateTime date;
  final MealPlan? breakfast;
  final MealPlan? lunch;
  final MealPlan? dinner;

  const DailyMealPlan({
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory DailyMealPlan.fromJson(Map<String, dynamic> json) => _$DailyMealPlanFromJson(json);
  
  Map<String, dynamic> toJson() => _$DailyMealPlanToJson(this);

  List<MealPlan> get meals {
    final List<MealPlan> meals = [];
    if (breakfast != null) meals.add(breakfast!);
    if (lunch != null) meals.add(lunch!);
    if (dinner != null) meals.add(dinner!);
    return meals;
  }

  bool get isEmpty => breakfast == null && lunch == null && dinner == null;
  bool get isComplete => breakfast != null && lunch != null && dinner != null;
}