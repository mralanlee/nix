#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

# Get battery info
BATTERY_INFO=$(pmset -g batt)
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')
TIME_REMAINING=$(echo "$BATTERY_INFO" | grep -o '\d\+:\d\+' | head -1)

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

# Handle mouse events - show detailed info in label
case "$SENDER" in
  "mouse.entered")
    if [[ $CHARGING != "" ]]; then
      if [[ $TIME_REMAINING != "" ]]; then
        HOVER_LABEL="${PERCENTAGE}% - ${TIME_REMAINING} until full"
      else
        HOVER_LABEL="${PERCENTAGE}% - Charging"
      fi
    else
      if [[ $TIME_REMAINING != "" ]]; then
        HOVER_LABEL="${PERCENTAGE}% - ${TIME_REMAINING} left"
      else
        HOVER_LABEL="${PERCENTAGE}%"
      fi
    fi
    sketchybar --set $NAME label="$HOVER_LABEL"
    exit 0
    ;;
  "mouse.exited")
    sketchybar --set $NAME label=""
    exit 0
    ;;
esac

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