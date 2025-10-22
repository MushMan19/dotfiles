#!/bin/bash
active_class=$(hyprctl activewindow | grep 'class:' | awk '{print $2}')
if [[ "$active_class" == "WireMix"]]; then
    hyprctl dispatch closewindow
fi
