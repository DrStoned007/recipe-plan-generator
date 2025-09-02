# Backend Rules

## Framework & Language
1. Always use **Node.js with Express.js** framework.
2. Always write in **TypeScript**.
3. Prefer async middleware and controllers to leverage Node’s event loop efficiently.

## Structure
```
/backend
  /src
    /controllers
    /services
    /models
    /routes
    /middlewares
    /repositories
    /utils
```
1. Never put business logic inside controllers, always use services.
2. Always validate request input with **Zod** (preferred for TypeScript inference).
3. Always handle errors with centralized middleware.
4. Use dependency injection (e.g., with tsyringe) for services and controllers to improve testability.

## Security
1. Always sanitize inputs before processing.
2. Always enable CORS with specific whitelisted domains.
3. Always store secrets in `.env`.
4. Implement rate limiting with express-rate-limit to prevent abuse.
5. Use helmet.js for setting secure HTTP headers.

## Logging & Monitoring
1. Always use **Pino** for logging due to its speed and JSON output; integrate with OpenTelemetry for distributed tracing.
2. Always log errors with context (request ID, timestamp).
3. Set up monitoring with Prometheus or New Relic for metrics like response times and error rates.

## Testing
1. Always use **Jest** for unit and integration testing.
2. Always test controllers, services, and routes separately.
3. Include end-to-end tests with Supertest for API routes.
4. Write thorough unit and integration tests for all major functionality, following TDD practices where possible.
5. Mock data only for tests; never use stubs or fake data in dev or prod environments.