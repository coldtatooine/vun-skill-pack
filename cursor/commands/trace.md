# /trace — Data Flow Trace

**Input:** what to trace, typed after the command (e.g. "user-supplied filename in upload handler", "JWT claims into role check").

Trace a specific input through the code to find where it lands. Follow the operating rules in `.cursor/rules/operating-rules.mdc`. Only trace what's actually in the code — read functions, don't assume behavior. If a function is called but not visible, note it as an assumption.

## Trace steps

### 1. Source
Where does the input first enter? File, function, line. What the attacker controls (full value? partial? type only?).

### 2. Path
Follow it forward. For each hop:
- Function name and file
- Any validation/sanitization applied (exact check — don't paraphrase)
- Any transformation (encoding, parsing, casting)

### 3. Sink
Where it lands: what operation uses it (query, exec, render, fetch, write). Is the input still attacker-controlled at this point?

### 4. Verdict
- **Vulnerable**: reaches sink without sufficient validation → use `/finding`
- **Mitigated**: explain the exact control that stops it
- **Hypothesis**: suggestive but incomplete → say what's missing
