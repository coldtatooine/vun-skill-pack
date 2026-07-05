# /scan — Full Security Review

**Input:** the target you type after the command (a file, directory, or `.`); default to `.` if empty.

Run a full security review. Follow the operating rules in `.cursor/rules/operating-rules.mdc`.

## Step 1 — Attack surface map
List every place external input enters:
- **Entry points**: routes, CLI args, webhooks, file uploads, background jobs, agent/tool interfaces
- **Trust boundaries**: user input, tenant separation, privilege changes, external API calls, LLM/tool calls
- **Sensitive sinks**: shell commands, SQL queries, file read/write, HTTP fetches, template rendering, eval, auth decisions, token issuance, secret access

One line per item.

## Step 2 — Prioritize
Top 5–10 paths where untrusted input reaches a sensitive sink:
1. Auth bypass and broken access control first
2. Injection (SQL, command, template, prompt)
3. File path traversal, SSRF
4. Secrets and crypto misuse
5. Multi-tenant isolation gaps

## Step 3 — Trace each lead
- Source → validation gap → sink
- What the attacker controls and what they need
- Realistic impact (not theatrical)

## Step 4 — Report
### A. Executive Summary — overall risk, top 3 issues, confidence
### B. Findings Table
| Title | Severity | Confidence | CWE | Affected |
|-------|----------|------------|-----|---------|
### C. Confirmed Findings — use `/finding` format for each
### D. Hypotheses — suspicious but need more evidence
### E. Ruled Out — what was checked and why it's not a problem
