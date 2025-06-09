#!/bin/bash

sketchybar --add item calendar right \
           --set calendar update_freq=30 \
                         icon=󰸗 \
                         script="$PLUGIN_DIR/calendar.sh" \
                         background.color=$ITEM_BG_COLOR \
                         background.corner_radius=6 \
                         background.height=26 \
                         background.padding_left=4 \
                         background.padding_right=4 \
                         icon.color=$ICON_COLOR \
                         label.color=$LABEL_COLOR \
                         icon.padding_left=8 \
                         label.padding_right=8