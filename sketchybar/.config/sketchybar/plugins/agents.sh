#!/usr/bin/env bash

slot="${1:-1}"
agentman_bin="$HOME/.cargo/bin/agentman"
if [ ! -x "$agentman_bin" ]; then
  agentman_bin="$(command -v agentman 2>/dev/null || true)"
fi

if [ -z "$agentman_bin" ] || [ ! -x "$agentman_bin" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

entry="$($agentman_bin slot "$slot" --max-age-ms "${AGENTMAN_MAX_AGE_MS:-1500}" --cache-path "${AGENTMAN_CACHE_PATH:-/tmp/agentman-status.json}" 2>/dev/null || echo "null")"

if [ -z "$entry" ] || [ "$entry" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

state="$(printf '%s' "$entry" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p')"

case "$state" in
  blocked)
    icon="󰚩"
    color=0xFFE6C384
    ;;
  working)
    icon="󰚩"
    color=0xFF9ECE6A
    ;;
  idle)
    icon="󰚩"
    color=0xFFD4618F
    ;;
  *)
    sketchybar --set "$NAME" drawing=off
    exit 0
    ;;
esac

sketchybar --set "$NAME" \
  drawing=on \
  icon="$icon" \
  label="" \
  label.drawing=off \
  icon.color="$color" \
  icon.highlight=off
