# Database Integration Rules

## Database
1. Always use **Supabase (Postgres)** as the database.
2. Always define schema via Supabase migrations, never raw SQL in code.
3. Always use Supabase client SDK for queries.

## Data Modeling
1. Always use `snake_case` for table names and fields.
2. Always include `created_at` and `updated_at` timestamps.
3. Always use UUIDs as primary keys.

## Rules for Queries
1. Always centralize DB queries in `/repositories` folder.
2. Never query Supabase directly in controllers or services.
3. Always validate input before query execution.

## Security
1. Always enable row-level security (RLS).
2. Always enforce access policies for each table.
3. Never expose database credentials to frontend.
