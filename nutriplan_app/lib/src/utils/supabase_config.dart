import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseConfig {
  static SupabaseClient? _instance;

  static SupabaseClient get client {
    if (_instance == null) {
      throw Exception(
        'Supabase client not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  static Future<void> initialize() async {
    if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL_HERE' ||
        AppConstants.supabaseAnonKey == 'YOUR_SUPABASE_ANON_KEY_HERE') {
      throw Exception(
        'Please set your Supabase credentials in AppConstants or environment variables.',
      );
    }

    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      debug: false, // Set to true in development
    );

    _instance = Supabase.instance.client;
  }

  static bool get isInitialized => _instance != null;
}