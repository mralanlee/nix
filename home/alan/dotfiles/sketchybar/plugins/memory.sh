#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

MEMORY_USAGE=$(ps -A -o %mem | awk '{s+=$1} END {print int(s) "%"}')

sketchybar --set memory label="$MEMORY_USAGE"