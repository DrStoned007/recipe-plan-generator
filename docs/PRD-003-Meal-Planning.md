# PRD 003: Meal Planning Calendar & Integrations

**Document ID:** PRD-003
**Epic:** Core Functionality
**Status:** Ready for Development
**Last Updated:** 2025-09-05

---

## 1. Overview & Goal
To provide users with a simple and intuitive calendar tool to plan their meals. This feature brings the discovered recipes into an actionable plan.

## 2. User Stories
- **US3.1:** As a user, I want to add a recipe to a specific date and mealtime (Breakfast, Lunch, Dinner) in a calendar to build my meal plan.
- **US3.2:** As a user, I want to view my meal plan in both a monthly and weekly format.
- **US3.3:** As a user who uses Google Calendar, I want to optionally sync my meal plan so my meals appear alongside my other appointments.
- **US3.4:** As a user, I want to receive a daily or weekly reminder about my upcoming meals.

## 3. Functional Requirements

### 3.1. Calendar Interface
- A dedicated "Calendar" tab with **Monthly** and **Weekly** view toggles.
- Tapping a date shows the meals planned for that day (Breakfast, Lunch, Dinner slots).

### 3.2. Adding Recipes to Calendar
- **From Recipe Detail:** An "Add to Plan" button opens a modal to select a `date` and `meal_type`.
- **From Calendar:** Tapping an empty meal slot opens a view to search/select a recipe.

### 3.3. Managing the Meal Plan
- Users must be able to tap a planned meal to view the recipe or remove it from the plan.
- Drag-and-drop is **out of scope** for MVP.

### 3.4. Google Calendar Integration
- Users can connect their Google Account via OAuth2 in settings.
- When a meal is added in NutriPlan, a corresponding event is created on the user's primary Google Calendar.
- Removing a meal in NutriPlan also removes the Google Calendar event.

### 3.5. Push Notifications
- Users can opt-in to notifications.
- A daily push notification is sent at a user-defined time summarizing the next day's meals.

## 4. Technical Considerations
- **API Endpoints:**
  - `POST /meal_plans`: Adds a recipe to a date for a user.
  - `GET /meal_plans`: Fetches meal plan entries for a user within a date range.
  - `DELETE /meal_plans/{id}`: Deletes a meal plan entry.
- **Google Calendar API:**
  - Backend logic (Supabase Edge Function) will handle OAuth and API calls.
  - User's Google `access_token` and `refresh_token` must be stored securely.
- **Push Notifications (FCM):**
  - A scheduled Supabase function (`cron`) will run daily to trigger notifications.
- **Data Model (`Meal_Plans` table):**
  - Add `meal_type`: ENUM (`breakfast`, `lunch`, `dinner`).

## 5. Acceptance Criteria
- **GIVEN** a user adds "Avocado Toast" to September 10th / Breakfast, **THEN** the recipe appears in the correct slot on the calendar.
- **GIVEN** a user has connected their Google Calendar, **WHEN** they add a meal to their plan, **THEN** a corresponding event is created in their Google Calendar within 1 minute.
- **GIVEN** a user has enabled notifications, **WHEN** it is 7 PM, **THEN** they receive a push notification summarizing the meals planned for the next day.