#!/usr/bin/env bash

slot="${1:-1}"
status_bin="$HOME/.config/bin/codex-sketchybar-status"
if [ ! -x "$status_bin" ]; then
  status_bin="$(command -v codex-sketchybar-status 2>/dev/null || true)"
fi

if ! command -v jq >/dev/null 2>&1 || [ ! -x "$status_bin" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

status_json="$("$status_bin" 2>/dev/null || echo "[]")"
entry="$(printf '%s' "$status_json" | jq -c --argjson idx "$((slot - 1))" '.[$idx] // empty')"

if [ -z "$entry" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

state="$(printf '%s' "$entry" | jq -r '.state')"

case "$state" in
  blocked)
    icon="󰚩"
    color=0xFFE6C384
    ;;
  working)
    icon="󰚩"
    color=0xFF9ECE6A
    ;;
  *)
    icon="󰚩"
    color=0xFFD4618F
    ;;
esac

sketchybar --set "$NAME" \
  drawing=on \
  icon="$icon" \
  label="" \
  label.drawing=off \
  icon.color="$color" \
  icon.highlight=off
