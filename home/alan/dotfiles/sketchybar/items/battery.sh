#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=120 \
                        script="$PLUGIN_DIR/battery.sh" \
                        click_script="open -b com.apple.SystemPreferences /System/Library/PreferencePanes/EnergySaver.prefPane" \
                        background.color=$ITEM_BG_COLOR \
                        background.corner_radius=6 \
                        background.height=26 \
                        background.padding_left=4 \
                        background.padding_right=4 \
                        icon.padding_left=8 \
                        label.padding_right=8 \
           --subscribe battery system_woke power_source_change mouse.entered mouse.exited