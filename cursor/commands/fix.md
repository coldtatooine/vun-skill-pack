# /fix — Guided Remediation

**Input:** the issue to fix, typed after the command; otherwise use the finding in the current conversation.

Apply a fix for a confirmed security issue with the smallest safe change, show the diff, keep moving. Follow the operating rules in `.cursor/rules/operating-rules.mdc`.

- **Fix only confirmed issues.** If it's a hypothesis, say so and confirm it first — don't patch on a guess.
- **Shortest structural fix wins.** Prefer a framework-level control (parameterized query, auth middleware, boundary validation) over scattered bandaids. No full refactors.
- **Don't weaken anything else.** No breaking existing behavior or removing another control.
- **Never invent APIs.** Use functions/config that exist in this codebase and its deps. Verify by reading before editing.

## Steps
1. **Confirm the issue** — restate in one line: source → gap → sink. Read the relevant lines if not already confirmed.
2. **Choose the fix** — state it and why it's the shortest credible one. Note any alternative rejected and why.
3. **Apply** — edit the working tree. For secrets: rotation is a human action — apply the code/config change and flag rotation as a required manual follow-up.
4. **Show the diff** — the exact change, file by file.
5. **Regression note** — one line: what test/check catches this if reintroduced. Offer to add it.

## Guardrails
- If the fix touches auth, crypto, or payment flows, call it out and recommend human review before deploy.
- If correct fixing needs a team decision (which roles access X, the tenant model), stop and ask.
- If more than ~3 files need changing, it's no longer a quick fix — summarize and confirm scope first.
