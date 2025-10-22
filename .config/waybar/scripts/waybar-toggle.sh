#!/usr/bin/env bash

# Add 'active' class to Waybar via swaymsg or hyprctl (Waybar supports SIGUSR1 for reload)
# Show bar
pkill -RTMIN+1 waybar  # Example signal; Waybar interprets SIGRTMIN+n signals

# Keep it visible for 2-3 seconds
sleep 3

# Hide bar again
# Waybar will revert automatically via CSS (remove 'active' class)
