#!/bin/sh
set -eu

jq_bin="$(command -v jq || true)"
pi_agent_dir="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
settings_file="$pi_agent_dir/settings.json"
tmp_file="$(mktemp)"

cleanup() {
  rm -f "$tmp_file"
}
trap cleanup EXIT

mkdir -p "$pi_agent_dir"

# We route Claude through Aperture (aperture-anthropic), so the standalone
# Claude CLI extension only nags about being unauthenticated. Drop it.
drop_packages='["@saccolabs/pi-claude-cli"]'

# Packages we always want installed, on top of whatever LazyPi curates.
add_packages='["git:github.com/DietrichGebert/ponytail"]'

# Compaction budgets. models.json now declares the real context windows the
# Aperture gateway advertises (see /v1/models), so pi no longer clamps every
# model to its 128k default -- which used to fire compaction at ~112k tokens,
# roughly 44k of which is static system prompt + tool schemas.
#
# keepRecentTokens 60000: on a 1M window the default 20k cliff throws away
# almost everything, so keep a usable tail.
# reserveTokens override for the default model: compact at ~600k rather than
# ~984k, so summarization still has headroom and turns stay affordable.
compaction='{
  "enabled": true,
  "reserveTokens": 16384,
  "keepRecentTokens": 60000,
  "modelOverrides": {
    "aperture-anthropic/claude-opus-5": { "reserveTokens": 400000 }
  }
}'

if [ -f "$settings_file" ]; then
  "$jq_bin" --argjson drop "$drop_packages" --argjson add "$add_packages" \
    --argjson compaction "$compaction" '. + {
    "lastChangelogVersion": "0.85.1",
    "theme": "dark",
    "defaultProvider": "aperture-anthropic",
    "defaultModel": "claude-opus-5",
    "compaction": $compaction
  }
  | (.packages) |= (map(select(. as $p | ($drop | any(. as $d | ($p | contains($d)))) | not)))
  | .packages = ((.packages // []) as $kept | $kept + ($add - $kept))
  ' "$settings_file" > "$tmp_file"
else
  "$jq_bin" -n --argjson add "$add_packages" --argjson compaction "$compaction" '{
    "lastChangelogVersion": "0.85.1",
    "theme": "dark",
    "defaultProvider": "aperture-anthropic",
    "defaultModel": "claude-opus-5",
    "compaction": $compaction,
    "packages": $add
  }' > "$tmp_file"
fi

mv "$tmp_file" "$settings_file"
trap - EXIT
