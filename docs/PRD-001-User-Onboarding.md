# PRD 001: User Onboarding, Profile & Personalization

**Document ID:** PRD-001
**Epic:** Account Management
**Status:** Ready for Development
**Last Updated:** 2025-09-05

---

## 1. Overview & Goal
To provide a seamless onboarding experience where users can create an account and personalize their profile. The user's profile data is the foundation for all recipe recommendations and filtering.

## 2. User Stories
- **US1.1:** As a new user, I want to create an account using my email, Google, or Apple account so I can save my preferences and meal plans.
- **US1.2:** As a new user, I want to be guided through a setup process to input my therapeutic diet, allergies, and health goals so the app can provide tailored recommendations from the start.
- **US1.3:** As an existing user, I want to easily view and edit my profile information in case my dietary needs or preferences change.

## 3. Functional Requirements

### 3.1. Account Creation & Authentication
- The app shall provide three sign-up/sign-in methods: Email/Password, Google (OAuth), and Apple (OAuth).
- Email/Password flow must include a "Forgot Password" feature.
- Supabase Auth will handle all authentication logic and JWT session management.

### 3.2. Onboarding Wizard
- Triggered immediately after the first successful sign-in.
- **Step 1:** Welcome Screen.
- **Step 2:** Primary Goal (e.g., "Manage Diabetes," "Lower Blood Pressure").
- **Step 3:** Therapeutic Diet Selection (e.g., `Diabetic`, `Renal`, `Heart-Healthy`).
- **Step 4:** Dietary Restrictions & Allergies (e.g., `Peanuts`, `Gluten`, `Dairy`, `Vegetarian`).
- **Step 5:** Cuisine Preferences (e.g., `Italian`, `Mexican`, `Asian`).
- The wizard must be skippable and completable later from the Profile screen.

### 3.3. Profile Management Screen
- Accessible from the main navigation.
- Users can view and edit all information collected during onboarding.
- Includes "Log Out" and "Delete Account" buttons.

## 4. Technical Considerations
- **API Endpoints:**
  - `POST /users`: Creates a user profile record. Triggered by a Supabase function on new auth user creation.
  - `PUT /users/{id}`: Updates the user's profile. Secured by RLS.
- **Data Model (`Users` table):**
  - `diet_type`: ENUM (`diabetic`, `renal`, `heart_healthy`, `low_fodmap`, `none`).
  - `allergies`: `TEXT[]` (Array of strings).
  - `preferences`: `JSONB`.

## 5. Acceptance Criteria
- **GIVEN** a user signs up with Google, **WHEN** they complete the onboarding wizard, **THEN** their profile is saved in the database and they are directed to the app's home screen.
- **GIVEN** a user is logged in, **WHEN** they navigate to the Profile screen and change their diet type, **THEN** the change is saved and recipe recommendations are updated.
- **GIVEN** a user is logged in on their phone, **WHEN** they log in on the web app, **THEN** they see the same profile information.