#!/usr/bin/env bash
# preflight-check.sh — fast, dependency-light secrets + insecure-default scan.
# Meant for pre-commit hooks and CI. Exits non-zero if a likely secret is found.
# This is a coarse net (grep-based), NOT a substitute for /secrets or /preflight
# run by the agent — it just blocks the most obvious leaks automatically.

set -uo pipefail

# Scope: staged files if in a git hook context, else tracked files.
if [ "${1:-}" = "--staged" ]; then
  files=$(git diff --cached --name-only --diff-filter=ACM)
else
  files=$(git ls-files)
fi

[ -z "$files" ] && { echo "preflight: no files to scan"; exit 0; }

# High-signal secret patterns. Extend as needed.
patterns='sk_live_[0-9a-zA-Z]{16,}|rk_live_[0-9a-zA-Z]{16,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z_]{22,}|xox[baprs]-[0-9A-Za-z-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|sk-ant-[0-9A-Za-z_-]{20,}|eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}'

hits=0

# 1. Secret content patterns (skip lockfiles / minified vendor noise).
while IFS= read -r f; do
  [ -f "$f" ] || continue
  case "$f" in
    *.md|*.lock|package-lock.json|pnpm-lock.yaml|yarn.lock|*.min.js|*.map) continue ;;
  esac
  if grep -EnHI "$patterns" "$f" 2>/dev/null; then
    hits=1
  fi
done <<< "$files"

# 2. Tracked real .env files (allow .env.example / templates).
while IFS= read -r f; do
  case "$f" in
    *.env.example|*.env.sample|*.env.template) continue ;;
    *.env|*.env.*) echo "$f: tracked env file — should not be committed"; hits=1 ;;
  esac
done <<< "$files"

if [ "$hits" -ne 0 ]; then
  echo ""
  echo "❌ preflight: possible secret(s) detected. Rotate any real key, remove from the commit, and move to a secret manager."
  echo "   Run /secrets in Claude Code for a full sweep (source + git history + client bundle)."
  exit 1
fi

echo "✅ preflight: no obvious secrets in scanned files"
exit 0
