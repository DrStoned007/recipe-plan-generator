// App Constants
class AppConstants {
  static const String appName = 'NutriPlan';
  static const String appVersion = '0.1.0';
  
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL_HERE',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY', 
    defaultValue: 'YOUR_SUPABASE_ANON_KEY_HERE',
  );
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String recipesRoute = '/recipes';
  static const String mealPlansRoute = '/meal-plans';
  static const String profileRoute = '/profile';
  
  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_completed';
}

// Diet Types Enum
enum DietType {
  diabetic,
  renal,
  heartHealthy,
  lowFodmap,
  none;
  
  String get displayName {
    switch (this) {
      case DietType.diabetic:
        return 'Diabetic';
      case DietType.renal:
        return 'Renal';
      case DietType.heartHealthy:
        return 'Heart Healthy';
      case DietType.lowFodmap:
        return 'Low FODMAP';
      case DietType.none:
        return 'None';
    }
  }
}

// Meal Types Enum
enum MealType {
  breakfast,
  lunch,
  dinner;
  
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
    }
  }
}