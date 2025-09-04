import 'package:json_annotation/json_annotation.dart';
import '../constants/app_constants.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final String id;
  final String title;
  final String? description;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  @JsonKey(name: 'diet_type')
  final DietType dietType;
  final Nutrition? nutrition;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'prep_time')
  final int? prepTime; // in minutes
  @JsonKey(name: 'cook_time')
  final int? cookTime; // in minutes
  final int servings;
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Recipe({
    required this.id,
    required this.title,
    this.description,
    required this.ingredients,
    required this.instructions,
    this.dietType = DietType.none,
    this.nutrition,
    this.imageUrl,
    this.prepTime,
    this.cookTime,
    this.servings = 1,
    this.createdBy,
    this.isPublic = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    DietType? dietType,
    Nutrition? nutrition,
    String? imageUrl,
    int? prepTime,
    int? cookTime,
    int? servings,
    String? createdBy,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      dietType: dietType ?? this.dietType,
      nutrition: nutrition ?? this.nutrition,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      createdBy: createdBy ?? this.createdBy,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get totalTime => (prepTime ?? 0) + (cookTime ?? 0);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class Ingredient {
  final String name;
  final String quantity;
  final String? unit;

  const Ingredient({
    required this.name,
    required this.quantity,
    this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
  
  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  @override
  String toString() => unit != null ? '$quantity $unit $name' : '$quantity $name';
}

@JsonSerializable()
class Nutrition {
  final double? calories;
  final double? protein; // in grams
  final double? carbs; // in grams  
  final double? fat; // in grams
  final double? fiber; // in grams
  final double? sodium; // in mg

  const Nutrition({
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.sodium,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) => _$NutritionFromJson(json);
  
  Map<String, dynamic> toJson() => _$NutritionToJson(this);
}