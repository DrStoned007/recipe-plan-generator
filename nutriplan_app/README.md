# NutriPlan - Therapeutic Diet Meal Planning App

NutriPlan is a Flutter-based mobile and web application designed to help users with therapeutic dietary needs generate suitable recipes and plan their meals. Built with modern architecture using Flutter, Supabase, and Riverpod for optimal performance and scalability.

## 📱 Features

- **User Authentication**: Email/password and Google sign-in
- **Recipe Discovery**: Browse and search therapeutic diet-friendly recipes
- **Meal Planning**: Plan meals daily, weekly, and monthly
- **Diet Management**: Support for diabetic, renal, heart-healthy, and low-FODMAP diets
- **Cross-platform**: Android, iOS, and Web support
- **Real-time Sync**: Synchronized meal plans across devices

## 🏗️ Architecture

### Frontend
- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management and dependency injection
- **Material Design 3**: Modern, accessible UI components

### Backend
- **Supabase**: Backend-as-a-Service with PostgreSQL
- **Row Level Security**: Secure data access policies
- **Real-time subscriptions**: Live data updates

### Project Structure
```
lib/
├── src/
│   ├── constants/          # App constants and enums
│   ├── models/            # Data models with JSON serialization
│   ├── services/          # Business logic and API services
│   ├── providers/         # Riverpod state management
│   ├── utils/            # Utility functions and configurations
│   ├── common_widgets/   # Reusable UI components
│   └── features/         # Feature-based organization
│       ├── authentication/
│       ├── home/
│       ├── recipes/
│       ├── meal_planning/
│       ├── profile/
│       └── onboarding/
├── main.dart             # App entry point
supabase/
├── schema.sql           # Database schema
└── rls_policies.sql     # Row Level Security policies
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Dart SDK
- A Supabase account
- Google Cloud Console account (for Google Sign-In)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nutriplan_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**

   a. Create a new Supabase project at [supabase.com](https://supabase.com)
   
   b. Execute the database schema:
      - Go to SQL Editor in Supabase Dashboard
      - Copy and run the contents of `supabase/schema.sql`
      - Copy and run the contents of `supabase/rls_policies.sql`
   
   c. Enable Authentication providers:
      - Go to Authentication > Providers
      - Enable Email/Password authentication
      - Configure Google OAuth (optional)

4. **Configure environment variables**

   Create a `.env` file in the root directory:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

   Or update the constants in `lib/src/constants/app_constants.dart`:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
   ```

5. **Generate model files**
   ```bash
   flutter packages pub run build_runner build
   ```

6. **Run the application**
   ```bash
   flutter run
   ```

### Google Sign-In Setup (Optional)

1. **Create a Google Cloud Console project**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one

2. **Enable Google Sign-In API**
   - Navigate to APIs & Services > Library
   - Search for "Google Sign-In API" and enable it

3. **Configure OAuth consent screen**
   - Go to APIs & Services > OAuth consent screen
   - Fill in the required information

4. **Create OAuth 2.0 credentials**
   - Go to APIs & Services > Credentials
   - Create credentials for OAuth 2.0 Client ID
   - Configure for your platform (Android/iOS/Web)

5. **Update Supabase settings**
   - In Supabase Dashboard, go to Authentication > Providers
   - Enable Google provider
   - Add your Google OAuth credentials

## 🛠️ Development

### Code Generation

When you modify model classes, regenerate the serialization code:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Database Changes

When making database schema changes:
1. Update `supabase/schema.sql`
2. Update `supabase/rls_policies.sql` if needed
3. Apply changes in Supabase SQL Editor
4. Update corresponding Dart models

### State Management

This app uses Riverpod for state management:
- **Providers**: Located in `lib/src/providers/`
- **Services**: Business logic in `lib/src/services/`
- **Models**: Data classes in `lib/src/models/`

### Testing

Run tests:
```bash
flutter test
```

Generate test coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📋 Database Schema

### Users Table
- `id` (UUID, Primary Key, references auth.users)
- `name` (VARCHAR)
- `age` (INTEGER)
- `diet_type` (ENUM: diabetic, renal, heart_healthy, low_fodmap, none)
- `allergies` (TEXT[])
- `preferences` (JSONB)
- `created_at`, `updated_at` (TIMESTAMP)

### Recipes Table
- `id` (UUID, Primary Key)
- `title` (VARCHAR)
- `description` (TEXT)
- `ingredients` (JSONB)
- `instructions` (JSONB)
- `diet_type` (ENUM)
- `nutrition` (JSONB)
- `image_url` (TEXT)
- `prep_time`, `cook_time` (INTEGER)
- `servings` (INTEGER)
- `created_by` (UUID, Foreign Key)
- `is_public` (BOOLEAN)
- `created_at`, `updated_at` (TIMESTAMP)

### Meal Plans Table
- `id` (UUID, Primary Key)
- `user_id` (UUID, Foreign Key)
- `recipe_id` (UUID, Foreign Key)
- `date` (DATE)
- `meal_type` (ENUM: breakfast, lunch, dinner)
- `notes` (TEXT)
- `created_at`, `updated_at` (TIMESTAMP)

## 🔒 Security

- **Row Level Security (RLS)**: Enabled on all tables
- **User Data Isolation**: Users can only access their own data
- **Secure Authentication**: JWT-based auth with Supabase
- **API Key Protection**: Anon keys with RLS policies

## 🌐 Deployment

### Android
1. Update `android/app/build.gradle` with your signing config
2. Build the APK:
   ```bash
   flutter build apk --release
   ```

### iOS
1. Configure signing in Xcode
2. Build for iOS:
   ```bash
   flutter build ios --release
   ```

### Web
1. Build for web:
   ```bash
   flutter build web --release
   ```
2. Deploy the `build/web` directory to your hosting provider

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart conventions
- Use Riverpod for state management
- Write tests for new features
- Update documentation for API changes
- Follow the established project structure

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the development team

## 🎯 Roadmap

- [ ] AI-powered meal suggestions
- [ ] Grocery list generation
- [ ] Nutrition tracking
- [ ] Social features (recipe sharing)
- [ ] Healthcare provider integration
- [ ] Apple Health / Google Fit integration
- [ ] Meal preparation timers
- [ ] Recipe import from URLs
