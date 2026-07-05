---
description: Fast, lightweight threat model for a new feature before you build it. Five-minute pass over what an attacker gains and where input must be validated. MVP-friendly — cheap up front, avoids expensive rework.
---

# /threat-model — Lightweight Feature Threat Model

Model the security of the feature described in `$ARGUMENTS` (e.g. "file upload", "payment checkout", "team invites") before or while building it.

Not a formal STRIDE workshop — a fast, structured think that catches the obvious holes while they're cheap to close.

## Ground rules

- Keep it to the feature at hand. Don't model the whole app.
- Concrete over abstract: name real entry points, real data, real attackers.
- Output actionable controls, not a threat catalog.

---

## Five questions

### 1. What's the asset?
What does this feature touch that's worth attacking — user data, money, files, credentials, compute, another tenant's data?

### 2. Who's the attacker & what do they control?
- Anonymous visitor? Authenticated user? Another tenant? Malicious file/content?
- What input crosses the trust boundary — and what parts of it does the attacker fully control?

### 3. What can go wrong? (the 6 usual MVP holes)
Walk each against this feature:
- **Auth** — can someone use it without logging in?
- **Authz / IDOR** — can a user act on another user's / tenant's object by changing an ID?
- **Injection** — does input hit SQL, shell, a template, a file path, or an LLM prompt?
- **Untrusted content** — uploaded files, external URLs (SSRF), rendered HTML (XSS)?
- **Trusting the client** — price, role, quota, or `isAdmin` sent from the browser?
- **Rate / abuse** — can it be spammed, brute-forced, or used to enumerate?

### 4. What's the control for each?
For every "yes" above, name the specific control: auth middleware, ownership check, parameterized query, allowlist, server-side price lookup, signed webhook, rate limit.

### 5. What's the blast radius if it fails?
One line. Decides how much effort the controls deserve.

---

## Output

```
FEATURE: [name]
Asset: [what's at risk]
Attacker: [who] controls [what input]

Threats & controls:
- [threat] → [specific control] → [build now / already covered / accept]

Blast radius if unmitigated: [one line]
Build checklist:
- [ ] control 1
- [ ] control 2
```

Feed the "build now" controls straight into implementation. Re-run `/preflight` before shipping.
