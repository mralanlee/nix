#!/bin/bash

sketchybar --add item wifi right \
           --set wifi script="$PLUGIN_DIR/wifi.sh" \
                     click_script="open -b com.apple.systempreferences /System/Library/PreferencePanes/Network.prefPane" \
                     update_freq=5 \
                     background.color=$ITEM_BG_COLOR \
                     background.corner_radius=6 \
                     background.height=26 \
                     background.padding_left=4 \
                     background.padding_right=4 \
                     icon.padding_left=8 \
                     label.padding_right=8 \
           --subscribe wifi wifi_change