#!/bin/bash

export CONFIG_DIR="$HOME/.config/sketchybar"
export PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

exec /run/current-system/sw/bin/sketchybar --config "$CONFIG_DIR/sketchybarrc"