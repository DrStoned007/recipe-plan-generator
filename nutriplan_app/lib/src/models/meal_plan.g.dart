// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealPlan _$MealPlanFromJson(Map<String, dynamic> json) => MealPlan(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  recipeId: json['recipe_id'] as String?,
  date: DateTime.parse(json['date'] as String),
  mealType: $enumDecode(_$MealTypeEnumMap, json['meal_type']),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  recipe: json['recipe'] == null
      ? null
      : Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MealPlanToJson(MealPlan instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'recipe_id': instance.recipeId,
  'date': instance.date.toIso8601String(),
  'meal_type': _$MealTypeEnumMap[instance.mealType]!,
  'notes': instance.notes,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'recipe': instance.recipe,
};

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
};

DailyMealPlan _$DailyMealPlanFromJson(Map<String, dynamic> json) =>
    DailyMealPlan(
      date: DateTime.parse(json['date'] as String),
      breakfast: json['breakfast'] == null
          ? null
          : MealPlan.fromJson(json['breakfast'] as Map<String, dynamic>),
      lunch: json['lunch'] == null
          ? null
          : MealPlan.fromJson(json['lunch'] as Map<String, dynamic>),
      dinner: json['dinner'] == null
          ? null
          : MealPlan.fromJson(json['dinner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DailyMealPlanToJson(DailyMealPlan instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
    };
