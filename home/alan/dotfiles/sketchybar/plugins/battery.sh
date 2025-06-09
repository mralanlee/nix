#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

# Battery icons using Nerd Font icons
if [[ $CHARGING != "" ]]; then
  ICON="󰂄"
  COLOR=$ACTIVE_COLOR
elif [[ $PERCENTAGE -gt 80 ]]; then
  ICON="󰁹"
  COLOR=$ICON_COLOR
elif [[ $PERCENTAGE -gt 60 ]]; then
  ICON="󰂀"
  COLOR=$ICON_COLOR
elif [[ $PERCENTAGE -gt 40 ]]; then
  ICON="󰁾"
  COLOR=$ICON_COLOR
elif [[ $PERCENTAGE -gt 20 ]]; then
  ICON="󰁻"
  COLOR=$YELLOW
else
  ICON="󰁺"
  COLOR=$RED
fi

sketchybar --set $NAME icon="$ICON" \
                 icon.color=$COLOR \
                 label=""