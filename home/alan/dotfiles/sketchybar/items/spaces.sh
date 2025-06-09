#!/bin/bash

SPACE_SIDS=(1 2 3 4 5 6 7 8)

for i in "${!SPACE_SIDS[@]}"
do
  sid="$(($i+1))"
  
  sketchybar --add space space.$sid left \
             --set space.$sid space=$sid \
                              icon=$sid \
                              label.drawing=off \
                              click_script="aerospace workspace $sid" \
                              background.color=$ITEM_BG_COLOR \
                              background.corner_radius=6 \
                              background.height=26 \
                              background.border_width=1 \
                              background.border_color=$ITEM_BORDER_COLOR \
                              background.padding_left=2 \
                              background.padding_right=2 \
                              icon.color=$ICON_COLOR \
                              icon.highlight_color=$HIGHLIGHT_COLOR \
                              icon.font="$NERD_FONT:Bold:14.0" \
                              icon.padding_left=8 \
                              icon.padding_right=8
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