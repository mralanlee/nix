#!/bin/bash

SPACE_SIDS=(1 2 3 4 5 6 7 8)

for i in "${!SPACE_SIDS[@]}"
do
  sid="$(($i+1))"
  
  sketchybar --add space space.$sid left \
             --set space.$sid space=$sid \
                              icon="" \
                              label.drawing=off \
                              click_script="aerospace workspace $sid" \
                              background.color=$ITEM_BG_COLOR \
                              background.corner_radius=10 \
                              background.height=12 \
                              background.border_width=0 \
                              background.padding_left=3 \
                              background.padding_right=3 \
                              icon.background.color=$ICON_COLOR \
                              icon.background.height=8 \
                              icon.background.corner_radius=8 \
                              icon.background.drawing=on \
                              icon.padding_left=4 \
                              icon.padding_right=4
done

sketchybar --add item space_separator left \
           --set space_separator icon="" \
                                 icon.color=$GREY \
                                 icon.padding_left=4 \
                                 label.drawing=off \
                                 background.drawing=off

# Add workspace updater
sketchybar --add item workspace_updater left \
           --set workspace_updater drawing=off \
                                  script="$PLUGIN_DIR/space.sh" \
           --subscribe workspace_updater space_change