# NutriPlan Setup Guide

This guide will walk you through setting up the NutriPlan application for development.

## Prerequisites

✅ **Required Software**
- Flutter SDK (^3.9.2) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK (included with Flutter)
- Your preferred IDE (VS Code, Android Studio, or IntelliJ)
- Git

✅ **Required Accounts**
- [Supabase](https://supabase.com) account (free tier available)
- [Google Cloud Console](https://console.cloud.google.com) account (optional, for Google Sign-In)

## Step 1: Flutter Setup

### Verify Flutter Installation
```bash
flutter doctor
```
This command checks your environment and displays any issues that need to be resolved.

### Install Dependencies
```bash
cd nutriplan_app
flutter pub get
```

## Step 2: Supabase Backend Setup

### 2.1 Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Click \"New Project\"
3. Choose your organization
4. Enter project details:
   - Name: `nutriplan-app`
   - Database Password: Choose a strong password
   - Region: Select closest to your users
5. Click \"Create new project\"
6. Wait for the project to be initialized (2-3 minutes)

### 2.2 Configure Database Schema
1. In your Supabase dashboard, go to **SQL Editor**
2. Click \"New query\"
3. Copy the contents of `supabase/schema.sql` and paste it
4. Click \"Run\" to execute the schema

### 2.3 Set Up Row Level Security
1. In the SQL Editor, create another new query
2. Copy the contents of `supabase/rls_policies.sql` and paste it
3. Click \"Run\" to apply the security policies

### 2.4 Configure Authentication
1. Go to **Authentication** > **Providers**
2. Enable **Email** provider (should be enabled by default)
3. **Optional**: Configure Google OAuth:
   - Enable **Google** provider
   - Add your Google OAuth credentials (see Google Setup section below)

### 2.5 Get Supabase Credentials
1. Go to **Settings** > **API**
2. Copy your:
   - **Project URL**
   - **anon public** key

## Step 3: Configure Environment Variables

### Option A: Environment Variables (Recommended)
Create a `.env` file in the project root:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

### Option B: Update Constants File
Edit `lib/src/constants/app_constants.dart`:
```dart
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

## Step 4: Google Sign-In Setup (Optional)

### 4.1 Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click \"Select a project\" > \"New Project\"
3. Enter project name: `nutriplan-app`
4. Click \"Create\"

### 4.2 Enable APIs
1. Go to **APIs & Services** > **Library**
2. Search for and enable:
   - Google Sign-In API
   - Google+ API (if available)

### 4.3 Configure OAuth Consent Screen
1. Go to **APIs & Services** > **OAuth consent screen**
2. Choose **External** user type
3. Fill in required information:
   - App name: `NutriPlan`
   - User support email: Your email
   - Developer contact email: Your email
4. Add scopes: `email`, `profile`, `openid`
5. Save and continue

### 4.4 Create OAuth Credentials

#### For Android:
1. Go to **APIs & Services** > **Credentials**
2. Click \"Create Credentials\" > \"OAuth 2.0 Client ID\"
3. Application type: **Android**
4. Package name: `com.example.nutriplan_app`
5. SHA-1 certificate fingerprint:
   ```bash
   # For debug builds
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
6. Copy the SHA-1 fingerprint and paste it
7. Click \"Create\"

#### For iOS:
1. Create another OAuth 2.0 Client ID
2. Application type: **iOS**
3. Bundle ID: `com.example.nutriplanApp`
4. Click \"Create\"

#### For Web:
1. Create another OAuth 2.0 Client ID
2. Application type: **Web application**
3. Authorized redirect URIs: `https://your-project-id.supabase.co/auth/v1/callback`
4. Click \"Create\"

### 4.5 Update Supabase with Google OAuth
1. In Supabase Dashboard, go to **Authentication** > **Providers**
2. Enable **Google** provider
3. Add your Google OAuth credentials:
   - Client ID: From Google Cloud Console
   - Client Secret: From Google Cloud Console

## Step 5: Generate Model Files

Run the build runner to generate JSON serialization code:
```bash
flutter packages pub run build_runner build
```

## Step 6: Test the Setup

### Run the App
```bash
flutter run
```

### Test Features
1. **App Launch**: Verify the splash screen appears
2. **Authentication**: Test email signup/login
3. **Google Sign-In**: Test Google authentication (if configured)
4. **Navigation**: Navigate between tabs
5. **Database**: Check that user profiles are created

## Step 7: Development Tools Setup

### VS Code Extensions
Install these helpful extensions:
- Flutter
- Dart
- Dart Data Class Generator
- Flutter Riverpod Snippets
- Thunder Client (for API testing)

### Android Studio Plugins
- Flutter
- Dart

## Troubleshooting

### Common Issues

#### 1. \"Supabase client not initialized\"
**Solution**: Check that your Supabase URL and anon key are correctly set in `app_constants.dart` or environment variables.

#### 2. \"Failed to load recipes\" or similar database errors
**Solution**: 
- Verify your database schema is properly created
- Check RLS policies are applied
- Ensure your Supabase project is active

#### 3. Google Sign-In not working
**Solution**:
- Verify SHA-1 fingerprints are correct
- Check that Google OAuth is properly configured in Supabase
- Ensure the correct package name/bundle ID is used

#### 4. Build runner fails
**Solution**:
```bash
flutter clean
flutter pub get
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 5. \"version solving failed\" during pub get
**Solution**:
```bash
flutter clean
flutter pub cache clean
flutter pub get
```

### Getting Help

1. Check the [Flutter documentation](https://docs.flutter.dev/)
2. Review [Supabase documentation](https://supabase.com/docs)
3. Search for similar issues on Stack Overflow
4. Create an issue in the project repository

## Next Steps

Once setup is complete:

1. **Explore the codebase**: Familiarize yourself with the project structure
2. **Read the documentation**: Review the README and code comments
3. **Run tests**: Execute `flutter test` to ensure everything works
4. **Start developing**: Begin implementing new features or fixes

## Production Deployment

For production deployment:

1. **Update app identifiers**: Change package names from `com.example.*`
2. **Configure signing**: Set up proper code signing for release builds
3. **Update Supabase settings**: Configure production environment
4. **Test thoroughly**: Perform comprehensive testing before release

Congratulations! You now have a fully functional NutriPlan development environment. 🎉", "original_text": null, "replace_all": false}]