# Initial Setup Rules

## Environment
1. Always use **Node.js LTS version (>=22.x)** for backend.
2. Always use **npm** (not yarn or pnpm) as the package manager.
3. Always create a `.nvmrc` file specifying the Node.js version.
4. Always create a `.editorconfig` file for consistent formatting.
5. Always use Docker for local development environments to ensure consistency across team members and CI/CD.

## Project Structure
1. Root directories must follow this structure:
   ```
   /project-root
     /frontend
     /backend
     /docs
     /config
     /shared
   ```
2. Never mix backend and frontend files in the same folder.
3. Include a `/shared` folder for types/interfaces shared between frontend and backend (e.g., API DTOs).

## Git & Versioning
1. Always initialize git with `main` branch as default.
2. Always enforce commit messages with [Conventional Commits](https://www.conventionalcommits.org/).
3. Always include `.gitignore` (Node.js, Supabase, React/Vue).
4. Always enable GitHub's Dependabot for automated dependency updates and security alerts.
5. Use semantic versioning (SemVer) for project releases, tagging with `vX.Y.Z`.

## Security & Config
1. Always use `.env` for secrets (never hardcode credentials).
2. Always provide `.env.example` with placeholder values.
3. Never commit `.env` to version control.
4. Never overwrite `.env` files without explicit user confirmation.
5. Use a secrets manager (e.g., Doppler or AWS Secrets Manager) in production for sensitive data.