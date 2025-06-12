#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

# Get the workspace number from the item name (aerospace.1 -> 1)
WORKSPACE_ID=${NAME#aerospace.}

# Use the FOCUSED_WORKSPACE environment variable passed by aerospace
CURRENT_WORKSPACE=$FOCUSED_WORKSPACE

# If not set, fallback to querying aerospace directly
if [ -z "$CURRENT_WORKSPACE" ]; then
  CURRENT_WORKSPACE=$(/usr/local/bin/aerospace list-workspaces --focused 2>/dev/null || /opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)
fi

# Update this specific workspace item
if [ "$WORKSPACE_ID" = "$CURRENT_WORKSPACE" ]; then
  /run/current-system/sw/bin/sketchybar --set $NAME icon.background.color=$ACTIVE_COLOR \
                       icon.background.height=15 \
                       icon.background.corner_radius=15
else
  /run/current-system/sw/bin/sketchybar --set $NAME icon.background.color=$ICON_COLOR \
                       icon.background.height=10 \
                       icon.background.corner_radius=10
fi