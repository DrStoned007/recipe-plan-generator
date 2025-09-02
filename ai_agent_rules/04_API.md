# API Rules

## General
1. Always use **REST API** pattern (no GraphQL unless specified).
2. Always prefix routes with `/api/v1`.
3. Always return JSON responses only.

## Endpoint Design
1. Use plural nouns for resource names (`/users`, `/orders`).
2. Always use proper HTTP methods:
   - `GET` → fetch data
   - `POST` → create data
   - `PUT/PATCH` → update data
   - `DELETE` → delete data
3. Never use verbs in endpoints (use nouns).

## Response Format
```json
{
  "success": true,
  "data": {},
  "error": null
}
```
1. Always include `success`, `data`, `error` keys in response.
2. Always use proper HTTP status codes.

## Authentication
1. Always use JWT for authentication.
2. Always send tokens via `Authorization: Bearer <token>` header.
3. Never expose raw user passwords in responses.
