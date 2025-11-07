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
    fg="#bf616a"
    ;;
  Balanced)
    fg="#fab387"
    ;;
  Quiet)
    fg="#CED7F2"
    ;;
  *)
    fg="#ffffff"
    ;;
esac

echo "<span foreground='$fg' size='large' font='JetBrainsMono Nerd Font Mono'>$text</span>"