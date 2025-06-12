#!/bin/bash

sketchybar --add item memory right \
           --set memory update_freq=5 \
                       script="$PLUGIN_DIR/memory.sh" \
                       icon="󰍛" \
                       background.color=$ITEM_BG_COLOR \
                       background.corner_radius=6 \
                       background.height=26 \
                       background.padding_left=4 \
                       background.padding_right=4 \
                       icon.padding_left=8 \
                       label.padding_right=8