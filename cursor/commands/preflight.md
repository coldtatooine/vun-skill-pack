# /preflight — Pre-Launch Security Gate

**Input:** the target you type after the command (a file, directory, or `.`); default to `.` if empty.

Answer one question: **is this codebase safe to deploy to a public URL?**

Optimized for MVPs shipping fast. This is a gate, not a full audit — check the high-frequency, high-blast-radius holes and give a clear verdict. Run `/scan` for depth. Follow the operating rules in `.cursor/rules/operating-rules.mdc`.

## Checklist — run every item

### 1. Secrets exposure (BLOCK on hit)
- Hardcoded API keys, tokens, passwords, private keys in source.
- `.env` / secret files tracked by git (`git ls-files | grep -Ei '\.env|secret|credential'`).
- Secrets shipped to the client bundle (`NEXT_PUBLIC_*` holding a real secret, keys in frontend code).
- Delegate to `/secrets` for a full sweep if anything looks off.

### 2. Authentication & authorization (BLOCK on hit)
- Endpoints / routes / server actions with no auth check.
- Object access without an ownership/tenant check (IDOR).
- Admin or debug routes reachable without privilege.

### 3. Network & transport (WARN, BLOCK if with credentials)
- CORS `Access-Control-Allow-Origin: *` combined with credentials.
- Missing HTTPS enforcement / mixed content. Open redirects.

### 4. Information disclosure (WARN)
- Stack traces, verbose errors, or debug endpoints reachable in production.
- `DEBUG=true`, dev mode, or source maps served publicly.

### 5. Insecure defaults (BLOCK on hit)
- Default credentials (admin/admin), default signing keys/salts.
- Auth/security middleware disabled or commented out.
- Wildcard permissions, `chmod 777`, public storage buckets.

### 6. Dependencies (WARN, BLOCK on critical + reachable)
- Known-vulnerable packages (`npm audit` if available). Unpinned/suspicious deps.

### 7. Input reaching dangerous sinks (BLOCK on confirmed)
- Untrusted input into SQL, shell, template render, file path, or eval. Spot-check obvious entry points; `/scan` for full tracing.

## Verdict

End with exactly one line, then the supporting list:
- **BLOCK** — launch-blocking issue(s). List each with file:line and shortest fix.
- **WARN** — no blockers, but risks to address soon. Ranked.
- **GO** — nothing found in checked scope. State what was and wasn't covered.

For any BLOCK item, hand off to `/fix` or document with `/finding`.
