#!/bin/sh
set -eu

jq_bin="$(command -v jq || true)"
if [ -z "$jq_bin" ]; then
  echo "chezmoi: skipping Pi settings merge because jq is not installed" >&2
  exit 0
fi

pi_agent_dir="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
settings_file="$pi_agent_dir/settings.json"
tmp_file="$(mktemp)"

cleanup() {
  rm -f "$tmp_file"
}
trap cleanup EXIT

mkdir -p "$pi_agent_dir"

if [ -f "$settings_file" ]; then
  "$jq_bin" '. + {
    "lastChangelogVersion": "0.85.1",
    "theme": "dark",
    "defaultProvider": "aperture-anthropic",
    "defaultModel": "claude-opus-4-8"
  }' "$settings_file" > "$tmp_file"
else
  "$jq_bin" -n '{
    "lastChangelogVersion": "0.85.1",
    "theme": "dark",
    "defaultProvider": "aperture-anthropic",
    "defaultModel": "claude-opus-4-8"
  }' > "$tmp_file"
fi

mv "$tmp_file" "$settings_file"
trap - EXIT
