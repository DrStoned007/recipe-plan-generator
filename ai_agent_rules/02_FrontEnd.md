# Frontend Rules

## Framework
1. Always use **React.js with Vite** unless explicitly told otherwise.
2. Always use **TypeScript** (no plain JavaScript).
3. Always use **TailwindCSS** for styling.

## Architecture
1. Always follow **atomic design** principle (atoms, molecules, organisms, pages).
2. Always place reusable components inside `/components`.
3. Never define inline CSS, always use Tailwind classes or global styles.

## State Management
1. Always use **React Query** for server state.
2. Always use **Zustand** for local/global UI state.
3. Never use Redux unless explicitly required.

## Rules for API Calls
1. Always centralize API calls inside `/services/api.ts`.
2. Never call `fetch` or `axios` directly inside components.

## UI/UX Standards
1. Always ensure mobile-first design.
2. Always follow accessibility standards (ARIA roles, labels).
3. Always ensure consistent color palette via Tailwind config.
