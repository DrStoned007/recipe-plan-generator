# AI Agent Prompt for Project Development

You are an AI coding assistant (e.g., Gemini-CLI, Qwen Code) tasked with assisting developers on a project using **React.js with Vite (TypeScript)** for the frontend, **Node.js with Express.js (TypeScript)** for the backend, and **Supabase (Postgres)** as the database. Follow these guidelines to ensure compliance with the project’s coding standards, architecture, and workflow.

## General Guidelines
- Always use **TypeScript strict mode** (`strict: true` in `tsconfig.json`) and define explicit types/interfaces, never using `any`.
- Prefer **async/await** over `.then` for asynchronous code.
- Focus only on code relevant to the task; do not modify unrelated modules or functionality.
- Always consider the broader impact of code changes, evaluating effects on other methods, services, or areas of the codebase.
- Use environment-specific configurations via `.env` files, accessed through a centralized config module (e.g., `/config/env.ts`).
- Never overwrite `.env` files without explicit user confirmation.
- Prefer immutable data structures (e.g., `const`, Immer) to reduce side effects.

## Project Structure
- Adhere to the root structure: `/frontend`, `/backend`, `/docs`, `/config`, `/shared` (for shared types/interfaces).
- Never mix frontend and backend files.
- Use `/shared` for API DTOs or types shared between frontend and backend.

## Frontend Rules
- Use **React.js (v19.x+)** with **Vite** and **TypeScript**.
- Follow **atomic design** (atoms, molecules, organisms, pages) and place reusable components in `/components`.
- Use **TailwindCSS** for styling, never inline CSS.
- Manage server state with **TanStack Query** and local/UI state with **Zustand**.
- Centralize API calls in `/services/api.ts`; never call `fetch` or `axios` directly in components.
- Ensure mobile-first design and WCAG 2.2 compliance (use Lighthouse/axe-core).
- Support dark mode via Tailwind’s `dark:` prefix.

## Backend Rules
- Use **Node.js (LTS >=22.x)** with **Express.js** and **TypeScript**.
- Follow the structure: `/src/controllers`, `/services`, `/models`, `/routes`, `/middlewares`, `/repositories`, `/utils`.
- Keep business logic in services, not controllers.
- Validate inputs with **Zod** and sanitize before processing.
- Use **Pino** for logging with context (e.g., request ID) and OpenTelemetry for tracing.
- Implement rate limiting (`express-rate-limit`) and secure headers (`helmet.js`).
- Use dependency injection (e.g., `tsyringe`) for testability.

## API Rules
- Use **REST API** with routes prefixed `/api/v1`.
- Use plural nouns (e.g., `/users`, `/orders`) and proper HTTP methods (`GET`, `POST`, `PUT/PATCH`, `DELETE`).
- Return JSON responses with `{ success: true, data: {}, error: null, meta: {} }` format.
- Use **JWT** with short expiration (e.g., 15min) and refresh tokens, sent via `Authorization: Bearer <token>`.
- Support versioning via headers (e.g., `Accept: application/vnd.myapp.v1+json`).

## Database Rules
- Use **Supabase (Postgres)** with schema defined via migrations, never raw SQL in code.
- Use **Supabase client SDK** for queries, centralized in `/repositories`.
- Use `snake_case` for table/field names, UUIDs for primary keys, and include `created_at`/`updated_at` timestamps.
- Enable row-level security (RLS) and enforce access policies.
- Use prepared statements via SDK and cache read-heavy queries (e.g., with Redis).

## Coding Patterns
- Use **Repository Pattern** for database access, **Service Layer Pattern** for business logic, and **Factory Pattern** for complex object creation.
- Consider **Observer Pattern** for Supabase real-time subscriptions and **CQRS** for complex domains if needed.
- Avoid major changes to established, working patterns unless explicitly instructed.
- Throw typed `CustomError` with `code`, `message`, and `stack`; use centralized error handlers and React error boundaries.
- Follow **SOLID principles**, keep functions under 30 lines (unless justified), and files under 300 lines (except configs).
- Avoid code duplication by reusing existing utilities/services.
- Optimize performance (e.g., batch Supabase queries, use memoization).

## Workflow and Testing
- Create feature branches (`feature/<name>`) and use pull requests for `main`; never push directly to `main`.
- Require at least one reviewer and block merges if tests fail.
- Use **GitHub Actions** for CI/CD with linting, type-checking, and tests; aim for 80%+ code coverage.
- Write thorough unit and integration tests for all major functionality using **Jest** and **Supertest** (backend).
- Mock data only for tests; never use stubs/fake data in dev or prod.
- Use **Conventional Commits** and document public functions with JSDoc.
- Generate API docs with Swagger/OpenAPI.
- Use GitHub Copilot for suggestions, but always review manually.

## Constraints
- Do not introduce new patterns or technologies unless explicitly requested or exhausted existing options.
- Use only approved tools: React, Node.js, Supabase, TypeScript, Tailwind, Zod, Pino, Jest, etc.
- Never hardcode credentials or expose secrets to frontend.
- Ensure changes align with the task scope and do not affect unrelated code.

**Prompt Example**: "Generate a TypeScript service in `/backend/src/services` to fetch users from Supabase, following the Repository Pattern, with Zod validation and typed error handling. Include Jest unit tests and ensure compliance with mobile-first frontend integration."