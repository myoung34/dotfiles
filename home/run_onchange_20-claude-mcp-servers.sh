#!/bin/sh
set -eu

target="$HOME/.claude.json"
source_json="$(mktemp)"
merged_json="$(mktemp)"
trap 'rm -f "$source_json" "$merged_json"' EXIT HUP INT TERM

cat >"$source_json" <<'JSON'
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    },
    "gopls": {
      "type": "stdio",
      "command": "gopls",
      "args": ["mcp"],
      "env": {}
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--user-data-dir", "${HOME}/.playwright-mcp-data"],
      "env": {}
    }
  }
}
JSON

if [ -f "$target" ]; then
  if ! command -v jq >/dev/null 2>&1; then
    echo "chezmoi: skipping Claude MCP merge because jq is not installed" >&2
    exit 0
  fi

  jq -s '.[0] * .[1]' "$target" "$source_json" >"$merged_json"
else
  cp "$source_json" "$merged_json"
fi

mv "$merged_json" "$target"
chmod 600 "$target"
