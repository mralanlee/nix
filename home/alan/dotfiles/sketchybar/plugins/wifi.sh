#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

# Check if WiFi interface has an IP address (more reliable than networksetup)
WIFI_IP=$(ifconfig en0 2>/dev/null | grep "inet " | awk '{print $2}')
WIFI_STATUS=$(ifconfig en0 2>/dev/null | grep "status:" | awk '{print $2}')

# Try to get SSID
SSID=$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //')

if [[ -n "$WIFI_IP" ]] && [[ "$WIFI_STATUS" == "active" ]]; then
  ICON="󰤨"
  LABEL=""
  COLOR=$ICON_COLOR
else
  ICON="󰤭"
  LABEL=""
  COLOR=$RED
fi

sketchybar --set $NAME icon="$ICON" \
                 icon.color=$COLOR \
                 label="$LABEL"