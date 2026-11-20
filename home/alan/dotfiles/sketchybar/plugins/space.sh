#!/bin/bash

# Redraws every workspace dot in one sketchybar call.
# Focused: large purple. Visible on another monitor: purple. Has windows: white. Empty: dim.

source "$CONFIG_DIR/globalstyles.sh"

AEROSPACE=/run/current-system/sw/bin/aerospace
FOCUSED=$($AEROSPACE list-workspaces --focused)
VISIBLE=" $($AEROSPACE list-workspaces --monitor all --visible | tr '\n' ' ')"
OCCUPIED=" $($AEROSPACE list-workspaces --monitor all --empty no | tr '\n' ' ')"

# aerospace not answering (starting up): keep the bar as it is
[ -n "$FOCUSED" ] || exit 0

args=()
for sid in 1 2 3 4 5 6 7 8 9; do
  color=0x40e6dcff size=10
  [[ "$OCCUPIED" == *" $sid "* ]] && color=$ICON_COLOR
  [[ "$VISIBLE" == *" $sid "* ]] && color=$ACTIVE_COLOR
  [ "$sid" = "$FOCUSED" ] && size=15
  args+=(--set "aerospace.$sid" icon.background.color="$color"
    icon.background.height="$size" icon.background.corner_radius="$size")
done

sketchybar "${args[@]}"
