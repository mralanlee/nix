#!/bin/bash

# Workspace change watcher for aerospace
LAST_WORKSPACE=""

while true; do
  CURRENT_WORKSPACE=$(/run/current-system/sw/bin/aerospace list-workspaces --focused 2>/dev/null)
  
  if [ "$CURRENT_WORKSPACE" != "$LAST_WORKSPACE" ] && [ -n "$CURRENT_WORKSPACE" ]; then
    sketchybar --trigger aerospace_workspace_change
    export FOCUSED_WORKSPACE="$CURRENT_WORKSPACE"
    LAST_WORKSPACE="$CURRENT_WORKSPACE"
  fi
  
  sleep 0.5
done