#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

# Get the workspace number from the item name (aerospace.1 -> 1)
WORKSPACE_ID=${NAME#aerospace.}

# Get current focused workspace directly from aerospace
CURRENT_WORKSPACE=$(/run/current-system/sw/bin/aerospace list-workspaces --focused)

# Debug output to see what's happening
echo "Space script: NAME=$NAME, WORKSPACE_ID=$WORKSPACE_ID, CURRENT_WORKSPACE=$CURRENT_WORKSPACE" >> /tmp/sketchybar_debug.log

# Update this specific workspace item
if [ "$WORKSPACE_ID" = "$CURRENT_WORKSPACE" ]; then
  echo "Setting $NAME as active" >> /tmp/sketchybar_debug.log
  sketchybar --set $NAME icon.background.color=$ACTIVE_COLOR \
                       icon.background.height=15 \
                       icon.background.corner_radius=15
else
  echo "Setting $NAME as inactive" >> /tmp/sketchybar_debug.log
  sketchybar --set $NAME icon.background.color=$ICON_COLOR \
                       icon.background.height=10 \
                       icon.background.corner_radius=10
fi