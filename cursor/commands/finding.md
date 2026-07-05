# /finding — Format a Security Finding

**Input:** optional finding title, typed after the command. Add `--quick` for a 3-line summary instead of the full card. If no title, derive from context.

Write up the current finding as a report card. Follow the operating rules in `.cursor/rules/operating-rules.mdc`: only document what's confirmed in the code (label guesses as hypotheses), realistic severity, shortest credible fix.

## Quick format (`--quick`)
```
[Severity] TITLE — file:line
Risk: [what an attacker gets, one line]
Fix: [shortest credible fix, one line]
```

## Full format (default)

**[TITLE]**

**Severity**: Critical / High / Medium / Low
**Confidence**: High / Medium / Low
**CWE**: [number and name]
**Affected**: [file(s), function(s), line range(s)]
**Attack surface**: [entry point — route, handler, CLI arg, agent interface]
**Prerequisites**: [what the attacker needs — auth? network access? role?]

**Root cause**: [One paragraph. Source → missing validation → sink. Be specific.]

**Evidence**: [Exact code behavior. Quote/reference the lines. Why it's vulnerable.]

**Safe reproduction**: [Minimal steps to confirm without causing harm.]

**Impact**: [What an attacker realistically achieves. No exaggeration.]

**Fix**: [Shortest structural fix. Framework-level controls over one-off bandaids.]

**Regression test**: [What test would catch this if reintroduced.]

*If not fully confirmed, add at the top:*
> **Status: Hypothesis** — [what evidence is still missing]
