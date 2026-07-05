---
description: Apply the shortest credible fix for a confirmed security finding to the working tree, with a diff. Use after /scan, /vuln, /trace, or /finding when the team wants the issue resolved, not just reported.
---

# /fix — Guided Remediation

Apply a fix for the security issue described in `$ARGUMENTS`, or for the finding currently in context.

Built for MVP speed: resolve the issue with the smallest safe change, show the diff, keep moving.

## Ground rules

- **Fix only confirmed issues.** If the finding is a hypothesis, say so and confirm it first — do not patch on a guess.
- **Shortest structural fix wins.** Prefer a framework-level control (parameterized query, auth middleware, validation at the boundary) over scattered one-off bandaids. No full refactors.
- **Do not weaken anything else.** The fix must not break existing behavior or remove another control.
- **Never invent APIs.** Use functions/config that exist in this codebase and its dependencies. Verify by reading before editing.

---

## Steps

### 1. Confirm the issue
Restate the finding in one line: source → gap → sink. If not already confirmed in code, read the relevant lines now.

### 2. Choose the fix
State the fix and why it's the shortest credible one. Note any alternative you rejected and why (e.g. "escaping input" rejected in favor of "parameterized query — kills the class, not one payload").

### 3. Apply
Edit the working tree. For secrets: rotate is a human action — apply the code/config change and flag rotation as a required manual follow-up.

### 4. Show the diff
Present the exact change made, file by file.

### 5. Regression note
One line: what test or check would catch this if reintroduced. Offer to add it.

---

## Guardrails

- If the fix touches auth, crypto, or payment flows, call it out explicitly and recommend a human review before deploy.
- If fixing correctly requires a decision only the team can make (which roles may access X, what the tenant model is), stop and ask rather than guessing.
- If more than ~3 files need changing, this is no longer a quick fix — summarize the needed change and confirm scope before proceeding.
