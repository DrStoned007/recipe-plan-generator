// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
      .toList(),
  instructions: (json['instructions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  dietType:
      $enumDecodeNullable(_$DietTypeEnumMap, json['diet_type']) ??
      DietType.none,
  nutrition: json['nutrition'] == null
      ? null
      : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
  imageUrl: json['image_url'] as String?,
  prepTime: (json['prep_time'] as num?)?.toInt(),
  cookTime: (json['cook_time'] as num?)?.toInt(),
  servings: (json['servings'] as num?)?.toInt() ?? 1,
  createdBy: json['created_by'] as String?,
  isPublic: json['is_public'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'ingredients': instance.ingredients,
  'instructions': instance.instructions,
  'diet_type': _$DietTypeEnumMap[instance.dietType]!,
  'nutrition': instance.nutrition,
  'image_url': instance.imageUrl,
  'prep_time': instance.prepTime,
  'cook_time': instance.cookTime,
  'servings': instance.servings,
  'created_by': instance.createdBy,
  'is_public': instance.isPublic,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$DietTypeEnumMap = {
  DietType.diabetic: 'diabetic',
  DietType.renal: 'renal',
  DietType.heartHealthy: 'heartHealthy',
  DietType.lowFodmap: 'lowFodmap',
  DietType.none: 'none',
};

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
  name: json['name'] as String,
  quantity: json['quantity'] as String,
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
    };

Nutrition _$NutritionFromJson(Map<String, dynamic> json) => Nutrition(
  calories: (json['calories'] as num?)?.toDouble(),
  protein: (json['protein'] as num?)?.toDouble(),
  carbs: (json['carbs'] as num?)?.toDouble(),
  fat: (json['fat'] as num?)?.toDouble(),
  fiber: (json['fiber'] as num?)?.toDouble(),
  sodium: (json['sodium'] as num?)?.toDouble(),
);

Map<String, dynamic> _$NutritionToJson(Nutrition instance) => <String, dynamic>{
  'calories': instance.calories,
  'protein': instance.protein,
  'carbs': instance.carbs,
  'fat': instance.fat,
  'fiber': instance.fiber,
  'sodium': instance.sodium,
};
