# PRD 000: NutriPlan - Master Product Document & MVP Scope

**Document ID:** PRD-000
**Status:** Scoping Finalized
**Last Updated:** 2025-09-05

---

## 1. Product Overview
NutriPlan is a mobile and web application designed to help users with therapeutic dietary needs generate suitable recipes and plan their meals on a monthly basis. It aims to simplify the complexity of managing health-related diets.

## 2. Strategic Objectives
- **Business Goal:** Achieve a 10% user retention rate after 3 months post-launch by providing indispensable value in meal planning.
- **Product Goal:** Become the most user-friendly tool for planning and discovering therapeutic diet recipes.
- **Technical Goal:** Build a scalable, cross-platform application on a modern serverless stack (Flutter + Supabase) to enable rapid iteration.

## 3. Target Audience
- **Primary:** Patients aged 30-65 diagnosed with conditions requiring a therapeutic diet (e.g., Type 2 Diabetes, Hypertension, Renal Disease).
- **Secondary:** Caregivers (family members, home nurses) who manage meals for others.
- **Tertiary:** Health-conscious individuals seeking structured, healthy meal plans.

## 4. MVP Scope Summary

### In Scope for MVP:
- User account creation, login, and profile personalization (See **PRD-001**).
- Recipe discovery engine with filtering by diet, allergies, and preferences (See **PRD-002**).
- Ability to view and save favorite recipes (See **PRD-002**).
- A monthly/weekly calendar to manually add recipes to specific dates (See **PRD-003**).
- Cross-device sync for profiles, saved recipes, and meal plans.
- One-way sync *to* Google Calendar (See **PRD-003**).

### Out of Scope for MVP:
- AI-powered features (chatbot, automatic plan generation).
- Grocery list generation.
- Wearable integrations (Apple Health, Fitbit).
- Professional/dietitian dashboards.
- Social features (sharing, community recipes).

## 5. Core Technical Architecture (Shared)
- **Frontend:** Flutter (for Android & Web) with Material Design 3.
- **State Management:** Riverpod.
- **Backend & Database:** Supabase (PostgreSQL, Auth, Storage, Edge Functions).
- **API:** RESTful endpoints exposed via Supabase Edge Functions.
- **Integrations:** Google Calendar API, Firebase Cloud Messaging (FCM).

## 6. Global Non-Functional Requirements (NFRs)
- **Performance:** App load time < 3 seconds. API responses < 500ms (P95).
- **Security:** All data transfer over HTTPS. RLS enforced on all Supabase tables.
- **Accessibility:** WCAG 2.1 AA compliance.
- **Data Privacy:** User data must be deletable upon request.