# Coding Workflow Rules

## Development Workflow
1. Always create feature branches: `feature/<name>`.
2. Always use pull requests for merging to `main`.
3. Never push directly to `main` branch.
4. Only make changes that align with the requested scope or are clearly related and well-understood.
5. When fixing bugs, exhaust options within existing patterns before introducing new ones to avoid duplicate logic.
6. Focus on code relevant to the task at hand; avoid modifying unrelated modules or functionality.
7. Always consider the broader impact of code changes, evaluating how they might affect other methods, services, or areas of the codebase.
8. Use GitHub Copilot or similar AI tools for code suggestions, but always review manually.

## Code Reviews
1. Always require at least 1 reviewer before merging.
2. Always block merge if tests are failing.
3. Require automated code quality checks (e.g., SonarQube) in PRs.

## CI/CD
1. Always use GitHub Actions for testing and deployment.
2. Always run linting, type-checking, and tests before merge.
3. Use GitHub Actions with caching for faster builds; deploy to Vercel/Netlify for frontend and Render/Fly.io for backend.
4. Implement blue-green deployments for zero-downtime updates.

## Documentation
1. Always document public functions with JSDoc.
2. Always update API docs when endpoints change.
3. Generate API docs automatically with Swagger/OpenAPI from code annotations.

## Testing
1. Always follow TDD (Test-Driven Development) when possible.
2. Always include unit tests and integration tests for new features.
3. Aim for 80%+ code coverage; use mutation testing with Stryker for robustness.