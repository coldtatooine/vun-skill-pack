---
description: Format the current security finding into a structured report card with severity, CWE, root cause, evidence, impact, fix, and regression test. Pass --quick for a 3-line summary instead of the full card.
---

# /finding — Format a Security Finding

Write up the current finding as a report card.

If `$ARGUMENTS` is provided, use it as the finding title (strip flags first). Otherwise, derive it from context.

**Mode:** if `$ARGUMENTS` contains `--quick`, use the Quick format. Otherwise use the Full format.

---

## Ground rules

- Only document what you've actually confirmed in the code. Label guesses as hypotheses.
- Don't inflate severity — base it on a realistic exploit path, not theoretical worst case.
- The fix should be the shortest credible solution, not a full refactor.

---

## Quick format (`--quick`)

Three lines, for day-to-day triage speed:

```
[Severity] TITLE — file:line
Risk: [what an attacker gets, one line]
Fix: [shortest credible fix, one line]
```

---

## Full format (default)

**[TITLE]**

**Severity**: Critical / High / Medium / Low
**Confidence**: High / Medium / Low
**CWE**: [number and name]
**Affected**: [file(s), function(s), line range(s)]
**Attack surface**: [entry point — route, handler, CLI arg, agent interface, etc.]
**Prerequisites**: [what the attacker needs — auth? network access? specific role?]

**Root cause**:
[One paragraph. Source → missing validation → sink. Be specific.]

**Evidence**:
[Exact code behavior. Quote or reference the relevant lines. Explain why it's vulnerable.]

**Safe reproduction**:
[Minimal steps to confirm the issue without causing harm.]

**Impact**:
[What an attacker realistically achieves. No exaggeration.]

**Fix**:
[Shortest structural fix. Prefer framework-level controls over one-off bandaids.]

**Regression test**:
[What test would catch this if reintroduced.]

---

*If the issue is not fully confirmed, add at the top:*
> **Status: Hypothesis** — [what evidence is still missing]
