#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

if [[ $MUTED == "true" ]]; then
  ICON="󰝟"
  COLOR=$GREY
else
  if [[ $VOLUME -gt 66 ]]; then
    ICON="󰕾"
  elif [[ $VOLUME -gt 33 ]]; then
    ICON="󰖀"
  else
    ICON="󰕿"
  fi
  COLOR=$ICON_COLOR
fi

sketchybar --set $NAME icon="$ICON" \
                 icon.color=$COLOR \
                 label=""