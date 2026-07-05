# /threat-model — Lightweight Feature Threat Model

**Input:** the feature to model, typed after the command (e.g. "file upload", "payment checkout", "team invites").

Model the security of a feature before or while building it. Fast and structured, not a formal STRIDE workshop. Follow the operating rules in `.cursor/rules/operating-rules.mdc`. Keep it to the feature at hand; concrete over abstract.

## Five questions

### 1. What's the asset?
What worth attacking does this touch — user data, money, files, credentials, compute, another tenant's data?

### 2. Who's the attacker & what do they control?
Anonymous? Authenticated user? Another tenant? Malicious file/content? What input crosses the trust boundary, and which parts does the attacker fully control?

### 3. What can go wrong? (the 6 usual MVP holes)
- **Auth** — usable without logging in?
- **Authz / IDOR** — act on another user's/tenant's object by changing an ID?
- **Injection** — input hits SQL, shell, template, file path, or LLM prompt?
- **Untrusted content** — uploaded files, external URLs (SSRF), rendered HTML (XSS)?
- **Trusting the client** — price, role, quota, `isAdmin` sent from the browser?
- **Rate / abuse** — spammed, brute-forced, or used to enumerate?

### 4. What's the control for each "yes"?
Name the specific control: auth middleware, ownership check, parameterized query, allowlist, server-side price lookup, signed webhook, rate limit.

### 5. What's the blast radius if it fails? (one line)

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

Feed "build now" controls into implementation. Re-run `/preflight` before shipping.
