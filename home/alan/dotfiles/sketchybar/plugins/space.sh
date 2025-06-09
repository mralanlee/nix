#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

# Get current workspace from aerospace
CURRENT_WORKSPACE=$(/usr/local/bin/aerospace list-workspaces --focused 2>/dev/null || /opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)

# Update all workspaces
for i in {1..8}; do
  if [ "$i" = "$CURRENT_WORKSPACE" ]; then
    /run/current-system/sw/bin/sketchybar --set space.$i background.drawing=on \
                         background.color=$ACTIVE_COLOR \
                         icon.color=$WHITE
  else
    /run/current-system/sw/bin/sketchybar --set space.$i background.drawing=on \
                         background.color=$ITEM_BG_COLOR \
                         icon.color=$ICON_COLOR
  fi
done