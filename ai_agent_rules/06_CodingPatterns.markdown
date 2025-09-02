# Coding Pattern Preferences

## General
1. Always enable **TypeScript strict mode** with `strict: true` in `tsconfig.json`.
2. Always prefer **async/await** over `.then` for asynchronous code to improve readability.
3. Never use `any`; always define explicit types or interfaces, leveraging TypeScript’s type inference where possible.
4. Use environment-specific configurations via `.env` files (as per `01_InitialSetup.md`) and access them through a centralized config module (e.g., `/config/env.ts`).
5. Prefer immutable data structures (e.g., using `const` or libraries like Immer) to reduce side effects.
6. Use TypeScript’s utility types (e.g., `Partial`, `Pick`) to simplify type definitions.
7. Focus on code relevant to the task at hand; avoid modifying unrelated modules or functionality.
8. Always consider the broader impact of code changes, evaluating how they might affect other methods, services, or areas of the codebase.

## Design Patterns
1. Always use the **Repository Pattern** for database access, centralizing queries in `/repositories` (as per `05_DatabaseIntegration.md`).
2. Always use the **Service Layer Pattern** for business logic, keeping controllers thin (as per `03_BackEnd.md`).
3. Use the **Factory Pattern** for object creation only when instantiation logic is complex or requires abstraction (e.g., creating domain entities with dependencies).
4. Consider the **Observer Pattern** for real-time features leveraging Supabase’s subscriptions (e.g., for live updates).
5. Apply **CQRS (Command Query Responsibility Segregation)** for complex domains to separate read and write operations, if scalability demands it.
6. Avoid major changes to established patterns or architecture for features proven to work well, unless explicitly instructed.

## Error Handling
1. Always throw typed errors using a `CustomError` class with properties for `code`, `message`, and `stack` to aid debugging.
2. Always handle errors via a centralized error handler in backend (`/middlewares/error.ts`) and error boundaries in frontend (React).
3. Log errors with context (e.g., request ID, user ID) using Pino or Winston (as per `03_BackEnd.md`).
4. Return standardized error responses in APIs, including `error.code` and `error.message` (as per `04_API.md`).
5. Use discriminated unions for error types in TypeScript to ensure type-safe error handling.

## Clean Code
1. Always follow **SOLID principles** to ensure maintainable and scalable code.
2. Aim for functions under 30 lines; refactor longer functions into smaller, focused units unless complexity is justified (e.g., Supabase query composition).
3. Always use meaningful, descriptive variable names (e.g., `userRepository` instead of `repo`).
4. Prefer simple, readable solutions over clever or overly abstract code.
5. Avoid code duplication by reusing existing utilities or services; check the codebase before implementing similar functionality.
6. Keep files under 300 lines, except for configuration files or generated schemas; refactor into modules if longer.
7. Organize code logically, grouping related functionality in folders (e.g., `/services`, `/components`).
8. Avoid inline scripts in source files; use separate scripts in `/scripts` for one-off tasks, version-controlled but not executed in dev/prod.
9. Optimize performance by minimizing database queries (e.g., batch Supabase calls) and leveraging memoization for expensive computations.
10. Write thorough unit and integration tests for all major functionality, following TDD practices where possible (as per `03_BackEnd.md` and `07_CodingWorkflow.md`).
11. Do not touch or modify code unrelated to the task to prevent unintended side effects.