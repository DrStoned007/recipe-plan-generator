import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import 'auth_providers.dart';

// Recipe Loading States
final recipesLoadingProvider = StateProvider<bool>((ref) => false);
final recipeErrorProvider = StateProvider<String?>((ref) => null);

// Public Recipes Provider
final publicRecipesProvider = FutureProvider.family<List<Recipe>, RecipeFilters>(
  (ref, filters) async {
    final recipeService = ref.watch(recipeServiceProvider);
    return recipeService.getPublicRecipes(
      limit: filters.limit,
      offset: filters.offset,
      dietType: filters.dietType,
      searchQuery: filters.searchQuery,
    );
  },
);

// User Recipes Provider
final userRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final recipeService = ref.watch(recipeServiceProvider);
  return recipeService.getUserRecipes(userId: user.id);
});

// Single Recipe Provider
final recipeByIdProvider = FutureProvider.family<Recipe?, String>(
  (ref, recipeId) async {
    final recipeService = ref.watch(recipeServiceProvider);
    return recipeService.getRecipeById(recipeId);
  },
);

// Recipe Search Provider
final recipeSearchProvider = StateNotifierProvider<RecipeSearchNotifier, RecipeSearchState>(
  (ref) => RecipeSearchNotifier(ref.watch(recipeServiceProvider)),
);

// Recipe Filters State
final recipeFiltersProvider = StateProvider<RecipeFilters>(
  (ref) => const RecipeFilters(),
);

// Favorite Recipes (stored locally)
final favoriteRecipesProvider = StateNotifierProvider<FavoriteRecipesNotifier, List<String>>(
  (ref) => FavoriteRecipesNotifier(),
);

// Recipe Search State
class RecipeSearchState {
  final List<Recipe> results;
  final bool isLoading;
  final String? error;
  final String query;

  const RecipeSearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  RecipeSearchState copyWith({
    List<Recipe>? results,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return RecipeSearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }
}

// Recipe Search Notifier
class RecipeSearchNotifier extends StateNotifier<RecipeSearchState> {
  final RecipeService _recipeService;

  RecipeSearchNotifier(this._recipeService) : super(const RecipeSearchState());

  Future<void> searchRecipes({
    required String query,
    DietType? dietType,
    List<String>? excludeAllergies,
  }) async {
    if (query.trim().isEmpty) {
      state = const RecipeSearchState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null, query: query);

    try {
      final results = await _recipeService.searchRecipes(
        query: query,
        dietType: dietType,
        excludeAllergies: excludeAllergies,
      );
      
      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = const RecipeSearchState();
  }
}

// Favorite Recipes Notifier
class FavoriteRecipesNotifier extends StateNotifier<List<String>> {
  FavoriteRecipesNotifier() : super([]);

  void toggleFavorite(String recipeId) {
    if (state.contains(recipeId)) {
      state = state.where((id) => id != recipeId).toList();
    } else {
      state = [...state, recipeId];
    }
  }

  bool isFavorite(String recipeId) {
    return state.contains(recipeId);
  }

  void clearFavorites() {
    state = [];
  }
}

// Recipe Filters Data Class
class RecipeFilters {
  final int? limit;
  final int? offset;
  final DietType? dietType;
  final String? searchQuery;
  final List<String>? excludeAllergies;

  const RecipeFilters({
    this.limit,
    this.offset,
    this.dietType,
    this.searchQuery,
    this.excludeAllergies,
  });

  RecipeFilters copyWith({
    int? limit,
    int? offset,
    DietType? dietType,
    String? searchQuery,
    List<String>? excludeAllergies,
  }) {
    return RecipeFilters(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      dietType: dietType ?? this.dietType,
      searchQuery: searchQuery ?? this.searchQuery,
      excludeAllergies: excludeAllergies ?? this.excludeAllergies,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipeFilters &&
        other.limit == limit &&
        other.offset == offset &&
        other.dietType == dietType &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    return Object.hash(limit, offset, dietType, searchQuery);
  }
}