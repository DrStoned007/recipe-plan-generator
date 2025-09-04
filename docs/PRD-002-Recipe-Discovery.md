# PRD 002: Recipe Generation, Discovery & Management

**Document ID:** PRD-002
**Epic:** Core Content
**Status:** Ready for Development
**Last Updated:** 2025-09-05

---

## 1. Overview & Goal
To allow users to easily find recipes that match their personalized dietary profile. Users must be able to search, filter, view detailed instructions, and save recipes they like.

## 2. User Stories
- **US2.1:** As a user with hypertension, I want to see a feed of heart-healthy recipes on my home screen for instant ideas.
- **US2.2:** As a user, I want to search for a specific dish and filter the results to match my dietary needs.
- **US2.3:** As a user browsing recipes, I want to view a recipe's full details, including ingredients, instructions, and nutritional information.
- **US2.4:** As a user, I want to "favorite" or "save" a recipe so I can easily find it again later.

## 3. Functional Requirements

### 3.1. Home Screen Recommendations
- The home screen will display a personalized feed of recommended recipes based on the user's `diet_type`.

### 3.2. Recipe Discovery & Filtering
- A dedicated "Recipes" tab will allow browsing and searching.
- A text search bar and a multi-select filter system must be available.
- **Filters:** `diet_type`, `allergies`, `cuisine`, `meal_type` (Breakfast, Lunch, Dinner).
- Results are displayed in a card layout (image, title, tags).

### 3.3. Recipe Detail View
- Displays a high-quality image, title, description, prep/cook time, and servings.
- **Ingredients List:** Formatted as `{quantity, unit, name}`.
- **Instructions:** Numbered, step-by-step list.
- **Nutritional Information (per serving):** Calories, Protein, Carbs, Fat, Sodium, Sugar.

### 3.4. Save/Favorite Recipes
- A "Save" icon will be present on recipe cards and the detail view.
- A "Saved Recipes" section will be available on the Profile screen.

## 4. Technical Considerations
- **API Endpoints:**
  - `GET /recipes`: Supports query parameters for filtering (e.g., `?diet_type=diabetic&q=soup`).
  - `GET /recipes/{id}`: Fetches a single recipe.
  - `POST /users/favorites`: Adds a recipe to favorites.
  - `DELETE /users/favorites/{recipe_id}`: Removes a recipe from favorites.
- **Data Model:**
  - New join table `user_favorite_recipes` {`user_id`, `recipe_id`}.
  - `Recipes` table fields for `ingredients`, `instructions`, and `nutrition` will be `JSONB`.

## 5. Acceptance Criteria
- **GIVEN** a user's diet is 'Diabetic', **WHEN** they open the app, **THEN** the home screen shows only recipes tagged as 'Diabetic'.
- **GIVEN** a user is on the discovery screen, **WHEN** they search for "salad" and filter by "Gluten-Free", **THEN** the results only show gluten-free salad recipes.
- **GIVEN** a user is viewing a recipe, **WHEN** they tap the "Save" icon, **THEN** the icon updates to a "saved" state and the recipe appears in their "Saved Recipes" list.