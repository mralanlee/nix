#!/bin/bash

sketchybar --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
                       click_script="open -a 'Audio MIDI Setup'" \
                       background.color=$ITEM_BG_COLOR \
                       background.corner_radius=6 \
                       background.height=26 \
                       background.padding_left=4 \
                       background.padding_right=4 \
                       icon.padding_left=8 \
                       label.padding_right=8 \
           --subscribe volume volume_change