#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8")

for i in "${!SPACE_ICONS[@]}"
do
  sid="$(($i+1))"
  
  sketchybar --add item aerospace."$sid" left \
             --set aerospace."$sid" script="$PLUGIN_DIR/space.sh" \
                                    click_script="aerospace workspace $sid" \
                                    icon="" \
                                    label.drawing=off \
                                    icon.background.color=$ICON_COLOR \
                                    icon.background.height=10 \
                                    icon.background.corner_radius=10 \
                                    icon.background.drawing=on \
                                    icon.padding_left=0 \
                                    icon.padding_right=0 \
                                    label.padding_left=0 \
                                    label.padding_right=0 \
                                    icon.padding_right=5 \
                                    icon.padding_left=5 \
             --subscribe aerospace."$sid" aerospace_workspace_change
done

sketchybar --add item space_separator left \
           --set space_separator icon="" \
                                 icon.color=$GREY \
                                 icon.padding_left=4 \
                                 label.drawing=off \
                                 background.drawing=off