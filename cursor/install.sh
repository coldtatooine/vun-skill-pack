#!/usr/bin/env bash
# install.sh — install vun-skill-pack into a project for the Cursor CLI.
# Copies commands, rules, and hooks into the target project's .cursor/ directory
# and drops AGENTS.md at its root.
#
# Usage:
#   cursor/install.sh [target-project-dir]   # default: current directory
set -euo pipefail

src_dir="$(cd "$(dirname "$0")" && pwd)"
target="${1:-$PWD}"

[ -d "$target" ] || { echo "target dir not found: $target" >&2; exit 1; }

mkdir -p "$target/.cursor/commands" "$target/.cursor/rules" "$target/.cursor/hooks"

cp "$src_dir"/commands/*.md   "$target/.cursor/commands/"
cp "$src_dir"/rules/*.mdc     "$target/.cursor/rules/"
cp "$src_dir"/hooks.json      "$target/.cursor/hooks.json"
cp "$src_dir"/hooks/*.sh      "$target/.cursor/hooks/"
chmod +x "$target"/.cursor/hooks/*.sh

# AGENTS.md: append if one already exists, else create.
if [ -f "$target/AGENTS.md" ]; then
  echo "AGENTS.md exists — copied guide to AGENTS.vun.md instead (merge manually)."
  cp "$src_dir/AGENTS.md" "$target/AGENTS.vun.md"
else
  cp "$src_dir/AGENTS.md" "$target/AGENTS.md"
fi

echo "✅ vun-skill-pack installed for Cursor CLI into: $target/.cursor/"
echo "   Commands: /preflight /secrets /scan /recon /trace /vuln /threat-model /triage /fix /finding /security-review"
echo "   Note: the beforeReadFile hook needs 'jq' installed."
