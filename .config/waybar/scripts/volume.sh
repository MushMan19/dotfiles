#!/bin/bash
# ── volume.sh ─────────────────────────────────────────────
# Description: Shows current audio volume with ASCII bar + tooltip
# Usage: Waybar `custom/volume` every 1s
# Dependencies: wpctl, awk, bc, printf
# Font: Electroharmonix
# ──────────────────────────────────────────────────────────

# Get raw volume and mute status once
vol_line=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
vol_raw=$(echo "$vol_line" | awk '{ print $2 }')
is_muted=$(echo "$vol_line" | grep -q -i MUTED && echo true || echo false)

# Ensure valid number
if ! printf '%s' "$vol_raw" | grep -q '^[0-9]*\(\.[0-9]\+\)\?$'; then
  vol_raw=0
fi

# Convert to integer 0–100
vol_int=$(awk -v v="$vol_raw" 'BEGIN{printf "%d", v*100}')

# Get sink description (human-readable)
sink=$(wpctl status 2>/dev/null | awk '/Sinks:/,/Sources:/' | grep '\*' | cut -d'.' -f2- | sed 's/^\s*//; s/\[.*//' )
[ -z "$sink" ] && sink="Default Audio Sink"

# Choose icon
if [ "$is_muted" = true ]; then
  icon=" "
  vol_int=0
elif [ "$vol_int" -lt 10 ]; then
  icon=" "
elif [ "$vol_int" -lt 50 ]; then
  icon=" "
else
  icon=" "
fi

# ASCII bar (consistent width)
total=10
filled=$((vol_int / (100 / total)))
[ "$filled" -lt 0 ] && filled=0
[ "$filled" -gt "$total" ] && filled=$total
empty=$((total - filled))

bar=""
pad=""
if [ "$filled" -gt 0 ]; then
  for _ in $(seq 1 "$filled"); do bar="${bar}█"; done
fi
if [ "$empty" -gt 0 ]; then
  for _ in $(seq 1 "$empty"); do pad="${pad}░"; done
fi
ascii_bar="[$bar$pad]"

# Colors
if [ "$is_muted" = true ] || [ "$vol_int" -lt 10 ]; then
  fg="#bf616a" # red
elif [ "$vol_int" -lt 50 ]; then
  fg="#fab387" # orange
elif [ "$vol_int" -lt 100 ]; then
  fg="#56b6c2" # cyan
else
  fg="#bf616a" # red
fi

# Tooltip
if [ "$is_muted" = true ]; then
  tooltip="Audio: Muted\nOutput: $sink"
else
  tooltip="Audio: ${vol_int}%\nOutput: $sink"
fi

# Fixed-width percentage
percent_str=$(printf "%3d%%" "$vol_int")

# JSON output
printf '%s\n' "{\"text\":\"<span font='Electroharmonix'><span foreground='$fg'>$icon</span></span>\",\"tooltip\":\"$tooltip\"}"
