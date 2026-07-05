# /triage — Launch Decision Triage

**Input:** optional findings to triage, typed after the command; otherwise use the findings in the current conversation.

Answer the founder's real question: **what must be fixed before we ship, and what can wait?** MVPs don't fix everything before launch — the goal is an honest, defensible risk decision. Follow the operating rules in `.cursor/rules/operating-rules.mdc`. Base severity on a realistic, reachable exploit path.

## Classify each finding

### 🔴 Blocks launch — fix before public deploy
- Confirmed path to user data, credentials, money, or account takeover
- Leaked secret that is live / in git history / shipped to client (rotate + remove now)
- Unauthenticated access to sensitive data or actions
- Remote code / command / SQL execution
- Payment amount or entitlement trusted from the client

### 🟡 Fix this week — ship, but on a clock
- Real issues with a narrower path or lower impact
- Missing defense-in-depth (rate limiting, security headers, log redaction)
- Medium-severity injection behind auth
- Assign an owner and a date

### 🟢 Accept documented risk — track, don't block
- Low impact, hard to reach, or unrealistic preconditions
- Best-practice gaps with no concrete exploit
- Record: what it is, why accepted, what would change the decision, who owns revisiting

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

**GO-WITH-FIXES** = clear the 🔴 list, then ship. Hand each 🔴 to `/fix`.
