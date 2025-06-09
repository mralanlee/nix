#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

# Matching your Waybar format: "{:%a %b %d  %I:%M %p}"
sketchybar --set $NAME label="$(date '+%a %b %d  %I:%M %p')"