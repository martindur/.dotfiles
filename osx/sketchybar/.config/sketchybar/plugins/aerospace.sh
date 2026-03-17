#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

sid="$1"


# Colors (ARGB) - Enhanced 3D effect
ACTIVE_BG=$BLUSH_ROSE
ACTIVE_BORDER=$COTTON_CANDY
ACTIVE_LABEL=$WHITE

INACTIVE_BG=$VELVET_PURPLE
INACTIVE_BORDER=$BLUSH_ROSE
INACTIVE_LABEL=$COTTON_CANDY

# Check if workspace has windows or is focused
window_count=$(aerospace list-windows --workspace "$sid" 2>/dev/null | wc -l)
is_focused=false

if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
  is_focused=true
fi

# Show workspace if it has windows or is focused, otherwise hide it
if [ "$window_count" -gt 0 ] || [ "$is_focused" = true ]; then
  if [ "$is_focused" = true ]; then
    sketchybar --set "$NAME" \
      drawing=on \
      background.color=$ACTIVE_BG \
      background.border_color=$ACTIVE_BORDER \
      label.color=$ACTIVE_LABEL
  else
    sketchybar --set "$NAME" \
      drawing=on \
      background.color=$INACTIVE_BG \
      background.border_color=$INACTIVE_BORDER \
      label.color=$INACTIVE_LABEL
  fi
else
  # Hide workspace if it has no windows and is not focused
  sketchybar --set "$NAME" drawing=off
fi
