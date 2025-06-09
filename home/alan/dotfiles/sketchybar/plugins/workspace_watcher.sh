#!/bin/bash

# Workspace change watcher for aerospace
LAST_WORKSPACE=""

while true; do
  CURRENT_WORKSPACE=$(/usr/local/bin/aerospace list-workspaces --focused 2>/dev/null || /opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)
  
  if [ "$CURRENT_WORKSPACE" != "$LAST_WORKSPACE" ] && [ -n "$CURRENT_WORKSPACE" ]; then
    /run/current-system/sw/bin/sketchybar --trigger space_change
    LAST_WORKSPACE="$CURRENT_WORKSPACE"
  fi
  
  sleep 0.5
done