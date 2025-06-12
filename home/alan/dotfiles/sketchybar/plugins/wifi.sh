#!/bin/bash

source "$CONFIG_DIR/globalstyles.sh"

# Check if WiFi interface has an IP address and is active
WIFI_IP=$(ifconfig en0 2>/dev/null | grep "inet " | awk '{print $2}')
WIFI_STATUS=$(ifconfig en0 2>/dev/null | grep "status:" | awk '{print $2}')

# Try to get SSID using multiple methods
SSID=$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //' | grep -v "You are not associated")
if [[ -z "$SSID" ]]; then
  # Fallback method using system_profiler
  SSID=$(system_profiler SPAirPortDataType 2>/dev/null | awk -F': ' '/^\s*Current Network:/{getline; if($0 ~ /^\s*[^:]+:/) print $1; else print $2}' | xargs)
fi

# Consider connected if we have an IP and active status, regardless of SSID detection
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