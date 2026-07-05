---
name: Supabase Security
description: Security footguns specific to Supabase — Row Level Security disabled or too permissive, service_role key exposed to the client, weak policies, storage bucket exposure, and trusting client-set columns. Use when reviewing, building, or shipping an app backed by Supabase.
version: 1.0.0
---

# Supabase Security Footguns

Apply when the app uses Supabase (Postgres, Auth, Storage, Edge Functions). The Supabase client runs in the browser and talks to the database directly, so **RLS is the security boundary** — not your application code. Pair with `/scan`, `/preflight`, `/secrets`.

## 1. Row Level Security (RLS) — the whole ballgame

- **RLS off = the table is fully readable/writable by anyone with the anon key**, which ships to the browser. Every table exposed via the API MUST have RLS enabled.
- Enabling RLS with **no policy** = deny all (safe but broken). Enabling RLS with a **permissive policy** = the real risk. Read every policy.
- Common broken policy: `USING (true)` — allows all rows. Or a policy that checks authentication (`auth.role() = 'authenticated'`) but **not ownership** → any logged-in user reads every row (IDOR at the DB layer).
- Correct ownership pattern: `USING (auth.uid() = user_id)`. Verify both `USING` (read/existing rows) **and** `WITH CHECK` (insert/update) are set — a missing `WITH CHECK` lets a user write rows they can't read.
- Check policies exist for **all** operations: SELECT, INSERT, UPDATE, DELETE. A table with only a SELECT policy may still be freely deleted.

## 2. The `service_role` key

- `service_role` **bypasses RLS entirely.** It is a full-access admin key.
- It must live **server-side only** — never in client code, never under `NEXT_PUBLIC_*`/`VITE_*`/`EXPOSE_*`, never in the browser bundle. Treat exposure as Critical: rotate immediately.
- Use `anon` key in the browser; `service_role` only in trusted server contexts (Route Handlers, Edge Functions, backend jobs).

## 3. Trusting client-set columns

- The client can set any column not blocked by a policy. Fields like `role`, `is_admin`, `credits`, `tenant_id`, `price` must be protected by `WITH CHECK` or set server-side — never trusted from an insert/update coming through the anon client.
- Privilege escalation: user updates their own `role` column to `admin` because the UPDATE policy only checks `auth.uid() = user_id`.

## 4. Storage buckets

- Public buckets serve every object to anyone with the URL. Confirm buckets holding user/private files are **private** with storage RLS policies.
- Storage policies are separate from table RLS — check them explicitly.

## 5. Auth & other

- **Email confirmation / signup**: open signup + auto-confirm can let attackers create accounts freely; confirm it matches intent.
- **`security definer` functions / RPC**: run with the definer's privileges — audit them, they can bypass RLS by design.
- **Postgres extensions & exposed schemas**: don't expose internal schemas via the API.
- **JWT secret**: keep the project JWT secret private; leaking it lets an attacker forge any user's token.

## Quick checklist
- [ ] RLS enabled on every API-exposed table
- [ ] Every policy checks ownership (`auth.uid()`), not just authentication; no `USING (true)`
- [ ] Both `USING` and `WITH CHECK` set for write policies
- [ ] Policies cover SELECT/INSERT/UPDATE/DELETE as needed
- [ ] `service_role` key server-only, never in client bundle
- [ ] Privilege columns (role, credits, tenant_id) not client-writable
- [ ] Private storage buckets have RLS; no unintended public buckets
