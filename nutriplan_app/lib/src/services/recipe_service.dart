import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/supabase_config.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

class RecipeService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Get all public recipes
  Future<List<Recipe>> getPublicRecipes({
    int? limit,
    int? offset,
    DietType? dietType,
    String? searchQuery,
  }) async {
    try {
      final response = await _supabase
          .from('recipes')
          .select()
          .eq('is_public', true)
          .order('created_at', ascending: false);
          
      return (response as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get user's recipes
  Future<List<Recipe>> getUserRecipes({
    required String userId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from('recipes')
          .select()
          .eq('created_by', userId)
          .order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return (response as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get recipe by ID
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final response = await _supabase
          .from('recipes')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return Recipe.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Create a new recipe
  Future<Recipe> createRecipe({
    required String title,
    String? description,
    required List<Ingredient> ingredients,
    required List<String> instructions,
    DietType dietType = DietType.none,
    Nutrition? nutrition,
    String? imageUrl,
    int? prepTime,
    int? cookTime,
    int servings = 1,
    bool isPublic = false,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User must be authenticated to create recipes');
      }

      final recipeData = {
        'title': title,
        'description': description,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'instructions': instructions,
        'diet_type': dietType.name,
        'nutrition': nutrition?.toJson(),
        'image_url': imageUrl,
        'prep_time': prepTime,
        'cook_time': cookTime,
        'servings': servings,
        'created_by': userId,
        'is_public': isPublic,
      };

      final response = await _supabase
          .from('recipes')
          .insert(recipeData)
          .select()
          .single();

      return Recipe.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update a recipe
  Future<Recipe> updateRecipe({
    required String id,
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
    bool? isPublic,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (ingredients != null) {
        updateData['ingredients'] = ingredients.map((i) => i.toJson()).toList();
      }
      if (instructions != null) updateData['instructions'] = instructions;
      if (dietType != null) updateData['diet_type'] = dietType.name;
      if (nutrition != null) updateData['nutrition'] = nutrition.toJson();
      if (imageUrl != null) updateData['image_url'] = imageUrl;
      if (prepTime != null) updateData['prep_time'] = prepTime;
      if (cookTime != null) updateData['cook_time'] = cookTime;
      if (servings != null) updateData['servings'] = servings;
      if (isPublic != null) updateData['is_public'] = isPublic;

      if (updateData.isEmpty) {
        throw Exception('No fields to update');
      }

      final response = await _supabase
          .from('recipes')
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      return Recipe.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Delete a recipe
  Future<void> deleteRecipe(String id) async {
    try {
      await _supabase.from('recipes').delete().eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  // Search recipes
  Future<List<Recipe>> searchRecipes({
    required String query,
    DietType? dietType,
    List<String>? excludeAllergies,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _supabase
          .from('recipes')
          .select()
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get recipes by diet type
  Future<List<Recipe>> getRecipesByDietType({
    required DietType dietType,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from('recipes')
          .select()
          .eq('is_public', true)
          .eq('diet_type', dietType.name)
          .order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return (response as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}