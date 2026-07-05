---
name: Node & Express API Security
description: Security footguns specific to Node.js and Express REST APIs — missing auth/authz middleware, IDOR, broken JWT verification, permissive CORS, SQL/NoSQL/command injection, missing rate limiting and security headers, and mass assignment. Use when reviewing, building, or shipping a Node/Express backend.
version: 1.0.0
---

# Node.js & Express API Security Footguns

Apply when the app is a Node/Express (or similar: Fastify, Koa, NestJS) REST API. Pair with `/scan`, `/preflight`, `/secrets`.

## 1. Authentication & authorization

- **Auth middleware must actually be applied** to every protected route. A route registered before/outside the `app.use(auth)` line, or a router mounted without it, is public. Trace the middleware order.
- **Authentication ≠ authorization.** Verifying a valid token proves *who*, not *whether they may*. Check role/ownership per route.
- **IDOR** is the #1 API hole: `GET /users/:id` / `DELETE /orders/:id` must verify the token's user owns/may access that object — not just that the token is valid. Never look up by the path ID alone.

## 2. JWT pitfalls

- **Verify, don't decode.** `jwt.verify(token, secret)` — never `jwt.decode()` for auth (it doesn't check the signature).
- **Pin the algorithm**: `{ algorithms: ['HS256'] }`. Accepting `alg: none` or allowing RS256↔HS256 confusion lets attackers forge tokens.
- Strong, secret signing key (not a default/committed value). Check `exp`. Have a revocation story for logout/compromise.

## 3. CORS

- `cors({ origin: '*', credentials: true })` is invalid and dangerous — with credentials, reflect a strict allowlist of origins, never `*`.
- Don't reflect the incoming `Origin` header unchecked.

## 4. Injection

- **SQL/NoSQL**: parameterized queries / prepared statements only. Never string-concatenate user input. For Mongo, guard against operator injection (`{ $gt: '' }`) by validating/casting types.
- **Command**: avoid `child_process.exec` with user input; use `execFile`/`spawn` with an argument array and no shell.
- **Path traversal**: user-supplied filenames into `fs`/`path.join` → normalize and confine to a base dir; reject `..`.

## 5. Missing defenses

- **Rate limiting** on auth, password reset, and expensive endpoints (`express-rate-limit`) — else brute force / credential stuffing / abuse.
- **Security headers**: `helmet()`.
- **Body size limit**: cap `express.json({ limit })` to prevent DoS.
- **Mass assignment**: `Object.assign(user, req.body)` / spreading `req.body` into a model lets a client set `isAdmin`/`role`. Allowlist writable fields.

## 6. Other

- **Error handling**: don't send stack traces / internal errors to clients in prod. Central error handler, generic messages.
- **Prototype pollution**: deep-merge of untrusted JSON with `__proto__` keys; validate/sanitize.
- **SSRF**: server-side requests to user-supplied URLs → allowlist hosts, block internal ranges and cloud metadata.
- **Secrets** from `process.env`, never committed; validate presence at boot.

## Quick checklist
- [ ] Auth middleware applied to every protected route (verify mount order)
- [ ] Ownership/role checked per route — no IDOR
- [ ] `jwt.verify` with pinned algorithm and a strong secret key
- [ ] CORS uses a strict origin allowlist, never `*` with credentials
- [ ] Parameterized queries; `execFile`/`spawn` not `exec`; path traversal guarded
- [ ] Rate limiting, `helmet`, body-size limit in place
- [ ] Writable fields allowlisted (no mass assignment); no stack traces to clients
