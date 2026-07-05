---
description: Turn a list of security findings into a launch decision for an MVP. Classifies each issue as blocks-launch, fix-this-week, or accept-documented-risk — a business call, not a generic severity list.
---

# /triage — Launch Decision Triage

Take the findings in context (or in `$ARGUMENTS`) and answer the founder's real question: **what must be fixed before we ship, and what can wait?**

MVPs don't fix everything before launch. The goal is an honest, defensible risk decision — ship fast without shipping a breach.

## Ground rules

- Base severity on a **realistic exploit path**, not worst-case theory.
- Weigh **blast radius** for this product: user data at risk, money movement, account takeover, full compromise.
- "Accept risk" is a valid outcome — but only when documented, bounded, and owned.

---

## Classify each finding into one bucket

### 🔴 Blocks launch — fix before public deploy
Any of:
- Confirmed path to user data, credentials, money, or account takeover.
- Leaked secret that is live / in git history / shipped to client (rotate + remove now).
- Unauthenticated access to sensitive data or actions.
- Remote code / command / SQL execution.
- Payment amount or entitlement trusted from the client.

### 🟡 Fix this week — ship, but on a clock
- Real issues with a narrower path or lower impact.
- Missing defense-in-depth (rate limiting, security headers, log redaction).
- Medium-severity injection behind auth.
- Assign an owner and a date.

### 🟢 Accept documented risk — track, don't block
- Low impact, hard to reach, or requires unrealistic preconditions.
- Best-practice gaps with no concrete exploit.
- Record: what it is, why it's accepted, what would change the decision, who owns revisiting it.

---

## Output

```
LAUNCH DECISION: GO / GO-WITH-FIXES / NO-GO

🔴 Blocks launch (N)
- [finding] — file:line — fix: [shortest] — owner: [?]

🟡 Fix this week (N)
- [finding] — file:line — by: [date] — owner: [?]

🟢 Accepted risk (N)
- [finding] — why accepted — revisit when: [trigger]
```

**GO-WITH-FIXES** means: clear the 🔴 list, then ship. Hand each 🔴 to `/fix`.
