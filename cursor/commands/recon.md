# /recon — Attack Surface Map

**Input:** the target you type after the command (a file, directory, or `.`); default to `.` if empty.

Map the attack surface without going deep. Output only — no vulnerability analysis yet. Stay shallow; the goal is breadth. Follow the operating rules in `.cursor/rules/operating-rules.mdc`.

## What to produce

### Entry Points
Every place external input enters. For each: name/route/function · input type (HTTP, file, env, CLI, agent call) · auth required? (yes/no/unknown)

### Trust Boundaries
Where code crosses a privilege or trust line: user → system · tenant A → tenant B · app → shell/DB/filesystem/LLM

### Sensitive Sinks
Shell execution · DB queries · file I/O · external HTTP calls · template rendering · eval/dynamic loading · auth and token logic

### High-Value Targets
Top 5 paths connecting an entry point to a sensitive sink with little/no validation in between. Name them — don't trace yet.

Use `/scan` to go deeper on any target.
