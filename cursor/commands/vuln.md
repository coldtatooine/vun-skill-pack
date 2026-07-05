# /vuln — Check for a Specific Vulnerability Class

**Input:** the vulnerability class, typed after the command (e.g. "sql injection", "ssrf", "path traversal", "broken access control", "hardcoded secrets").

Scan the codebase for one vulnerability class. Follow the operating rules in `.cursor/rules/operating-rules.mdc`. Only flag real, reachable issues — not every place a dangerous function exists. Prefer data-flow reasoning over keyword matching.

## What to do

### 1. Find candidates
Search for patterns relevant to the class. List files and functions — don't analyze yet.

### 2. Filter to reachable
For each candidate: reachable from external input? Drop dead code and internal-only paths.

### 3. Verify each survivor
- Trace input → sink
- Check what validation exists (read the actual code)
- Confirm or rule out

### 4. Report
- Confirmed issue → use `/finding` format
- Near-miss → hypothesis with what's still unclear
- Ruled-out lead → one line each explaining why
