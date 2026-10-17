# Supabase RLS Test Fixtures

Example SQL test fixtures demonstrating **broken** vs **fixed** Row Level Security (RLS) policies on Supabase/Postgres.

Use these fixtures to reproduce common RLS mistakes in a local or staging database, verify your own policies, or build regression tests for your app.

## What's inside

- `fixtures/00_schema.sql` — sample `profiles` + `posts` tables with RLS enabled.
- `fixtures/01_broken_policies.sql` — intentionally insecure policies (the kind that leak rows).
- `fixtures/02_fixed_policies.sql` — corrected, least-privilege policies.
- `fixtures/03_test_queries.sql` — queries to run as different roles to confirm isolation.

## Quick start

```sql
-- 1. Apply schema
\i fixtures/00_schema.sql
-- 2. Apply the BROKEN policies (to see the leak)
\i fixtures/01_broken_policies.sql
-- 3. Run test queries as anon/authenticated to observe cross-user data exposure
\i fixtures/03_test_queries.sql
-- 4. Reset and apply FIXED policies
\i fixtures/02_fixed_policies.sql
-- 5. Re-run test queries — isolation should now hold
\i fixtures/03_test_queries.sql
```

## Common RLS pitfalls covered

1. `USING (true)` on `SELECT` for authenticated users (exposes all rows).
2. Missing `WITH CHECK` on `INSERT`/`UPDATE` (allows writing other users' rows).
3. Policies that reference `auth.uid()` but are never enabled (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`).
4. Service-role bypass assumptions leaking into client queries.
5. `FOR ALL` policies that grant more than intended.

## ⚠️ Disclaimer

These fixtures are for **testing and learning only**. Do not run them against production data.

## Want a full audit?

This repo is a small taste. The **Supabase RLS Audit Kit** ($29) gives you a complete, repeatable audit playbook: 40+ policy checks, SQL test harness, CI integration, and a remediation checklist.

👉 Get the kit: https://cengokurtoglu.gumroad.com/l/supabase-rls-audit-kit

## License

MIT
