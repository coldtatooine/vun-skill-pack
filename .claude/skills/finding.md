Format the current finding as a structured report card.

Usage: `/finding` or `/finding <title>`

## Ground rules

- Only document what's confirmed in the code. Label guesses as hypotheses.
- Base severity on a realistic exploit path — don't inflate.
- Fix should be the shortest structural solution.

---

**[$ARGUMENTS or derived title]**

**Severity**: Critical / High / Medium / Low
**Confidence**: High / Medium / Low
**CWE**: [number — name]
**Affected**: [file(s), function(s), line(s)]
**Entry point**: [route / handler / CLI arg / agent interface]
**Prerequisites**: [what the attacker needs — auth level, network position, role]

**Root cause**:
[Source → missing validation → sink. One paragraph, specific.]

**Evidence**:
[Reference exact code. Quote or cite the relevant lines. Explain why it's vulnerable.]

**Safe reproduction**:
[Minimal steps to confirm without causing harm.]

**Impact**:
[What the attacker realistically achieves. No exaggeration.]

**Fix**:
[Shortest structural fix. Framework-level controls over one-off bandaids.]

**Regression test**:
[What test would catch this if it comes back.]

---

*If not fully confirmed, prepend:*
> **Status: Hypothesis** — [what evidence is still missing]
