#!/usr/bin/env bash
# block-secret-files.sh — Cursor beforeReadFile hook.
# Prevents raw secret files (.env, keys, credentials) from being read into the
# model context, so their contents are not sent to the LLM endpoint.
#
# Protocol: receives a JSON payload on stdin with a .file_path field; must print
# {"permission":"allow"} or {"permission":"deny","user_message":"..."} on stdout.
# Requires `jq`. Fails open (allow) if jq is missing so reviews aren't blocked.

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  echo '{"permission":"allow"}'
  exit 0
fi

file_path=$(printf '%s' "$input" | jq -r '.file_path // empty')
base=$(basename "$file_path")

# Allow example/template env files — they hold placeholders, not real secrets.
case "$base" in
  .env.example|.env.sample|.env.template|*.env.example|*.env.sample|*.env.template)
    echo '{"permission":"allow"}'
    exit 0
    ;;
esac

# Deny real secret-bearing files.
case "$base" in
  .env|.env.*|*.env|*.pem|*.key|*.pfx|id_rsa|id_ed25519|credentials|*.credentials)
    echo '{"permission":"deny","user_message":"vun-skill-pack: blocked reading a secret file ('"$base"') into model context. Review it manually; run /secrets for a redacted sweep."}'
    exit 0
    ;;
esac

echo '{"permission":"allow"}'
exit 0
