#!/bin/bash
# ── asus-profile.sh ───────────────────────────────────────  
# Description: Display current ASUS power profile with color
# Usage: Called by Waybar `custom/asus-profile`
# Dependencies: asusctl, awk
# ──────────────────────────────────────────────────────────  

profile=$(asusctl profile -p | awk '/Active profile/ {print $NF}')
text="󱓻"

case "$profile" in
  Performance)
    echo "<span foreground='#bf616a' size='large' font='JetBrainsMono Nerd Font Mono'>$text</span>"
    ;;
  Balanced)
    echo "<span foreground='#fab387' size='large' font='JetBrainsMono Nerd Font Mono'>$text</span>"
    ;;
  Quiet)
    echo "<span size='large' font='JetBrainsMono Nerd Font Mono'>$text</span>"
    ;;
  *)
    echo "<span size='large' font='JetBrainsMono Nerd Font Mono'>$text</span>"
    ;;
esac
